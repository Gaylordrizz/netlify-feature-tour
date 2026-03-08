
import 'package:flutter/material.dart';
import 'create_chat_room_page.dart';
import '../../reusable_widgets/snackbar.dart';
import '../../services/communities_logic.dart';

// Duplicate class removed
class SelectChatRoomPage extends StatefulWidget {
	const SelectChatRoomPage({Key? key}) : super(key: key);
	@override
	State<SelectChatRoomPage> createState() => _SelectChatRoomPageState();
}

class _SelectChatRoomPageState extends State<SelectChatRoomPage> {
	final TextEditingController _searchController = TextEditingController();
	String _search = '';
	List<dynamic> _foundRooms = [];
	bool _searching = false;

	// Mock user/store data
	final List<Map<String, String>> _users = [
		{
			'name': 'Alice Smith',
			'store': 'Alice Boutique',
			'domain': 'aliceboutique.com',
			'chatRoom': 'Alice Boutique Chat',
		},
		{
			'name': 'Bob Jones',
			'store': 'Bob Electronics',
			'domain': 'bobelectronics.com',
			'chatRoom': 'Bob Electronics Chat',
		},
		{
			'name': 'Carol Lee',
			'store': 'Carol Crafts',
			'domain': 'carolcrafts.com',
			'chatRoom': '',
		},
	];

	@override
	void dispose() {
		_searchController.dispose();
		super.dispose();
	}

	void _showNoChatRoomsSnackBar() {
		showCustomSnackBar(context, 'No chat rooms found.', positive: false);
	}

