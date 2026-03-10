import 'package:flutter/material.dart';
import '../../services/avatar_color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Custom Snackbar Widget
void showCustomSnackbar(BuildContext context, String message, {bool success = true}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 40,
      left: 24,
      right: 24,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.cancel,
                color: success ? Colors.green : Colors.red,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
}

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
    late String _roomName;

    Future<bool> _updateRoomName(String newName) async {
      final supabase = Supabase.instance.client;
      try {
        final response = await supabase
            .from('communities')
            .update({'name': newName})
            .eq('id', widget.roomId)
            .select();
        if (response.isNotEmpty) {
          setState(() {
            _roomName = newName;
          });
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }

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
  @override
  void initState() {
    super.initState();
    _roomName = widget.roomName;
  }

  @override
  @override
  void dispose() {
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
                        _roomName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    // ...no delete button here...
                  ],
                ),
                const SizedBox(height: 8),
                Text('Room ID: ${widget.roomId}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 16),
                // ...existing code...
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
                        getUserAvatar(widget.userName, radius: 28),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                              const SizedBox(height: 2),
                              Text(_roomName, style: const TextStyle(fontSize: 13, color: Colors.grey)),
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

                // Options widget below the room tile, hidden under a ... icon
                Container(
                  width: double.infinity,
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
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz, color: Colors.black, size: 28),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: const [
                              Icon(Icons.edit, color: Colors.black),
                              SizedBox(width: 10),
                              Text('Edit Chat Room', style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: const [
                              Icon(Icons.delete, color: Colors.black),
                              SizedBox(width: 10),
                              Text('Delete Room', style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final TextEditingController _nameController = TextEditingController(text: _roomName);
                              return AlertDialog(
                                title: const Text('Edit Chat Room'),
                                content: TextField(
                                  controller: _nameController,
                                  cursorColor: Colors.black,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: const InputDecoration(
                                    labelText: 'Room Name',
                                    labelStyle: TextStyle(color: Colors.black),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final newName = _nameController.text.trim();
                                      if (newName.isNotEmpty && newName != _roomName) {
                                        // Disable button while updating
                                        FocusScope.of(context).unfocus();
                                        final updated = await _updateRoomName(newName);
                                        if (updated) {
                                          Navigator.of(context).pop();
                                          showCustomSnackbar(context, 'Room name updated!', success: true);
                                        } else {
                                          showCustomSnackbar(context, 'Failed to update room name.', success: false);
                                        }
                                      } else {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('Save', style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Chat Room'),
                              content: const Text('Are you sure you want to delete this chat room? This action cannot be undone.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Add backend delete logic here
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
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
