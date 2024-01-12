import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  final DateFormat formatter = DateFormat('MM-dd-yyyy HH:mm');
  return formatter.format(dateTime);
}
