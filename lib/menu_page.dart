import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weekend_planner/albums_page.dart';
import 'package:weekend_planner/creat_media_file_page.dart';
import 'package:weekend_planner/create_plan_page.dart';
import 'package:weekend_planner/date/hive_boxes.dart';
import 'package:weekend_planner/date/ideas_model.dart';
import 'package:weekend_planner/home_page.dart';
import 'package:weekend_planner/idies_page.dart';
import 'package:weekend_planner/setting_page.dart';
import 'package:weekend_planner/them_provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String currentMenuItem = "assets/icons/home.svg";
  List<String> menuItems = [
    "assets/icons/home.svg",
    "assets/icons/ideas.svg",
    "assets/icons/add.svg",
    "assets/icons/albums.svg",
    "assets/icons/setting.svg"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 19.h),
        width: double.infinity,
        alignment: Alignment.topCenter,
        height: 99.h,
        decoration: BoxDecoration(
            color: context.watch<ThemeProvider>().isDarkMode
                ? const Color(0xFF009E83)
                : const Color(0xFF00846F),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r)),
            border: Border(
                top: BorderSide(
                    color: context.watch<ThemeProvider>().borderColor,
                    width: 4.w))),
        child: SizedBox(
            width: 345.w,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: menuItems.map((toElement) {
                  return BtnNavBarElementWidget(
                    svgPath: toElement,
                    isCurrentMenuItem: currentMenuItem == toElement,
                    onTap: () {
                      setState(() {
                        if (toElement != "assets/icons/add.svg") {
                          currentMenuItem = toElement;
                        } else {
                          if (currentMenuItem == "assets/icons/home.svg") {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const CreatePlanPage();
                              },
                            ));
                          } else if (currentMenuItem ==
                              "assets/icons/ideas.svg") {
                            Hive.box<IdeasModel>(HiveBoxes.ideasModel)
                                .add(IdeasModel(nameIdeas: ""));
                          } else if (currentMenuItem ==
                              "assets/icons/albums.svg") {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const CreatMediaFilePage();
                              },
                            ));
                          }
                        }
                      });
                    },
                  );
                }).toList())),
      ),
      body: currentBody(currentMenuItem),
    );
  }

  Widget currentBody(String svgPath) {
    switch (svgPath) {
      case "assets/icons/home.svg":
        return const HomePage();
      case "assets/icons/ideas.svg":
        return const IdiesPage();
      case "assets/icons/albums.svg":
        return const AlbumsPage();
      case "assets/icons/setting.svg":
        return const SettingPage();
      case "assets/icons/add.svg":
        return const SizedBox.shrink();
      default:
        return const HomePage();
    }
  }
}

// ignore: must_be_immutable
class BtnNavBarElementWidget extends StatelessWidget {
  BtnNavBarElementWidget(
      {super.key,
      required this.svgPath,
      required this.isCurrentMenuItem,
      required this.onTap});
  final String svgPath;
  bool isCurrentMenuItem;
  Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 45.w,
          height: 45.h,
          decoration: BoxDecoration(
              color: context.watch<ThemeProvider>().containerColor,
              shape: BoxShape.circle,
              border: Border.all(
                  color: isCurrentMenuItem
                      ? context.watch<ThemeProvider>().pinkColor
                      : context.watch<ThemeProvider>().iconColor,
                  width: 2.w)),
          child: Center(
              child: SvgPicture.asset(svgPath,
                  // ignore: deprecated_member_use
                  color: isCurrentMenuItem
                      ? context.watch<ThemeProvider>().pinkColor
                      : context.watch<ThemeProvider>().iconColor))),
    );
  }
}
