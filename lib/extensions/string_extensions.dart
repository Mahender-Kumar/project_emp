import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {
  // Titlecase Extension
  String toTitleCase() {
    // if (length <= 3) return toUpperCase();
    return trim()
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : word,
        )
        .join(' ');
  }

  // CamelCase Extension
  String toCamelCase() {
    if (isEmpty) return this; // return empty string if input is empty

    // Split the input string by whitespace and capitalize the first letter of each word after the first
    List<String> words = trim().split(' ');
    String firstWord =
        words.first.toLowerCase(); // convert first word to lowercase
    String camelCaseString =
        firstWord +
        words
            .sublist(1)
            .map((word) {
              return word.isEmpty
                  ? ''
                  : word[0].toUpperCase() + word.substring(1).toLowerCase();
            })
            .join('');

    return camelCaseString;
  }

  String convertTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }
}
