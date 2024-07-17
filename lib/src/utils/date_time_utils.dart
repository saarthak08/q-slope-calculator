import 'package:intl/intl.dart';

DateFormat dateTimeFormat = DateFormat("dd MMM, yyyy h:mm a");
DateFormat timeFormat = DateFormat("h:mm a");
DateFormat dateFormat = DateFormat("dd MMM, yyyy");

int getCurrentTimeDifferenceInMilliseconds(String time) {
  DateTime dateTime = DateTime.parse(time).toLocal();
  int x = dateTime.millisecondsSinceEpoch;
  int k = DateTime.now().toLocal().millisecondsSinceEpoch;
  return (k - x);
}

int getTimeSinceEpochInMicroseconds(String time) {
  return DateTime.parse(time).microsecondsSinceEpoch;
}

String? formatDateTimeFromString(String dateTime, {DateFormat? format}) {
  final parsedDateTime = DateTime.tryParse(dateTime)?.toLocal();
  if (parsedDateTime == null) {
    return null;
  } else {
    return format == null
        ? dateTimeFormat.format(parsedDateTime).toString()
        : format.format(parsedDateTime);
  }
}

String? formatDateTime(DateTime dateTime, {DateFormat? format}) {
  return format == null
      ? dateTimeFormat.format(dateTime).toString()
      : format.format(dateTime);
}

String? formatTime(String dateTime) {
  final parsedDateTime = DateTime.tryParse(dateTime)?.toLocal();
  if (parsedDateTime == null) {
    return null;
  } else {
    return timeFormat.format(parsedDateTime).toString();
  }
}

String? formatDate(String dateTime) {
  final parsedDateTime = DateTime.tryParse(dateTime)?.toLocal();
  if (parsedDateTime == null) {
    return null;
  } else {
    return dateFormat.format(parsedDateTime).toString();
  }
}

bool isSameDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

int getDifferenceInDaysWithNow(DateTime date) {
  DateTime from = DateTime(date.year, date.month, date.day);
  DateTime now = DateTime.now();
  DateTime to = DateTime(now.year, now.month, now.day);
  return (to.difference(from).inHours / 24).round();
}
