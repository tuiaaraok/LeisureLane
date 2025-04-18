import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:weekend_planner/date/hive_boxes.dart';
import 'package:weekend_planner/date/plan_model.dart';
import 'package:weekend_planner/my_text_field.dart';
import 'package:weekend_planner/them_provider.dart';

class CreatePlanPage extends StatefulWidget {
  const CreatePlanPage({super.key});

  @override
  State<CreatePlanPage> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends State<CreatePlanPage> {
  FocusNode focusNode = FocusNode();
  String previousText = '';
  List<TextEditingController> timeController = [TextEditingController()];
  TextEditingController planNameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TextEditingController> nameController = [TextEditingController()];
  Box<PlanModel> planModel = Hive.box<PlanModel>(HiveBoxes.planModel);

  bool isValid() {
    return timeController.every((c) => c.text.isNotEmpty) &&
        nameController.every((c) => c.text.isNotEmpty) &&
        planNameController.text.isNotEmpty &&
        startDateController.text.isNotEmpty &&
        endDateController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
          child: KeyboardActions(
            config: KeyboardActionsConfig(
              keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
              nextFocus: false,
              actions: [
                KeyboardActionsItem(
                  focusNode: focusNode,
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Create a plan",
                    style: GoogleFonts.montserrat(
                        color: context.watch<ThemeProvider>().greenColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  MyTextField.textFieldForm(
                      context, "Plan name*", 350.w, planNameController),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    width: 350.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyTextField.textFieldIcon(
                            context,
                            "Start date*",
                            166.w,
                            startDateController,
                            onChange: (p0) =>
                                _validateDate(p0, startDateController),
                            SvgPicture.asset(
                              "assets/icons/calendar.svg",
                              // ignore: deprecated_member_use
                              color: context.watch<ThemeProvider>().greenColor,
                            )),
                        MyTextField.textFieldIcon(
                            context,
                            "End date",
                            166.w,
                            endDateController,
                            onChange: (p0) =>
                                _validateDate(p0, endDateController),
                            SvgPicture.asset(
                              "assets/icons/calendar.svg",
                              // ignore: deprecated_member_use
                              color: context.watch<ThemeProvider>().greenColor,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  MyTextField.descriptionTextFieldForm(context, "Description",
                      350.w, descriptionController, focusNode),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "Stages",
                    style: GoogleFonts.montserrat(
                        color: context.watch<ThemeProvider>().greenColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  for (int i = 0; i < nameController.length; i++)
                    Column(
                      children: [
                        SizedBox(
                          width: 349.w,
                          child: Column(
                            children: [
                              MyTextField.textFieldForm(
                                  context, "Name", 350.w, nameController[i]),
                              SizedBox(
                                height: 20.h,
                              ),
                              MyWidget(
                                timeController: timeController[i],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                  SizedBox(
                      width: 350.w,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              nameController.add(TextEditingController());
                              timeController.add(TextEditingController());
                            });
                          },
                          child: Text(
                            "+Add stage",
                            style: GoogleFonts.montserrat(
                                color: context.watch<ThemeProvider>().pinkColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 81.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.paddingOf(context).bottom),
                    child: SizedBox(
                      width: 350.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 158.w,
                              height: 52.h,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFD89E9E),
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(3, 4),
                                        color: Colors.black)
                                  ]),
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.montserrat(
                                      color: context
                                          .watch<ThemeProvider>()
                                          .containerColor,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (isValid()) {
                                List<StagesModel> stagesList =
                                    List<StagesModel>.generate(
                                  nameController.length,
                                  (i) => StagesModel(
                                    stagesName: nameController[i].text,
                                    startTime: timeController[i].text,
                                  ),
                                );
                                planModel.add(PlanModel(
                                    planeName: planNameController.text,
                                    startDate: tryParseDate(
                                            startDateController.text) ??
                                        DateTime.now(),
                                    endDate:
                                        tryParseDate(endDateController.text) ??
                                            DateTime.now(),
                                    description: descriptionController.text,
                                    stagesList: stagesList,
                                    image: null));
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Please fill all required fields")),
                                );
                              }
                            },
                            child: Container(
                              width: 158.w,
                              height: 52.h,
                              decoration: BoxDecoration(
                                  color: const Color(0xFF00846F),
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(3, 4),
                                        color: Colors.black)
                                  ]),
                              child: Center(
                                child: Text(
                                  "Create",
                                  style: GoogleFonts.montserrat(
                                      color: context
                                          .watch<ThemeProvider>()
                                          .containerColor,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DateTime? tryParseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length != 3) return null;

      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (e) {
      return null;
    }
  }

  void _validateDate(String text, TextEditingController controller) {
    String sanitizedText = text.replaceAll(RegExp(r'[^0-9]'), '');
    String formattedText = '';

    for (int i = 0; i < sanitizedText.length && i < 8; i++) {
      formattedText += sanitizedText[i];
      if (i == 1 || i == 3) {
        formattedText += '/';
      }
    }

    List<String> parts = formattedText.split('/');
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      int? day = int.tryParse(parts[0]);
      if (day != null && day > 31) {
        formattedText = formattedText.substring(0, 2);
      }
    }
    if (parts.length > 1 && parts[1].isNotEmpty) {
      int? month = int.tryParse(parts[1]);
      if (month != null && month > 12) {
        formattedText = formattedText.substring(0, 2);
      }
    }

    controller.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
    previousText = controller.text;
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key, required this.timeController});
  final TextEditingController timeController;
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String? selectedReceptionTime = "AM"; // По умолчанию AM

  @override
  void initState() {
    super.initState();
    // Устанавливаем начальное значение времени
    widget.timeController.text = "AM";
    selectedReceptionTime = "AM";
  }

  @override
  void dispose() {
    widget.timeController.dispose();
    super.dispose();
  }

  // Метод для обновления времени с учетом AM/PM
  void _updateTime(String? newAmPm) {
    if (newAmPm == null) return;

    // Удаляем старый AM/PM
    String currentText = widget.timeController.text;
    if (currentText.endsWith("AM") || currentText.endsWith("PM")) {
      currentText = currentText.substring(0, currentText.length - 2).trim();
    }

    // Добавляем новый AM/PM
    widget.timeController.text = "$currentText $newAmPm";
  }

  // Метод для обработки ввода
  void _handleTextInput(String newText) {
    // Сохраняем текущую позицию курсора
    final cursorPosition = widget.timeController.selection.baseOffset;

    // Убедимся, что AM или PM остаются в конце
    if (newText.endsWith("AM") || newText.endsWith("PM")) {
      // Разделяем текст на цифры и AM/PM
      String timePart = newText.substring(0, newText.length - 2).trim();
      String amPmPart = newText.substring(newText.length - 2);

      // Ограничиваем ввод только цифрами и ":"
      timePart = timePart.replaceAll(RegExp(r'[^0-9:]'), '');

      // Обновляем текст
      widget.timeController.value = TextEditingValue(
        text: "$timePart $amPmPart",
        selection: TextSelection.collapsed(
          offset: cursorPosition > "$timePart $amPmPart".length
              ? "$timePart $amPmPart".length
              : cursorPosition,
        ),
      );
    } else {
      // Если AM/PM удалены, восстанавливаем их
      widget.timeController.value = TextEditingValue(
        text:
            "${newText.replaceAll(RegExp(r'[^0-9:]'), '')} $selectedReceptionTime",
        selection: TextSelection.collapsed(
          offset: cursorPosition >
                  "${newText.replaceAll(RegExp(r'[^0-9:]'), '')} $selectedReceptionTime"
                      .length
              ? "${newText.replaceAll(RegExp(r'[^0-9:]'), '')} $selectedReceptionTime"
                  .length
              : cursorPosition,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Start time",
            style: GoogleFonts.montserrat(
                fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
          Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
              color: context.watch<ThemeProvider>().containerColor,
              border: Border.all(
                  color: context.watch<ThemeProvider>().borderColor,
                  width: 1.w),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.timeController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9:]')), // Разрешаем только цифры и ":"
                    ],
                    onChanged: (value) {
                      _handleTextInput(value); // Обрабатываем ввод
                    },
                    onSubmitted: (value) {
                      if (value.length > 6) {
                        List<String> reng =
                            widget.timeController.text.split(":");
                        if (reng.length >= 2) {
                          int hours = int.parse(reng[0]);
                          int minut = int.parse(reng[1].substring(0, 2).trim());
                          if (hours > -1 &&
                              hours < 12 &&
                              minut > -1 &&
                              minut < 60) {
                          } else {
                            widget.timeController.text =
                                selectedReceptionTime.toString();
                          }
                        }
                      } else {
                        widget.timeController.text =
                            selectedReceptionTime.toString();
                      }
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 21.sp,
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 21.sp,
                    ),
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: false,
                    value: selectedReceptionTime,
                    items: ["AM", "PM"]
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedReceptionTime = value;
                        _updateTime(value); // Обновляем время с новым AM/PM
                      });
                    },
                    dropdownStyleData: DropdownStyleData(
                      width: 100.w,
                      maxHeight: 300.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      offset: Offset(-15.w, 0),
                    ),
                    onMenuStateChange: (_) {},
                    customButton: Icon(
                      selectedReceptionTime == null
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      size: 30.h,
                    ),
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      width: 120,
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      customHeights: List.filled(2, 50.h),
                      padding:
                          EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
