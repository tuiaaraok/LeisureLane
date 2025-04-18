part of 'calendar_bloc.dart';

abstract class CalendarEvent {}

class CalendarArrowForwardEvent extends CalendarEvent {}

class CalendarArrowBackEvent extends CalendarEvent {}

class CalendarTabDateEvent extends CalendarEvent {
  final DateTime selectedDate;

  CalendarTabDateEvent({required this.selectedDate});
}
