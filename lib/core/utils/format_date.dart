import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  return DateFormat("d MMM yyyy").format(dateTime);
}
