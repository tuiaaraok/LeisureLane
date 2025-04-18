import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weekend_planner/date/hive_boxes.dart';
import 'package:weekend_planner/date/ideas_model.dart';
import 'package:weekend_planner/my_text_field.dart';
import 'package:weekend_planner/them_provider.dart';

class IdiesPage extends StatefulWidget {
  const IdiesPage({super.key});

  @override
  State<IdiesPage> createState() => _IdiesPageState();
}

class _IdiesPageState extends State<IdiesPage> {
  List<TextEditingController> idieasControllerList = [];
  TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    for (var controller in idieasControllerList) {
      controller.dispose();
    }
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      child: Align(
        alignment: Alignment.topCenter,
        child: ValueListenableBuilder(
          valueListenable:
              Hive.box<IdeasModel>(HiveBoxes.ideasModel).listenable(),
          builder: (context, Box<IdeasModel> box, _) {
            // Фильтрация элементов по поисковому запросу
            final filteredItems = box.values.where((item) {
              return item.nameIdeas.toLowerCase().contains(searchText);
            }).toList();

            // Обновление контроллеров
            if (idieasControllerList.length != filteredItems.length) {
              for (var controller in idieasControllerList) {
                controller.dispose();
              }
              idieasControllerList = filteredItems
                  .map((item) => TextEditingController(text: item.nameIdeas))
                  .toList();
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  MyTextField.searchTextField(
                    context,
                    349.w,
                    searchController,
                    SvgPicture.asset(
                      "assets/icons/search.svg",
                      // ignore: deprecated_member_use
                      color: context.watch<ThemeProvider>().borderColor,
                    ),
                    hint: "Search for ideas",
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: 349.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.w, bottom: 7.h),
                          child: Text(
                            "List of ideas",
                            style: GoogleFonts.montserrat(
                              color: context.watch<ThemeProvider>().greenColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        for (int i = 0; i < filteredItems.length; i++) ...[
                          Container(
                            width: 349.w,
                            height: 52.h,
                            margin: EdgeInsets.only(bottom: 15.h),
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            decoration: BoxDecoration(
                              color:
                                  context.watch<ThemeProvider>().containerColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14.45.r)),
                              border: Border.all(
                                color:
                                    context.watch<ThemeProvider>().borderColor,
                                width: 1.w,
                              ),
                            ),
                            child: Center(
                              child: TextField(
                                controller: idieasControllerList[i],
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: "",
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                cursorWidth: 3.w,
                                cursorColor:
                                    context.watch<ThemeProvider>().pinkColor,
                                style: TextStyle(
                                  color:
                                      context.watch<ThemeProvider>().pinkColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20.sp,
                                ),
                                onSubmitted: (value) {
                                  // Находим оригинальный индекс элемента в box
                                  final originalIndex = box.values
                                      .toList()
                                      .indexOf(filteredItems[i]);
                                  if (originalIndex != -1) {
                                    box.putAt(originalIndex,
                                        IdeasModel(nameIdeas: value));
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
