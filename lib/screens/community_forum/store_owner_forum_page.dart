import 'select_chat_room_page.dart';
import 'package:flutter/material.dart';
import '../../services/avatar_color.dart';
import '../../services/chat_room_storage_service.dart';

class StoreOwnerForumPage extends StatefulWidget {
  const StoreOwnerForumPage({super.key});

  @override
  State<StoreOwnerForumPage> createState() => _StoreOwnerForumPageState();
}

class _StoreOwnerForumPageState extends State<StoreOwnerForumPage> {
  // TODO: Replace with actual logged-in user's name from auth provider
  final String userName = 'Tyrone';
  static const int _maxMessages = 100000;

  // The currently selected chat room ID (default to 'gen-discussion-001')
  String _currentRoomId = 'gen-discussion-001';
  List<Map<String, String>> _messages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _loading = true;
    });
    final loaded = await ChatRoomStorageService.loadRoomMessages(_currentRoomId);
    setState(() {
      _messages = loaded.isNotEmpty ? loaded : _getInitialMessages(_currentRoomId);
      _loading = false;
    });
  }

  List<Map<String, String>> _getInitialMessages(String roomId) {
    // Provide placeholder data for General Discussion only
    if (roomId == 'gen-discussion-001') {
      return [
        {
          'user': 'Alice',
          'message': 'Welcome to the community forum! 🎉',
          'avatar': '',
        },
        {
          'user': 'Bob',
          'message': 'Does anyone have tips for boosting store sales?',
          'avatar': '',
        },
        {
          'user': 'Carol',
          'message': 'Check out the new marketing tools in the dashboard.',
          'avatar': '',
        },
        {
          'user': 'Dave',
          'message': 'Thanks Carol! That helped a lot.',
          'avatar': '',
        },
      ];
    }
    return [];
  }

  Future<void> _addMessage(String user, String message, {String avatar = ''}) async {
    setState(() {
      if (_messages.length >= _maxMessages) {
        _messages.removeAt(0);
      }
      _messages.add({'user': user, 'message': message, 'avatar': avatar});
    });
    await ChatRoomStorageService.saveRoomMessages(_currentRoomId, _messages);
  }

  Future<void> _switchRoom(String roomId) async {
    if (_currentRoomId == roomId) return;
    setState(() {
      _currentRoomId = roomId;
      _loading = true;
    });
    final loaded = await ChatRoomStorageService.loadRoomMessages(roomId);
    setState(() {
      _messages = loaded.isNotEmpty ? loaded : _getInitialMessages(roomId);
      _loading = false;
    });
  }

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
              onPressed: () async {
                // Navigate to the SelectChatRoomPage and wait for a result
                final roomId = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectChatRoomPage(),
                  ),
                );
                if (roomId is String && roomId.isNotEmpty) {
                  await _switchRoom(roomId);
                }
              },
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.only(
                top: 16,
                left: 12,
                right: 12,
                bottom: 70,
              ),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _SpeechBubbleMessage(
                  user: msg['user'] ?? '',
                  message: msg['message'] ?? '',
                  avatar: msg['avatar'] ?? '',
                );
              },
            ),
      bottomNavigationBar: _MessageInputBar(
        onSend: (String message) {
          _addMessage(userName, message, avatar: '');
        },
      ),
    );
  }
}

class _SpeechBubbleMessage extends StatelessWidget {
  final String user;
  final String message;
  final String avatar;

  const _SpeechBubbleMessage({
    required this.user,
    required this.message,
    this.avatar = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: avatar.isNotEmpty
              ? CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(avatar),
                )
              : getUserAvatar(user, radius: 20),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageInputBar extends StatefulWidget {
  final void Function(String message)? onSend;
  const _MessageInputBar({this.onSend});

  @override
  State<_MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<_MessageInputBar> {
  final FocusNode _focusNode = FocusNode();
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
      final pattern = RegExp(
        r'\b' + RegExp.escape(word) + r'\b',
        caseSensitive: false,
      );
      censored = censored.replaceAllMapped(
        pattern,
        (match) => '*' * match.group(0)!.length,
      );
    }
    return censored;
  }

  bool _expanded = false;
  final TextEditingController _controller = TextEditingController();
  static const int _maxLength = 2000;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
                // Request focus so the cursor appears immediately
                Future.delayed(Duration.zero, () {
                  _focusNode.requestFocus();
                });
              },
              child: _expanded
                  ? TextField(
                      focusNode: _focusNode,
                      controller: _controller,
                      maxLines: 5,
                      minLines: 1,
                      maxLength: _maxLength,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.6,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
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
                  return;
                }
                final censoredMessage = _censorMessage(_controller.text.trim());
                _controller.clear();
                setState(() {
                  _expanded = false;
                });
                if (widget.onSend != null) {
                  widget.onSend!(censoredMessage);
                }
              },
              splashRadius: 22,
            ),
          ),
        ],
      ),
    );
  }
}
