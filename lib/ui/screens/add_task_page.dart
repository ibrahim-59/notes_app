import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/controllers/task_controller.dart';
import 'package:notes_app/methods/toast.dart';
import 'package:notes_app/models/task_model.dart';
import 'package:notes_app/ui/theme.dart';
import 'package:notes_app/ui/widgets/button.dart';
import 'package:notes_app/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController taskController = Get.put(TaskController());
  final TextEditingController title = TextEditingController();
  final TextEditingController note = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String endTime = "9:30 PM";
  int selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String selectedRepeat = 'None';
  List<String> repeatList = ["None", "Daily", "Weakly", "Monthly"];
  int selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Task',
                  style: headingStyle,
                ),
                InputField(
                  title: 'Title',
                  hint: 'Add Task Title',
                  textEditingController: title,
                ),
                InputField(
                  title: 'Note',
                  hint: 'Add your Note',
                  textEditingController: note,
                ),
                InputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(selectedDate),
                  widget: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined,
                        color: Colors.grey),
                    onPressed: () {
                      getDateFromUser();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        title: 'Start Time',
                        hint: startTime,
                        widget: IconButton(
                          onPressed: () {
                            getTimeFromUser(isStartTime: true);
                          },
                          icon: const Icon(
                            Icons.access_time_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: InputField(
                        title: 'End Time',
                        hint: endTime,
                        widget: IconButton(
                          onPressed: () {
                            getTimeFromUser(isStartTime: false);
                          },
                          icon: const Icon(
                            Icons.access_time_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                InputField(
                  title: 'Remind',
                  hint: "$selectedRemind  minutes earlier",
                  widget: DropdownButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    underline: Container(width: 0),
                    iconSize: 30,
                    elevation: 40,
                    style: subTitleStyle,
                    items:
                        remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString()));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedRemind = int.parse(value!);
                      });
                    },
                  ),
                ),
                InputField(
                  title: 'Repeat',
                  hint: selectedRepeat,
                  widget: DropdownButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    underline: Container(width: 0),
                    iconSize: 30,
                    elevation: 40,
                    style: subTitleStyle,
                    items: repeatList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.grey),
                          ));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedRepeat = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    colorPicker(),
                    Button(
                        title: 'Create Task',
                        onpressed: () {
                          validateData();
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  validateData() {
    if (title.text.isNotEmpty && note.text.isNotEmpty) {
      addTaskToDB();
      Get.back();
    } else if (title.text.isEmpty || note.text.isEmpty) {
      Get.snackbar(
        'Required',
        "All Fields are required !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.warning_amber_outlined),
      );
    }
  }

  addTaskToDB() async {
    int value = await taskController.addTask(
      task: TaskModel(
        date: DateFormat.yMd().format(selectedDate),
        title: title.text,
        note: note.text,
        color: selectedColor,
        endTime: endTime,
        remind: selectedRemind,
        repeat: selectedRepeat,
        startTime: startTime,
        isCompleted: 0,
      ),
    );
    print("My id is $value");
  }

  Column colorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        Wrap(
          children: List<Widget>.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2121));
    if (pickerDate != null) {
      setState(() {
        selectedDate = pickerDate;
      });
    } else {
      AppMethods().showToast(title: 'You must Select a date');
    }
  }

  getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await showtimePicker();
    // ignore: use_build_context_synchronously
    String formattedTime = pickedTime.format(context);
    // ignore: unnecessary_null_comparison
    if (formattedTime == null) {
      AppMethods().showToast(title: 'Time Canceled');
    } else if (isStartTime == true) {
      setState(() {
        startTime = formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        endTime = formattedTime;
      });
    }
  }

  showtimePicker() {
    return showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(startTime.split(":")[0]),
          minute: int.parse(startTime.split(":")[1].split(" ")[0]),
        ),
        initialEntryMode: TimePickerEntryMode.input);
  }

  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? white : primaryClr,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      actions: const [
        CircleAvatar(
          radius: 15,
          backgroundImage: AssetImage('assets/user.png'),
        ),
        SizedBox(
          width: 15,
        ),
      ],
    );
  }
}
