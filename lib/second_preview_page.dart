import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weekend_planner/menu_page.dart';
import 'package:weekend_planner/them_provider.dart';

import 'calendar/calendar.dart';

class SecondPreviewPage extends StatefulWidget {
  const SecondPreviewPage({super.key});

  @override
  State<SecondPreviewPage> createState() => _SecondPreviewPageState();
}

class _SecondPreviewPageState extends State<SecondPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            SizedBox(
              height: 34.65.h,
            ),
            Image.asset(
              "assets/second_preview.png",
              width: 380.w,
              height: 380.h,
            ),
            SizedBox(
              height: 57.h,
            ),
            SizedBox(
              width: 329.w,
              child: Text(
                "The app helps you structure ideas, create step-by-step plans, upload photos and videos, and analyze your weekend.",
                style: GoogleFonts.montserrat(
                    fontSize: 19.sp, fontWeight: FontWeight.w500),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => CalendarBloc(),
                              )
                            ],
                            child: const MenuPage(),
                          )),
                );
              },
              child: Container(
                width: 332.w,
                height: 52.h,
                decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().greenColor,
                    borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    boxShadow: const [
                      BoxShadow(offset: Offset(3, 4), color: Colors.black)
                    ]),
                child: Center(
                  child: Text(
                    "Let’s start!",
                    style: GoogleFonts.montserrat(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: context.watch<ThemeProvider>().containerColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
