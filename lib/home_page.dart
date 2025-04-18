import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:weekend_planner/calendar/calendar_bloc.dart';
import 'package:weekend_planner/calendar_page.dart';
import 'package:weekend_planner/date/hive_boxes.dart';
import 'package:weekend_planner/date/plan_model.dart';
import 'package:weekend_planner/detail_calendar_page.dart';
import 'package:weekend_planner/them_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
          alignment: Alignment.topCenter,
          child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<PlanModel>(HiveBoxes.planModel).listenable(),
              builder: (context, Box<PlanModel> box, _) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 34.65.h,
                      ),
                      Image.asset(
                        "assets/menu.png",
                        width: 380.w,
                        height: 380.h,
                      ),
                      SizedBox(
                        width: 342.w,
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Upcoming plans",
                              style: TextStyle(
                                  color:
                                      context.watch<ThemeProvider>().greenColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22.sp),
                            )),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => CalendarBloc(),
                                      child: const CalendarPage(),
                                    ),
                                  ),
                                );
                              },
                              child: SvgPicture.asset(
                                context.watch<ThemeProvider>().isDarkMode
                                    ? "assets/icons/second_calendar_dark.svg"
                                    : "assets/icons/second_calendar.svg",
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 9.52.h,
                      ),
                      for (int i = box.values.length - 1; i >= 0; i--)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    DetailCalendarPage(
                                  index: i,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 364.w,
                            height: 68.68.h,
                            margin: EdgeInsets.only(bottom: 19.h),
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              color:
                                  context.watch<ThemeProvider>().containerColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14.45.r)),
                              border: Border.all(
                                  color: context
                                      .watch<ThemeProvider>()
                                      .borderColor,
                                  width: 1.w),
                            ),
                            child: Row(
                              children: [
                                Text(
                                    DateFormat("dd/MM")
                                        .format(box.getAt(i)!.startDate),
                                    style: GoogleFonts.montserrat(
                                        color: context
                                            .watch<ThemeProvider>()
                                            .pinkColor,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w800)),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 7.w),
                                  child: VerticalDivider(
                                      color: Colors.black,
                                      endIndent: 10.h,
                                      indent: 10.h,
                                      width: 1.w,
                                      thickness: 1.w),
                                ),
                                Expanded(
                                  child: Text(box.getAt(i)!.planeName,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14.45.sp,
                                      )),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color:
                                      context.watch<ThemeProvider>().greenColor,
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              })),
    );
  }
}
