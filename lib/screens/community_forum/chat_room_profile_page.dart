import 'package:flutter/material.dart';

class ChatRoomProfilePage extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String userName;
  final String storeName;
  final String domain;
  final String profilePhoto;
  final String storeThumbnail;


  const ChatRoomProfilePage({
    Key? key,
    required this.roomId,
    required this.roomName,
    required this.userName,
    required this.storeName,
    required this.domain,
    required this.profilePhoto,
    required this.storeThumbnail,
  }) : super(key: key);

  @override
  _ChatRoomProfilePageState createState() => _ChatRoomProfilePageState();
}

class _ChatRoomProfilePageState extends State<ChatRoomProfilePage> with SingleTickerProviderStateMixin {
    final GlobalKey _accountTileKey = GlobalKey();
    OverlayEntry? _accountPopupOverlay;

    void _showAccountPopup() {
      if (_accountPopupOverlay != null) return;
      final RenderBox? tileBox = _accountTileKey.currentContext?.findRenderObject() as RenderBox?;
      final RenderBox? overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
      if (tileBox == null || overlay == null) return;
      final Offset tilePosition = tileBox.localToGlobal(Offset.zero, ancestor: overlay);
      const double popupWidth = 160;
      double left = tilePosition.dx + tileBox.size.width - popupWidth;
      if (left < 8) left = 8;
      double top = tilePosition.dy + tileBox.size.height + 8;
      _accountPopupOverlay = OverlayEntry(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeAccountPopup,
                child: Container(),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              width: popupWidth,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        title: const Text('Delete Room',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        onTap: () {
                          _removeAccountPopup();
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Chat Room'),
                              content: const Text('Are you sure you want to delete this chat room? This action cannot be undone.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Add backend delete logic here
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      Overlay.of(context).insert(_accountPopupOverlay!);
    }

    void _removeAccountPopup() {
      _accountPopupOverlay?.remove();
      _accountPopupOverlay = null;
    }
  int _userCount = 1;
  late AnimationController _dotController;
  late Animation<double> _dotOpacity;
  @override
  void initState() {
    super.initState();
    _userCount = 1 + (DateTime.now().second % 4); // Simulate 1-4 users
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _dotOpacity = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(
      parent: _dotController,
      curve: Curves.easeInOut,
    ));
    // Simulate live user count changes
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;
      setState(() {
        // Randomly change user count between 1 and 4
        _userCount = 1 + (DateTime.now().millisecondsSinceEpoch % 4);
      });
      return true;
    });
  }

  @override
  @override
  void dispose() {
    _dotController.dispose();
    _removeAccountPopup();
    super.dispose();
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
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFC0CB), Color(0xFFFFD700)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'Chat Room Profile',
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        widget.roomName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    // ...no delete button here...
                  ],
                ),
                const SizedBox(height: 8),
                Text('Room ID: ${widget.roomId}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 16),
                // Live presence indicator
                Row(
                  children: [
                    AnimatedBuilder(
                      animation: _dotOpacity,
                      builder: (context, child) => Opacity(
                        opacity: _dotOpacity.value,
                        child: child,
                      ),
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _userCount == 1
                          ? '1 person in chat room'
                          : '$_userCount people in chat room',
                      style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // User account tile
                GestureDetector(
                  key: _accountTileKey,
                  onTap: () {
                    if (_accountPopupOverlay == null) {
                      _showAccountPopup();
                    } else {
                      _removeAccountPopup();
                    }
                  },
                  child: Container(
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
                          backgroundImage: AssetImage(widget.profilePhoto),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                              const SizedBox(height: 2),
                              Text(widget.storeName, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                              const SizedBox(height: 2),
                              Text(widget.domain, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            widget.storeThumbnail,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // End user account tile
                // Additional chat room info or actions can go here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
