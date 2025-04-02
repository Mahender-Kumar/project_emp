List<String> generateTags(String input) {
  if (input.isEmpty) return [];

  return input
      .toLowerCase()
      .split(RegExp(r'\s+')) // Split by spaces
      .where((word) => word.isNotEmpty) // Remove empty words
      .map(
        (word) => word.replaceAll(RegExp(r'[^\w]'), ''),
      ) // Remove special characters and add #
      .toList();
}
