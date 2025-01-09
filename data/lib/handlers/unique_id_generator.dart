import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final uniqueIdGeneratorProvider = Provider<UniqueIdGenerator>((ref) {
  return UniqueIdGenerator();
});

class UniqueIdGenerator {
  /// Generate a cryptographically secure unique integer ID
  /// Response: 15697651741157933000
  int num() {
    return int.parse(
      List.generate(
        4,
        (index) => math.Random.secure().nextInt(1 << 16).toRadixString(16),
      ).join(),
      radix: 16,
    );
  }

  ///Generate Cryptographically secure unique ID in UUIDv4 format
  ///https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_(random)
  String v4() {
    final random = math.Random.secure();
    // Generate 16 random bytes
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));

    // Set version to 4 (random UUID)
    bytes[6] = (bytes[6] & 0x0F) | 0x40;

    // Set variant to 10xx (RFC 4122)
    bytes[8] = (bytes[8] & 0x3F) | 0x80;

    // Convert bytes to UUID string
    return _bytesToUuidString(bytes);
  }

  /// Helper method to convert byte list to UUID string
  String _bytesToUuidString(List<int> bytes) {
    final buffer = StringBuffer();
    for (int i = 0; i < bytes.length; i++) {
      buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
      if (i == 3 || i == 5 || i == 7 || i == 9) buffer.write('-');
    }
    return buffer.toString();
  }
}
