extension EnumLabel on Enum {
  /// Converts enum value like `water_sealed_shared` → `Water Sealed Shared`
  String get label {
    final raw = name; // e.g., "water_sealed_shared"

    // Replace underscores with spaces
    final spaced = raw.replaceAll('_', ' ');

    // Capitalize first letter of each word
    return spaced
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : '',
        )
        .join(' ');
  }
}
