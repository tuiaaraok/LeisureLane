import 'package:flutter_screenutil/flutter_screenutil.dart';

export 'calendar_bloc.dart';

int getNumberOfWeeksInMonth(int year, int month) {
  // Получаем первый день месяца
  DateTime firstDayOfMonth = DateTime(year, month, 1);

  // Получаем последний день месяца
  DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

  // Вычисляем количество дней в месяце
  int numberOfDaysInMonth = lastDayOfMonth.day;

  // Вычисляем день недели для первого дня месяца (1 - понедельник, 7 - воскресенье)
  int firstWeekdayOfMonth = firstDayOfMonth.weekday;

  // Вычисляем количество недель
  int numberOfWeeks =
      ((numberOfDaysInMonth + firstWeekdayOfMonth - 1) / 7).ceil();

  return numberOfWeeks;
}

double calculateCalendarHeight(DateTime currentMonth) {
  int numberOfWeeks =
      getNumberOfWeeksInMonth(currentMonth.year, currentMonth.month) + 1;
  return (305.65.h / 6 * numberOfWeeks) + 34.86.h;
}
