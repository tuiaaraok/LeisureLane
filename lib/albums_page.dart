import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weekend_planner/date/albums_model.dart';
import 'package:weekend_planner/date/hive_boxes.dart';
import 'package:weekend_planner/detail_album_page.dart';
import 'package:weekend_planner/my_text_field.dart';
import 'package:weekend_planner/them_provider.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({super.key});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<AlbumsModel>(HiveBoxes.albumsModel).listenable(),
      builder: (context, Box<AlbumsModel> box, _) {
        // Фильтрация альбомов по поисковому запросу
        final filteredAlbums = box.values.where((album) {
          return album.albumsName.toLowerCase().contains(_searchText);
        }).toList();

        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  MyTextField.searchTextField(
                    context,
                    349.w,
                    _searchController,
                    SvgPicture.asset(
                      "assets/icons/search.svg",
                      // ignore: deprecated_member_use
                      color: context.watch<ThemeProvider>().borderColor,
                    ),
                    hint: "Search for albums",
                    onChange: (value) {
                      setState(() {
                        _searchText = value.toLowerCase();
                      });
                    },
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
                            "List of media files",
                            style: GoogleFonts.montserrat(
                              color: context.watch<ThemeProvider>().greenColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (filteredAlbums.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Center(
                              child: Text(
                                "No albums found",
                                style: GoogleFonts.montserrat(
                                  color: context
                                      .watch<ThemeProvider>()
                                      .borderColor,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                        for (int i = filteredAlbums.length - 1;
                            i >= 0;
                            i--) ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      DetailAlbumPage(
                                    index: i,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 349.w,
                              height: 52.h,
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              decoration: BoxDecoration(
                                color: context
                                    .watch<ThemeProvider>()
                                    .containerColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14.45.r)),
                                border: Border.all(
                                  color: context
                                      .watch<ThemeProvider>()
                                      .borderColor,
                                  width: 1.w,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      filteredAlbums[i].albumsName,
                                      style: TextStyle(
                                        color: context
                                            .watch<ThemeProvider>()
                                            .pinkColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: context
                                        .watch<ThemeProvider>()
                                        .greenColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  10.h), // Добавляем отступ между элементами
                        ],
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
  }
}
