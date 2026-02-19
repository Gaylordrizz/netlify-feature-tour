
import 'banned_domains_list.dart';

class DomainChecker {

  /// Returns true if the domain is banned (case-insensitive, ignores www. and spaces)
  static bool isBanned(String? input) {
    if (input == null || input.trim().isEmpty) return false;
    String domain = input.trim().toLowerCase().replaceAll('www.', '');
    domain = domain.replaceAll(RegExp(r'^https?://'), '');
    domain = domain.split('/').first;
    domain = domain.replaceAll(' ', '');
    // Check for exact match or subdomain match
    for (final banned in bannedDomains) {
      if (domain == banned || domain.endsWith('.$banned')) {
        return true;
      }
    }
    return false;
  }
}
