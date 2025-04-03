List<String> generateTags(String input) {
  if (input.isEmpty) return [];

  return input
      .toLowerCase()
      .split(RegExp(r'\s+')) // Split by spaces
      .where((word) => word.isNotEmpty) // Remove empty words
      .expand((word) => _generateSubstrings(word)) // Generate substrings
      .toSet() // Remove duplicates
      .toList();
}

// Generate progressive substrings for a word
List<String> _generateSubstrings(String word) {
  List<String> substrings = [];
  for (int i = 1; i <= word.length; i++) {
    substrings.add(word.substring(0, i)); // Generate progressive substrings
  }
  return substrings;
}
