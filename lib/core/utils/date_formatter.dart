import 'package:intl/intl.dart';

final DateFormat _shortDateFormat = DateFormat('dd/MM/yyyy');

String formatShortDate(DateTime date) {
  return _shortDateFormat.format(date);
}

String formatRelativeDate(DateTime date, {DateTime? now}) {
  final DateTime current = now ?? DateTime.now();
  final DateTime currentDay = DateTime(
    current.year,
    current.month,
    current.day,
  );
  final DateTime targetDay = DateTime(date.year, date.month, date.day);
  final int differenceInDays = currentDay.difference(targetDay).inDays;

  if (differenceInDays == 0) {
    return 'Hôm nay';
  }

  if (differenceInDays == 1) {
    return 'Hôm qua';
  }

  return formatShortDate(date);
}
