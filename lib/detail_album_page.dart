import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weekend_planner/date/albums_model.dart';
import 'package:weekend_planner/date/hive_boxes.dart';

import 'package:weekend_planner/them_provider.dart';

// ignore: must_be_immutable
class DetailAlbumPage extends StatefulWidget {
  DetailAlbumPage({super.key, required this.index});
  int index;
  @override
  State<DetailAlbumPage> createState() => _DetailAlbumPageState();
}

class _DetailAlbumPageState extends State<DetailAlbumPage> {
  String albumController = "";
  List<Uint8List> images = [];
  Future getLostData() async {
    XFile? picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picker == null) return;
    List<int> imageBytes = await picker.readAsBytes();
    return Uint8List.fromList(imageBytes);
  }

  @override
  void initState() {
    super.initState();
    albumController = albumsModel.getAt(widget.index)?.albumsName ?? "";
    images.addAll(albumsModel.getAt(widget.index)?.image ?? []);
  }

  Box<AlbumsModel> albumsModel = Hive.box<AlbumsModel>(HiveBoxes.albumsModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: 337.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
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
                        Text(
                          albumController,
                          style: GoogleFonts.montserrat(
                              color: context.watch<ThemeProvider>().greenColor,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          width: 39.w,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  ...images.map(
                    (e) {
                      return Container(
                        width: 316.45.w,
                        height: 161.h,
                        margin: EdgeInsets.only(bottom: 20.h),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(e), fit: BoxFit.fill),
                            color:
                                context.watch<ThemeProvider>().containerColor,
                            borderRadius: BorderRadius.circular(18.r),
                            border: Border.all(
                                color:
                                    context.watch<ThemeProvider>().borderColor,
                                width: 2.w)),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      getLostData().then((onValue) {
                        images.add(onValue);
                        albumsModel.putAt(
                            widget.index,
                            AlbumsModel(
                                albumsName: albumController, image: images));
                      }).whenComplete(() {
                        setState(() {});
                      });
                    },
                    child: Container(
                      width: 39.w,
                      height: 39.h,
                      decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().containerColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: context.watch<ThemeProvider>().borderColor,
                              width: 2.w),
                          boxShadow: const [
                            BoxShadow(offset: Offset(1, 1), color: Colors.black)
                          ]),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: 28.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
