import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:weekend_planner/calendar/calendar.dart';
import 'package:weekend_planner/date/hive_boxes.dart';
import 'package:weekend_planner/date/plan_model.dart';
import 'package:weekend_planner/them_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: Hive.box<PlanModel>(HiveBoxes.planModel).listenable(),
        builder: (context, Box<PlanModel> box, _) {
          return BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              // Получаем планы для выбранной даты
              final plansForSelectedDate = state.selectedDate != null
                  ? box.values.where((plan) =>
                      (state.selectedDate!.isAfter(plan.startDate) ||
                          state.selectedDate!
                              .isAtSameMomentAs(plan.startDate)) &&
                      (state.selectedDate!.isBefore(plan.endDate) ||
                          state.selectedDate!.isAtSameMomentAs(plan.endDate)))
                  : <PlanModel>[];

              return Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        // Заголовок и навигация (остается без изменений)
                        SizedBox(
                          width: 337.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 39.w,
                                  height: 39.h,
                                  decoration: BoxDecoration(
                                    color: context
                                        .watch<ThemeProvider>()
                                        .containerColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: context
                                          .watch<ThemeProvider>()
                                          .borderColor,
                                      width: 2.w,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(1, 1),
                                          color: Colors.black)
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 28.w,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "Calendar",
                                style: GoogleFonts.montserrat(
                                  color:
                                      context.watch<ThemeProvider>().greenColor,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 39.w),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Календарь
                        Container(
                          width: 330.83.w,
                          height: calculateCalendarHeight(state.currentMonth),
                          decoration: BoxDecoration(
                            color:
                                context.watch<ThemeProvider>().containerColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.r)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20.h),
                              SizedBox(
                                width: 266.w,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => context
                                          .read<CalendarBloc>()
                                          .add(CalendarArrowBackEvent()),
                                      child: Icon(Icons.arrow_back_ios,
                                          size: 12.w),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.w),
                                      child: Text(
                                        DateFormat("MMMM y")
                                            .format(state.currentMonth),
                                        style: GoogleFonts.montserrat(
                                          color: context
                                              .watch<ThemeProvider>()
                                              .borderColor,
                                          fontSize: 16.43.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => context
                                          .read<CalendarBloc>()
                                          .add(CalendarArrowForwardEvent()),
                                      child: Icon(Icons.arrow_forward_ios,
                                          size: 12.w),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  child: CalendarWidget(
                                    plans: box.values.toList(),
                                    month: state.currentMonth,
                                    selectedDate: state.selectedDate,
                                    onDateSelected: (date) {
                                      context.read<CalendarBloc>().add(
                                            CalendarTabDateEvent(
                                                selectedDate: date),
                                          );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),

                        // Список планов на выбранную дату
                        if (state.selectedDate != null &&
                            plansForSelectedDate.isNotEmpty)
                          ...plansForSelectedDate
                              .map((plan) => _buildPlanItem(context, plan)),

                        // Если нет планов на выбранную дату
                        if (state.selectedDate != null &&
                            plansForSelectedDate.isEmpty)
                          SizedBox(
                            width: 364.w,
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(
                                    "No plans for ${DateFormat('dd/MM').format(state.selectedDate!)}",
                                    style: GoogleFonts.montserrat(
                                      color: context
                                          .watch<ThemeProvider>()
                                          .pinkColor,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPlanItem(BuildContext context, PlanModel plan) {
    return Container(
      width: 364.w,
      height: 68.68.h,
      margin: EdgeInsets.only(bottom: 7.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: context.watch<ThemeProvider>().containerColor,
        borderRadius: BorderRadius.all(Radius.circular(14.45.r)),
        border: Border.all(
          color: context.watch<ThemeProvider>().borderColor,
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          Text(
            DateFormat('dd/MM').format(plan.startDate),
            style: GoogleFonts.montserrat(
              color: context.watch<ThemeProvider>().pinkColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: VerticalDivider(
              color: context.watch<ThemeProvider>().borderColor,
              endIndent: 10.h,
              indent: 10.h,
              width: 1.w,
              thickness: 1.w,
            ),
          ),
          Expanded(
            child: Text(
              plan.planeName,
              style: GoogleFonts.montserrat(
                fontSize: 14.45.sp,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: context.watch<ThemeProvider>().greenColor,
          ),
        ],
      ),
    );
  }
}

// CalendarWidget остается без изменений
class CalendarWidget extends StatelessWidget {
  final DateTime month;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final List<PlanModel> plans; // Добавляем список планов

  const CalendarWidget({
    required this.month,
    required this.selectedDate,
    required this.onDateSelected,
    required this.plans, // Получаем список планов
    super.key,
  });

  // Проверяет, находится ли дата в диапазоне какого-либо плана
  bool _isDateInPlanRange(DateTime date) {
    for (var plan in plans) {
      if ((date.isAfter(plan.startDate) ||
              date.isAtSameMomentAs(plan.startDate)) &&
          (date.isBefore(plan.endDate) ||
              date.isAtSameMomentAs(plan.endDate))) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;

    List<Widget> calendarCells = [];

    // Добавляем названия дней недели
    List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (String day in weekDays) {
      calendarCells.add(
        Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            day,
            style: GoogleFonts.montserrat(
              color: context.watch<ThemeProvider>().borderColor,
              fontWeight: FontWeight.w700,
              fontSize: 12.39.sp,
            ),
          ),
        ),
      );
    }

    // Добавляем дни предыдущего месяца
    int daysInPreviousMonth = DateTime(month.year, month.month, 0).day;
    int daysToShowFromPreviousMonth = (weekdayOfFirstDay - 1) % 7;

    for (int i = daysInPreviousMonth - daysToShowFromPreviousMonth + 1;
        i <= daysInPreviousMonth;
        i++) {
      calendarCells.add(
        Center(
          child: Container(
            height: 38.61.h,
            width: 38.61.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7.29.r)),
              border: Border.all(
                  color: context.watch<ThemeProvider>().backgroundColor,
                  width: 1.w),
              color: const Color(0xFF8D8C99),
            ),
            child: Center(
              child: Text(
                DateTime(month.year, month.month - 1, i).day.toString(),
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 17.12.sp,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Добавляем дни текущего месяца
    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date = DateTime(month.year, month.month, i);
      bool isInRange =
          _isDateInPlanRange(date); // Проверяем, входит ли дата в диапазон

      calendarCells.add(
        GestureDetector(
          onTap: () => onDateSelected(date),
          child: Center(
            child: Container(
              height: 38.61.h,
              width: 38.61.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7.29.r)),
                border: Border.all(
                    color: context.watch<ThemeProvider>().backgroundColor,
                    width: 1.w),
                color: isInRange
                    ? context
                        .watch<ThemeProvider>()
                        .pinkColor // Розовый для дат в диапазоне
                    : context
                        .watch<ThemeProvider>()
                        .greenColor, // Зеленый для остальных
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.12.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Добавляем пустые ячейки для выравнивания
    int size = calendarCells.length;
    for (int i = 1;
        size % 7 != 0 ? i <= (7 * ((size / 7).toInt() + 1)) - size : false;
        i++) {
      calendarCells.add(
        Center(
          child: Container(
            height: 38.61.h,
            width: 38.61.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7.29.r)),
              border: Border.all(
                  color: context.watch<ThemeProvider>().backgroundColor,
                  width: 1.w),
              color: const Color(0xFF8D8C99),
            ),
            child: Center(
              child: Text(
                DateTime(month.year, month.month, i).day.toString(),
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 17.12.sp,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 7,
      childAspectRatio: 1,
      children: calendarCells,
    );
  }
}
