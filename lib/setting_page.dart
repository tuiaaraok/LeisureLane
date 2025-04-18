import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weekend_planner/them_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 364.w,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text(
                    "Settings",
                    style: GoogleFonts.montserrat(
                        color: context.watch<ThemeProvider>().greenColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context
                        .read<ThemeProvider>()
                        .toggleTheme(); // Используем read
                  },
                  child: Icon(
                    Icons.sunny,
                    color: context.watch<ThemeProvider>().switchColor,
                    size: 30.w,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 228.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () async {
                        String? encodeQueryParameters(
                            Map<String, String> params) {
                          return params.entries
                              .map((MapEntry<String, String> e) =>
                                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                              .join('&');
                        }

                        // ···
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'ahmetdemirhan1@icloud.com',
                          query: encodeQueryParameters(<String, String>{
                            '': '',
                          }),
                        );
                        try {
                          if (await canLaunchUrl(emailLaunchUri)) {
                            await launchUrl(emailLaunchUri);
                          } else {
                            throw Exception("Could not launch $emailLaunchUri");
                          }
                        } catch (e) {
                          log('Error launching email client: $e'); // Log the error
                        }
                      },
                      child: const MenuElemWidget(title: "Contact Us")),
                  GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(
                            'https://docs.google.com/document/d/1KT0G7s0LBWkedJUwrFtVijPzA76P4ONB6eaI4aqCE7o/mobilebasic');
                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: const MenuElemWidget(title: "Rate Us")),
                  GestureDetector(
                    onTap: () {
                      InAppReview.instance.openStoreListing(
                        appStoreId: '6744804002',
                      );
                      // 6744804002
                    },
                    child: const MenuElemWidget(title: "Privacy Policy"),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 34.h,
            ),
            Image.asset(
              "assets/menu.png",
              width: 380.w,
              height: 380.h,
            )
          ],
        ),
      ),
    ));
  }
}

class MenuElemWidget extends StatelessWidget {
  const MenuElemWidget({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 364.w,
      height: 68.68,
      padding: EdgeInsets.only(left: 17.66.w, right: 11.77.w),
      decoration: BoxDecoration(
          color: context.watch<ThemeProvider>().containerColor,
          borderRadius: BorderRadius.all(
            Radius.circular(15.r),
          ),
          border: Border.all(
              color: context.watch<ThemeProvider>().borderColor, width: 1.w)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
                fontSize: 27.47.sp,
                color: context.watch<ThemeProvider>().pinkColor,
                fontWeight: FontWeight.w800),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: context.watch<ThemeProvider>().greenColor,
          )
        ],
      ),
    );
  }
}
