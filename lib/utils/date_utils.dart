import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  static String formatDateCustom(DateTime date, String formatPattern) {
  final DateFormat formatter = DateFormat(formatPattern);
  return formatter.format(date);
}
}
