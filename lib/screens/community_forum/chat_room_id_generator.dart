import 'dart:math';

/// Generates a random Room ID like: 463810fhtsf57412345
String generateChatRoomId() {
	const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
	final rand = Random.secure();
	String randomString(int length) => List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
	// Example: 6 digits + 5 letters + 5 digits
	final part1 = List.generate(6, (_) => rand.nextInt(10)).join();
	final part2 = randomString(5);
	final part3 = List.generate(8, (_) => rand.nextInt(10)).join();
	return '$part1$part2$part3';
}