	Future<void> _searchRooms(String query) async {
		setState(() {
			_searching = true;
		});
		try {
			final results = await CommunityService.searchCommunities(query);
			setState(() {
				_foundRooms = results;
				_searching = false;
			});
			if (results.isEmpty && query.trim().isNotEmpty) {
				WidgetsBinding.instance.addPostFrameCallback((_) {
					_showNoChatRoomsSnackBar();
				});
			}
		} catch (e) {
			setState(() {
				_foundRooms = [];
				_searching = false;
			});
			WidgetsBinding.instance.addPostFrameCallback((_) {
				showCustomSnackBar(context, 'Error searching chat rooms.', positive: false);
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		// Find user by domain if search matches
		Map<String, String>? foundUser;
		if (_search.trim().isNotEmpty) {
			foundUser = _users.firstWhere(
				(user) => user['domain']!.toLowerCase().contains(_search.trim().toLowerCase()),
				orElse: () => {},
			);
			if (foundUser.isEmpty) foundUser = null;
		}

		// --- MOCK DATA for Top 20 Chat Rooms ---
		// In production, this should be fetched from backend and sorted by traffic
		final List<Map<String, String>> topChatRooms = List.generate(20, (i) => {
			'storeName': 'Store ${i + 1}',
			'storeDomain': 'store${i + 1}.storazaar.com',
			'chatRoomId': 'room-${i + 1}',
			'avatarUrl': '', // Replace with actual avatar URL if available
			'storeThumbnailUrl': '', // Replace with actual thumbnail URL if available
		});

		return Scaffold(
			appBar: PreferredSize(
				preferredSize: const Size.fromHeight(kToolbarHeight),
				child: AppBar(
					elevation: 1,
					backgroundColor: Colors.transparent,
					centerTitle: true,
					flexibleSpace: Container(
						decoration: const BoxDecoration(
							gradient: LinearGradient(
								colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)], // pink to gold
								begin: Alignment.topLeft,
								end: Alignment.bottomRight,
							),
						),
					),
					title: const Text(
						'Select Chat Room',
						style: TextStyle(
							color: Colors.black,
							fontWeight: FontWeight.bold,
							fontSize: 20,
						),
					),
					actions: [
						Padding(
							padding: const EdgeInsets.only(right: 12.0),
							child: TextButton.icon(
								icon: const Icon(Icons.add, color: Colors.black),
								label: const Text('Create', style: TextStyle(color: Colors.black)),
								style: TextButton.styleFrom(
									backgroundColor: Colors.white,
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(6),
										side: const BorderSide(color: Colors.black, width: 1),
									),
								),
								onPressed: () {
									// Robust defaults for CreateChatRoomPage navigation
									final userName = 'Tyrone';
									final storeName = 'Tyrone Store';
									final storeThumbnailUrl = '';
									final domain = 'tyronestore.com';
									// Pass initial avatar marker for any pro user
									String avatarUrl = '';
									if (userName.isNotEmpty) {
										avatarUrl = 'initial:${userName.trim()[0].toUpperCase()}';
									}
									Navigator.push(
										context,
										MaterialPageRoute(
											builder: (context) => CreateChatRoomPage(
												userName: (userName.isNotEmpty) ? userName : '(No Name)',
												avatarUrl: avatarUrl,
												storeName: (storeName.isNotEmpty) ? storeName : '(No Store Yet)',
												storeThumbnailUrl: (storeThumbnailUrl.isNotEmpty) ? storeThumbnailUrl : '',
												domain: (domain.isNotEmpty) ? domain : '(no-domain)',
											),
										),
									);
								},
							),
						),
					],
				),
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: SingleChildScrollView(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							TextField(
								controller: _searchController,
								cursorColor: Colors.black,
								decoration: InputDecoration(
									hintText: 'Search chat rooms or store domain...',
									prefixIcon: const Icon(Icons.search),
									border: OutlineInputBorder(
										borderRadius: BorderRadius.circular(10),
										borderSide: const BorderSide(color: Colors.black, width: 1),
									),
									enabledBorder: OutlineInputBorder(
										borderRadius: BorderRadius.circular(10),
										borderSide: const BorderSide(color: Colors.black, width: 1),
									),
									focusedBorder: OutlineInputBorder(
										borderRadius: BorderRadius.circular(10),
										borderSide: const BorderSide(color: Colors.black, width: 2),
									),
								),
								onSubmitted: (val) {
									setState(() {
										_search = val;
									});
									_searchRooms(val);
								},
							),
							if (foundUser != null) ...[
								const SizedBox(height: 18),
								const Text('Store Owner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
								const SizedBox(height: 8),
								Card(
									elevation: 2,
									shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
									child: ListTile(
										leading: const CircleAvatar(child: Icon(Icons.person)),
										title: Text(foundUser['name'] ?? ''),
										subtitle: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Text(foundUser['store'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500)),
												Text(foundUser['domain'] ?? '', style: const TextStyle(color: Colors.grey)),
												if ((foundUser['chatRoom'] ?? '').isNotEmpty)
													Padding(
														padding: const EdgeInsets.only(top: 6.0),
														child: Row(
															children: [
																const Icon(Icons.forum, color: Colors.pink, size: 18),
																const SizedBox(width: 6),
																Text(foundUser['chatRoom']!, style: const TextStyle(fontWeight: FontWeight.bold)),
															],
														),
													),
											],
										),
										onTap: () {
											// TODO: Open chat with this user
											Navigator.pop(context);
										},
									),
								),
							],
							const SizedBox(height: 18),
							const Text(
								'Available Chat Rooms',
								style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
							),
							const SizedBox(height: 8),
							_searching
									? const Center(child: CircularProgressIndicator())
									: Column(
											children: _foundRooms.isEmpty
													? [const Center(child: Text('No chat rooms found.'))]
													: _foundRooms.map((room) {
															// room is a Community object
															return ListTile(
																leading: const Icon(Icons.forum, color: Colors.black),
																title: Text(room.name ?? ''),
																subtitle: Text(room.slug ?? ''),
																onTap: () {
																	Navigator.pop(context, room.id);
																},
															);
														}).toList(),
										),

							// --- TOP 20 CHAT ROOMS SECTION ---
							const SizedBox(height: 24),
							const Text(
								'Top 100 Chat Rooms on Storazaar (last 30 days)',
								style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
							),
							const SizedBox(height: 8),
							// Use a Column for the test top chat rooms, not a scrollable ListView
							Column(
								children: List.generate(topChatRooms.length, (index) {
									final room = topChatRooms[index];
									return Column(
										children: [
											InkWell(
												onTap: () {
													// TODO: Navigate to chat room using room['chatRoomId']
													Navigator.pop(context);
												},
												child: Padding(
													padding: const EdgeInsets.symmetric(vertical: 8.0),
													child: Row(
														children: [
															// Circle photo (avatar)
															CircleAvatar(
																backgroundImage: (room['avatarUrl'] != null && room['avatarUrl']!.isNotEmpty)
																		? NetworkImage(room['avatarUrl']!)
																		: null,
																child: (room['avatarUrl'] == null || room['avatarUrl']!.isEmpty)
																		? const Icon(Icons.store, color: Colors.white)
																		: null,
																backgroundColor: Colors.pinkAccent,
															),
															const SizedBox(width: 12),
															// Store name and domain
															Expanded(
																child: Column(
																	crossAxisAlignment: CrossAxisAlignment.start,
																	children: [
																		Text(
																			room['storeName'] ?? '',
																			style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
																		),
																		Text(
																			room['storeDomain'] ?? '',
																			style: const TextStyle(color: Colors.grey, fontSize: 13),
																		),
																	],
																),
															),
															// Chat room id
															Padding(
																padding: const EdgeInsets.symmetric(horizontal: 8.0),
																child: Text(
																	room['chatRoomId'] ?? '',
																	style: const TextStyle(fontSize: 13, color: Colors.black54),
																),
															),
															// Store thumbnail (far right)
															ClipRRect(
																borderRadius: BorderRadius.circular(8),
																child: (room['storeThumbnailUrl'] != null && room['storeThumbnailUrl']!.isNotEmpty)
																		? Image.network(
																				room['storeThumbnailUrl']!,
																				width: 40,
																				height: 40,
																				fit: BoxFit.cover,
																			)
																		: Container(
																				width: 40,
																				height: 40,
																				color: Colors.grey[300],
																				child: const Icon(Icons.image, color: Colors.grey),
																			),
															),
														],
													),
												),
											),
											if (index != topChatRooms.length - 1)
												const Divider(height: 1),
										],
									);
								}),
							),
						],
					),
				),
			),
		);
	}
}
