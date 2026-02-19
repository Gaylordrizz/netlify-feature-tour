
import 'package:flutter/material.dart';
import 'select_chat_room_page.dart';
import '../../reusable_widgets/snackbar.dart';

class StoreOwnerForumPage extends StatelessWidget {
	const StoreOwnerForumPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			appBar: PreferredSize(
				preferredSize: const Size.fromHeight(kToolbarHeight),
				child: AppBar(
					elevation: 1,
					backgroundColor: Colors.transparent,
					flexibleSpace: Container(
						decoration: const BoxDecoration(
							gradient: LinearGradient(
								colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
								begin: Alignment.topLeft,
								end: Alignment.bottomRight,
							),
						),
					),
					leading: IconButton(
						icon: const Icon(Icons.arrow_back, color: Colors.black),
						onPressed: () => Navigator.of(context).pop(),
					),
					centerTitle: true,
					title: const Text(
						'Community Forum',
						style: TextStyle(
							color: Colors.black,
							fontWeight: FontWeight.bold,
							fontSize: 20,
						),
					),
					actions: [
						IconButton(
							icon: const Icon(Icons.list_alt, color: Colors.black, size: 24),
							tooltip: 'Select Chat Room',
							onPressed: () {
								Navigator.push(
									context,
									MaterialPageRoute(
										builder: (context) => SelectChatRoomPage(),
									),
								);
							},
						),
					],
				),
			),
			body: const Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Padding(
							padding: EdgeInsets.symmetric(horizontal: 16.0),
							child: Text(
								'No chat data. Connect to backend to see users and messages.',
								textAlign: TextAlign.center,
								style: TextStyle(fontSize: 16, color: Colors.black87),
							),
						),
					],
				),
			),
			bottomNavigationBar: _MessageInputBar(),
		);
			
	}
}

class _MessageInputBar extends StatefulWidget {
	@override
	State<_MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<_MessageInputBar> {
		// Blacklist of words to censor
		final List<String> _blacklist = [
			'cadaver',
			'cunt',
			'death',
			'porn',
			'pornography',
			'nigga',
			'taliban',
			'goddamn',
			'pussy',
			'fuck',
			'dick',
			'vagina',
			'penis',
			'sex',
			'shit',
			'ass',
			'anal',
			'poop',
      'fucked',
      'penis',
			'butt',
      'cum',
      'jizz',
      'poo',
      'pee',
      'piss',
      'faggot',
      'jew',
      'hate',
			'fart',
			'whore',
			'kike',
			'chink',
			'wank',
			'bitch',
			'twat',
			'die',
			'died',
			'dying',
			'hell',
			'kill',
			'killed',
			'killing',
			'nigger',
		];

		String _censorMessage(String message) {
			String censored = message;
			for (final word in _blacklist) {
				// Use word boundaries and case-insensitive matching
				final pattern = RegExp(r'\b' + RegExp.escape(word) + r'\b', caseSensitive: false);
				censored = censored.replaceAllMapped(pattern, (match) => '*' * match.group(0)!.length);
			}
			return censored;
		}
	bool _expanded = false;
	final TextEditingController _controller = TextEditingController();
	static const int _maxLength = 2000;

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return AnimatedContainer(
			duration: const Duration(milliseconds: 200),
			padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
			color: Colors.white,
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.end,
				children: [
					Expanded(
						child: GestureDetector(
							onTap: () {
								setState(() {
									_expanded = true;
								});
							},
							child: _expanded
									? TextField(
											controller: _controller,
											maxLines: 5,
											minLines: 1,
											maxLength: _maxLength,
											cursorColor: Colors.black,
											decoration: InputDecoration(
												hintText: 'Type your message...',
												border: OutlineInputBorder(
													borderRadius: BorderRadius.circular(10),
													borderSide: const BorderSide(color: Colors.black, width: 1.2),
												),
												enabledBorder: OutlineInputBorder(
													borderRadius: BorderRadius.circular(10),
													borderSide: const BorderSide(color: Colors.black, width: 1.2),
												),
												focusedBorder: OutlineInputBorder(
													borderRadius: BorderRadius.circular(10),
													borderSide: const BorderSide(color: Colors.black, width: 1.6),
												),
												contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
												counterText: '',
											),
										)
									: Container(
											height: 38,
											alignment: Alignment.centerLeft,
											decoration: BoxDecoration(
												color: Colors.grey[100],
												borderRadius: BorderRadius.circular(10),
											),
											padding: const EdgeInsets.symmetric(horizontal: 12),
											child: const Text(
												'Add a message...',
												style: TextStyle(color: Colors.black54, fontSize: 15),
											),
										),
						),
					),
					const SizedBox(width: 8),
					Container(
						height: 38,
						width: 38,
						decoration: BoxDecoration(
							color: Colors.blue,
							borderRadius: BorderRadius.circular(10),
						),
						child: IconButton(
							icon: const Icon(Icons.send, color: Colors.white, size: 20),
							onPressed: () {
								if (_controller.text.trim().isEmpty) {
									showCustomSnackBar(context, 'Message cannot be empty.', positive: false);
									return;
								}
								// Censor blacklisted words before sending
								final censoredMessage = _censorMessage(_controller.text.trim());
								_controller.clear();
								setState(() {
									_expanded = false;
								});
								showCustomSnackBar(context, 'Message sent: $censoredMessage', positive: true);
							},
							splashRadius: 22,
						),
					),
				],
			),
		);
	}
}
