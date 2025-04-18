import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weekend_planner/them_provider.dart';

class MyTextField {
  static Widget textFieldForm(BuildContext context, String description,
      double widthContainer, TextEditingController myController,
      {FocusNode? myNode, TextInputType? keyboard}) {
    return Column(
      children: [
        SizedBox(
          width: widthContainer,
          child: Text(
            description,
            style: GoogleFonts.montserrat(
                fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: 46.h,
          width: widthContainer,
          decoration: BoxDecoration(
            color: context.watch<ThemeProvider>().containerColor,
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            border: Border.all(
                color: context.watch<ThemeProvider>().borderColor, width: 1.w),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Center(
              child: TextField(
                focusNode: myNode,
                controller: myController,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: '',
                  hintStyle: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400, fontSize: 18.sp),
                ),
                keyboardType: keyboard ?? TextInputType.text,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400, fontSize: 18.sp),
                onChanged: (text) {
                  // Additional functionality can be added here
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget textFieldIcon(BuildContext context, String description,
      double widthContainer, TextEditingController myController, Widget icon,
      {FocusNode? myNode,
      TextInputType? keyboard,
      void Function(String)? onChange,
      String? hint}) {
    return Column(
      children: [
        SizedBox(
          width: widthContainer,
          child: Text(
            description,
            style: GoogleFonts.montserrat(
                fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: 46.h,
          width: widthContainer,
          decoration: BoxDecoration(
            color: context.watch<ThemeProvider>().containerColor,
            borderRadius: BorderRadius.all(Radius.circular(12.r)),
            border: Border.all(
                color: context.watch<ThemeProvider>().borderColor, width: 1.w),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: myNode,
                    controller: myController,
                    decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: hint,
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18.sp)),
                    keyboardType: keyboard ?? TextInputType.text,
                    cursorColor: Colors.black,
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 18.sp),
                    onChanged: (text) {
                      // Additional functionality can be added here
                      if (onChange != null) {
                        onChange(text);
                      }
                    },
                  ),
                ),
                icon
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget searchTextField(
      BuildContext context, // Add this
      double widthContainer,
      TextEditingController myController,
      Widget icon,
      {FocusNode? myNode,
      TextInputType? keyboard,
      void Function(String)? onChange,
      String? hint}) {
    return Container(
      height: 46.h,
      width: widthContainer,
      decoration: BoxDecoration(
        color: context.watch<ThemeProvider>().containerColor,
        borderRadius: BorderRadius.all(Radius.circular(14.45.r)),
        border: Border.all(
            color: context.watch<ThemeProvider>().borderColor, width: 1.w),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            icon,
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: TextField(
                  focusNode: myNode,
                  controller: myController,
                  decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: hint,
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18.sp)),
                  keyboardType: keyboard ?? TextInputType.text,
                  style:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 18.sp),
                  onChanged: (text) {
                    // Additional functionality can be added here
                    if (onChange != null) {
                      onChange(text);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget textFieldCalendar(
      BuildContext context, // Add this
      String description,
      double widthContainer,
      TextEditingController myController,
      bool isStartDate,
      VoidCallback onToggle,
      void Function(String) onChange) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 14.h, bottom: 8.h),
          child: SizedBox(
            width: widthContainer,
            child: Text(
              description,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Container(
          height: 46.h,
          width: widthContainer,
          decoration: BoxDecoration(
            color: context.watch<ThemeProvider>().containerColor,
            borderRadius: BorderRadius.all(Radius.circular(3.r)),
            border: Border.all(
                color: context.watch<ThemeProvider>().borderColor, width: 2.w),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: TextField(
                      controller: myController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: '',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.sp)),
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.sp),
                      onChanged: (text) {
                        onChange(text);
                      },
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: onToggle,
                    child: Icon(
                      isStartDate
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      size: 20.w,
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget textFieldViewCategory(
      String description,
      double widthContainer,
      TextEditingController myController,
      bool isOpenMenuCategory,
      VoidCallback onToggle,
      List<String> categoryMenu,
      void Function(String) onTapMenuElem) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 14.h, bottom: 8.h),
          child: SizedBox(
            width: widthContainer,
            child: Text(
              description,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Container(
          height: isOpenMenuCategory
              ? categoryMenu.isEmpty
                  ? 46.h
                  : null
              : 46.h,
          width: widthContainer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3.r)),
            border: Border.all(color: const Color(0xFFDAE0E6), width: 2.w),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: isOpenMenuCategory
                ? Stack(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: categoryMenu.map((toElement) {
                            return GestureDetector(
                              onTap: () {
                                onTapMenuElem(toElement);
                              },
                              child: Text(
                                toElement,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp),
                              ),
                            );
                          }).toList()),
                      Positioned(
                        right: 0.w,
                        top: 0.h,
                        child: GestureDetector(
                            onTap: onToggle,
                            child: Icon(
                              isOpenMenuCategory
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              size: 20.w,
                            )),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: TextField(
                            controller: myController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: '',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 14.sp)),
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp),
                            onChanged: (text) {},
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: onToggle,
                          child: Icon(
                            isOpenMenuCategory
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
                            size: 20.w,
                          )),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  static Widget descriptionTextFieldForm(
      BuildContext context,
      String description,
      double widthContainer,
      TextEditingController myController,
      FocusNode focus) {
    return Column(
      children: [
        SizedBox(
          width: widthContainer,
          child: Text(
            description,
            style: GoogleFonts.montserrat(
                fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: 100.h,
          width: widthContainer,
          decoration: BoxDecoration(
            color: context.watch<ThemeProvider>().containerColor,
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
            border: Border.all(
                color: context.watch<ThemeProvider>().borderColor, width: 1.w),
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                maxLines: null,
                focusNode: focus,
                controller: myController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: '',
                    hintStyle: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 18.sp)),
                keyboardType: TextInputType.multiline,
                cursorColor: Colors.black,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500, fontSize: 18.sp),
                onChanged: (text) {},
              )),
        ),
      ],
    );
  }
}
