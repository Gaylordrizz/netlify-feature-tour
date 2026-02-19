
import 'package:flutter/material.dart';
import 'create_chat_room_page.dart';
import '../../reusable_widgets/snackbar.dart';

class SelectChatRoomPage extends StatefulWidget {
	@override
	State<SelectChatRoomPage> createState() => _SelectChatRoomPageState();
}


class _SelectChatRoomPageState extends State<SelectChatRoomPage> {
	final TextEditingController _searchController = TextEditingController();
	final List<Map<String, String>> _chatRooms = [
		{'id': 'gen-discussion-001', 'name': 'General Discussion'},
		{'id': 'store-owners-002', 'name': 'Store Owners'},
		{'id': 'prod-feedback-003', 'name': 'Product Feedback'},
		{'id': 'marketplace-004', 'name': 'Marketplace'},
		{'id': 'support-005', 'name': 'Support'},
	];
	String _search = '';

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

	@override
	Widget build(BuildContext context) {
		// Enhanced search: by chat room name, store name, or store domain
		final filteredRooms = _chatRooms.where((room) {
			final query = _search.toLowerCase();
			final roomName = room['name']?.toLowerCase() ?? '';
			// Try to find a user whose store or domain matches the query
			final userMatch = _users.firstWhere(
				(user) =>
					(user['store']?.toLowerCase().contains(query) ?? false) ||
					(user['domain']?.toLowerCase().contains(query) ?? false),
				orElse: () => {},
			);
			// If userMatch is not empty, check if their chatRoom matches this room
			final userChatRoom = userMatch.isNotEmpty ? userMatch['chatRoom']?.toLowerCase() ?? '' : '';
			return roomName.contains(query) || userChatRoom == roomName;
		}).toList();
		// Find user by domain if search matches
		Map<String, String>? foundUser;
		if (_search.trim().isNotEmpty) {
			foundUser = _users.firstWhere(
				(user) => user['domain']!.toLowerCase().contains(_search.trim().toLowerCase()),
				orElse: () => {},
			);
			if (foundUser.isEmpty) foundUser = null;
		}

		// Show snackbar if no chat rooms found and search is not empty
		if (filteredRooms.isEmpty && _search.trim().isNotEmpty) {
			WidgetsBinding.instance.addPostFrameCallback((_) {
				_showNoChatRoomsSnackBar();
			});
		}

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
									Navigator.push(
										context,
										MaterialPageRoute(builder: (context) => CreateChatRoomPage()),
									);
								},
							),
						),
					],
				),
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
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
						Expanded(
							child: filteredRooms.isEmpty
									? const Center(child: Text('No chat rooms found.'))
									: ListView.builder(
											itemCount: filteredRooms.length,
											itemBuilder: (context, index) {
												final room = filteredRooms[index];
												return ListTile(
													leading: const Icon(Icons.forum, color: Colors.black),
													title: Text(room['name'] ?? ''),
													// Room ID is kept in logic but not shown in UI
													onTap: () {
														// TODO: Implement chat room selection using room['id']
														Navigator.pop(context);
													},
												);
											},
										),
						),
					],
				),
			),
		);
	}
}
