import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

dynamic convertTimestamp(dynamic timestamp) {
  if (timestamp == null || timestamp == '') return '';
  if (timestamp is String) return timestamp;
  if (timestamp is! DateTime && timestamp is! Timestamp) {
    return '';
  } else if (timestamp is DateTime) {
    // return DateFormat('dd/MM/yyyy').format(timestamp);
    return DateFormat.yMMMd('en_US').format(timestamp);
  }

  // return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
  return DateFormat.yMMMd('en_US').format(timestamp.toDate());
}

extension TimestampExtensions on Timestamp {
  String toFormattedTimestampString() {
    return DateFormat('dd MMMM, yyyy').format(toDate());
  }
}

extension DateTimeExtensions on DateTime {
  String toFormattedDatetimeString() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
