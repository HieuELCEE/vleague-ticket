import 'package:intl/intl.dart';


class DateUtil {

  static DateTime convertStringToDate(String strDate, String format) {
    return DateFormat(format).parse(strDate);
  }

  static String convertDateToString(DateTime date, String format) {
    return DateFormat(format).format(date);
  }
}