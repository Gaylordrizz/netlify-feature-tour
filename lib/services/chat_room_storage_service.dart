import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for persistent chat room message storage (up to 100,000 per room).
class ChatRoomStorageService {
  static const int maxMessages = 100000;

  /// Save messages for a specific chat room.
  static Future<void> saveRoomMessages(String roomId, List<Map<String, String>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    // Enforce message limit
    final trimmed = messages.length > maxMessages
        ? messages.sublist(messages.length - maxMessages)
        : messages;
    prefs.setString('chat_room_' + roomId, jsonEncode(trimmed));
  }

  /// Load messages for a specific chat room.
  static Future<List<Map<String, String>>> loadRoomMessages(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('chat_room_' + roomId);
    if (jsonString == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.cast<Map<String, dynamic>>().map((e) => e.map((k, v) => MapEntry(k.toString(), v.toString()))).toList();
  }

  /// Delete all messages for a specific chat room.
  static Future<void> clearRoomMessages(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('chat_room_' + roomId);
  }
}
