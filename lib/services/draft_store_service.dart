import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DraftStoreService {
  static const String _draftKey = 'store_draft';

  static Future<void> saveDraft(Map<String, dynamic> draft) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_draftKey, jsonEncode(draft));
  }

  static Future<Map<String, dynamic>?> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_draftKey);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  static Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_draftKey);
  }
}
