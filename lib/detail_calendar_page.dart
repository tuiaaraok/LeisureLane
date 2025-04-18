import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:weekend_planner/date/hive_boxes.dart';
import 'package:weekend_planner/date/plan_model.dart';
import 'package:weekend_planner/them_provider.dart';

// ignore: must_be_immutable
class DetailCalendarPage extends StatefulWidget {
  DetailCalendarPage({super.key, required this.index});
  int index;
  @override
  State<DetailCalendarPage> createState() => _DetailCalendarPageState();
}

class _DetailCalendarPageState extends State<DetailCalendarPage> {
  Box<PlanModel> planModel = Hive.box<PlanModel>(HiveBoxes.planModel);
  Uint8List? _image;
  Future getLostData() async {
    XFile? picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picker == null) return;
    List<int> imageBytes = await picker.readAsBytes();
    _image = Uint8List.fromList(imageBytes);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _image = planModel.getAt(widget.index)?.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 337.w,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 39.w,
                          height: 39.h,
                          decoration: BoxDecoration(
                              color:
                                  context.watch<ThemeProvider>().containerColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: context
                                      .watch<ThemeProvider>()
                                      .borderColor,
                                  width: 2.w),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(1, 1), color: Colors.black)
                              ]),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 28.w,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: 280.w,
                          child: Text(
                            planModel.getAt(widget.index)?.planeName ?? "",
                            style: GoogleFonts.montserrat(
                                color:
                                    context.watch<ThemeProvider>().greenColor,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  width: 330.w,
                  child: Column(children: [
                    Row(
                      children: [
                        DateStartEndWidget(
                          date: DateFormat("dd/MM")
                              .format(planModel.getAt(widget.index)!.startDate),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        DateStartEndWidget(
                          date: DateFormat("dd/MM")
                              .format(planModel.getAt(widget.index)!.endDate),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: 316.w,
                      child: RichText(
                          text: TextSpan(
                              text: "Description: ",
                              style: GoogleFonts.montserrat(
                                  color: context
                                      .watch<ThemeProvider>()
                                      .borderColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600),
                              children: [
                            TextSpan(
                                text: planModel
                                        .getAt(widget.index)
                                        ?.description ??
                                    "",
                                style: GoogleFonts.montserrat(
                                  color: context
                                      .watch<ThemeProvider>()
                                      .borderColor,
                                  fontSize: 16.sp,
                                ))
                          ])),
                    ),
                    SizedBox(
                      height: 34.h,
                    ),
                    SizedBox(
                      width: 316.w,
                      child: Text(
                        "Stages",
                        style: GoogleFonts.montserrat(
                            color: context.watch<ThemeProvider>().greenColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    ...planModel
                        .getAt(widget.index)!
                        .stagesList
                        .map((toElement) {
                      return Container(
                        width: 316.w,
                        height: 52.h,
                        margin: EdgeInsets.only(bottom: 7.h),
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().containerColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.45.r)),
                          border: Border.all(
                              color: context.watch<ThemeProvider>().borderColor,
                              width: 1.w),
                        ),
                        child: Row(
                          children: [
                            Text(toElement.startTime,
                                style: GoogleFonts.montserrat(
                                    color: context
                                        .watch<ThemeProvider>()
                                        .pinkColor,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w800)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.w),
                              child: VerticalDivider(
                                  color: context
                                      .watch<ThemeProvider>()
                                      .borderColor,
                                  endIndent: 10.h,
                                  indent: 10.h,
                                  width: 1.w,
                                  thickness: 1.w),
                            ),
                            Text(toElement.stagesName,
                                style: GoogleFonts.montserrat(
                                  color: context
                                      .watch<ThemeProvider>()
                                      .borderColor,
                                  fontSize: 14.45.sp,
                                )),
                          ],
                        ),
                      );
                    }),
                    SizedBox(
                      height: 43.h,
                    ),
                    SizedBox(
                      width: 316.w,
                      height: 148.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Photo",
                            style: GoogleFonts.montserrat(
                                color:
                                    context.watch<ThemeProvider>().greenColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800),
                          ),
                          GestureDetector(
                            onTap: () {
                              getLostData().whenComplete(() {
                                PlanModel plan = planModel.getAt(widget.index)!;
                                plan.image = _image;
                                planModel.putAt(widget.index, plan);
                              });
                            },
                            child: Container(
                                width: 316.w,
                                height: 119.h,
                                decoration: BoxDecoration(
                                    image: _image != null
                                        ? DecorationImage(
                                            image: MemoryImage(_image!),
                                            fit: BoxFit.fill)
                                        : null,
                                    color: context
                                        .watch<ThemeProvider>()
                                        .containerColor,
                                    border: Border.all(
                                        color: context
                                            .watch<ThemeProvider>()
                                            .borderColor,
                                        width: 1.w),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(16.r))),
                                child: _image == null
                                    ? Center(
                                        child: Text("+Add photo",
                                            style: GoogleFonts.montserrat(
                                                color: context
                                                        .watch<ThemeProvider>()
                                                        .isDarkMode
                                                    ? const Color(0xFF2F4441)
                                                    : Colors.black,
                                                fontSize: 18.56.sp,
                                                fontWeight: FontWeight.w700)),
                                      )
                                    : const SizedBox.shrink()),
                          )
                        ],
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateStartEndWidget extends StatelessWidget {
  const DateStartEndWidget({super.key, required this.date});
  final String date;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          context.watch<ThemeProvider>().isDarkMode
              ? "assets/icons/second_calendar_dark.svg"
              : "assets/icons/second_calendar.svg",
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Start",
                style: GoogleFonts.montserrat(
                    fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              Text(
                date,
                style: GoogleFonts.montserrat(
                    color: context.watch<ThemeProvider>().greenColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        )
      ],
    );
  }
}
