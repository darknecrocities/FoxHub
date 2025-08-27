import 'package:intl/intl.dart';

String formatDate(String? isoDate) {
  if (isoDate == null) return '';
  final date = DateTime.parse(isoDate);
  return DateFormat('MMM d, yyyy • hh:mm a').format(date);
}
