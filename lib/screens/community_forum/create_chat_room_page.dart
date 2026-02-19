
import 'package:flutter/material.dart';
import 'chat_room_id_generator.dart';
import '../../reusable_widgets/snackbar.dart';
import 'chat_room_profile_page.dart';

class CreateChatRoomPage extends StatefulWidget {
  @override
  State<CreateChatRoomPage> createState() => _CreateChatRoomPageState();
}

class _CreateChatRoomPageState extends State<CreateChatRoomPage> {
    // TODO: Replace with real user/store data from backend or auth
  // Blacklist of disallowed chat room names (case-insensitive)
  final List<String> _blacklistedNames = [
    'cunt',
    'pussy',
    'fuck',
    'dick',
    'pussy',
    'vagina',
    'penis',
    'sex',
    'cunt',
    'shit',
    'ass',
    'anal',
    'poop',
    'butt',
    'fart',
    'whore',
    'kike',
    'chink',
    'wank',
    'bitch',
    'twat',
  ];

  static const int _maxRoomNameLength = 50;

  final TextEditingController _nameController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showGuidelinesPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Storazaar Community Guidelines'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('To create a chat room, please accept these terms:'),
                SizedBox(height: 12),
                Text(
                  '1. Be respectful and professional.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '   Treat all members with courtesy. Harassment, hate, or discrimination is not allowed.',
                ),
                SizedBox(height: 8),
                Text(
                  '2. Keep discussions business-focused.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '   Conversations should relate to online stores, commerce, and professional growth.',
                ),
                SizedBox(height: 8),
                Text(
                  '3. No prohibited content.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '   Weapons, drugs, pornography, sexual content, violence, racism, or discrimination are strictly forbidden.',
                ),
                SizedBox(height: 8),
                Text(
                  '4. No spam or scams.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '   Do not post misleading information, unsolicited promotions, or fraudulent offers.',
                ),
                SizedBox(height: 8),
                Text(
                  '5. Protect privacy.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '   Do not share personal, sensitive, or confidential information—yours or others’.',
                ),
                SizedBox(height: 8),
                Text(
                  '6. Follow the law and platform rules.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '   All activity must comply with applicable laws and Storazaar policies.',
                ),
                SizedBox(height: 8),
                Text(
                  '7. Report inappropriate behavior.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '   Help keep the community safe by reporting violations.',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Accept & Create',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _actuallyCreateRoom();
              },
            ),
          ],
        );
      },
    );
  }

  void _actuallyCreateRoom() {
    // Generate a random Room ID
    final roomId = generateChatRoomId();
    // TODO: Add backend logic to create chat room with roomId and real user/store info
    showCustomSnackBar(context, 'Chat room created!', positive: true);
    // Navigate to chat room profile page with placeholder/empty user and store info
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomProfilePage(
          roomId: roomId,
          roomName: _nameController.text.trim(),
          userName: '',
          storeName: '',
          domain: '',
          profilePhoto: '',
          storeThumbnail: '',
        ),
      ),
    );
  }

  void _createRoom() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _error = 'Room name cannot be empty.';
      });
      showCustomSnackBar(context, 'Room name cannot be empty.', positive: false);
      return;
    }
    if (name.length > _maxRoomNameLength) {
      setState(() {
        _error = 'Room name cannot exceed $_maxRoomNameLength characters.';
      });
      showCustomSnackBar(context, 'Room name cannot exceed $_maxRoomNameLength characters.', positive: false);
      return;
    }
    // Check blacklist (case-insensitive, substring match)
    final lowerName = name.toLowerCase();
    if (_blacklistedNames.any((b) => lowerName.contains(b.toLowerCase()))) {
      setState(() {
        _error = 'This room name is not allowed.';
      });
      showCustomSnackBar(context, 'This room name is not allowed.', positive: false);
      return;
    }
    _showGuidelinesPopup();
  }

  @override
  Widget build(BuildContext context) {
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
            'Create Chat Room',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Create a chat room to share your ideas, connect with other store owners, and stay up to date with online store stuff.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                // User account tile placeholder (no test data)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade300,
                        child: const Icon(Icons.person, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('(User Name)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                            SizedBox(height: 2),
                            Text('(Store Name)', style: TextStyle(fontSize: 14, color: Colors.black87)),
                            SizedBox(height: 2),
                            Text('(domain.com)', style: TextStyle(fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 48,
                          height: 48,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.store, color: Colors.grey, size: 28),
                        ),
                      ),
                    ],
                  ),
                ),
                // End user account tile
                const Text(
                  'Room Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  cursorColor: Colors.black,
                  maxLength: _maxRoomNameLength,
                  decoration: InputDecoration(
                    hintText: 'Enter chat room name',
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
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                    ),
                    errorText: _error,
                  ),
                  onChanged: (_) {
                    setState(() {
                      if (_error != null) {
                        _error = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'By creating a chat room, you agree to the ',
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/settings/terms-conditions');
                            },
                            child: const Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _nameController.text.trim().isEmpty
                          ? Colors.grey
                          : Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(80, 36),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: _nameController.text.trim().isEmpty
                        ? null
                        : _createRoom,
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
