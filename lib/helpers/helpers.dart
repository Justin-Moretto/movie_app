import 'package:intl/intl.dart';

/// Formats the release date returned by the api into something more human readable.
String formatDate(String date) {
  final dateTime = DateTime.parse(date);
  return DateFormat.yMMMMd().format(dateTime);
}
