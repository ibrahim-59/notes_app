import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/controllers/task_controller.dart';
import 'package:notes_app/methods/toast.dart';
import 'package:notes_app/models/task_model.dart';
import 'package:notes_app/services/theme_service.dart';
import 'package:notes_app/ui/screens/add_task_page.dart';
import 'package:notes_app/ui/theme.dart';
import 'package:notes_app/ui/widgets/button.dart';
import 'package:notes_app/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController taskController = Get.put(TaskController());
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 20,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    taskController.getTasks();
    return Expanded(child: Obx(() {
      return ListView.builder(
        itemCount: taskController.taksList.length,
        itemBuilder: (context, index) {
          TaskModel task = taskController.taksList[index];
          if (task.repeat == 'Daily') {
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                    child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showBottomSheet(
                              context, taskController.taksList[index]);
                        },
                        child: TaskTile(task: taskController.taksList[index]),
                      ),
                    ],
                  ),
                )));
          } else if (task.date == DateFormat.yMd().format(selectedDate)) {
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                    child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showBottomSheet(
                              context, taskController.taksList[index]);
                        },
                        child: TaskTile(task: taskController.taksList[index]),
                      ),
                    ],
                  ),
                )));
          } else {
            Container();
          }
          return Container();
        },
      );
    }));
  }

  Container _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 70,
        selectionColor: primaryClr,
        selectedTextColor: white,
        initialSelectedDate: DateTime.now(),
        monthTextStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        dateTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        dayTextStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        onDateChange: (date) {
          setState(() {
            selectedDate = date;
          });
        },
      ),
    );
  }

  Padding addTaskBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd().format(
                  DateTime.now(),
                ),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              ),
            ],
          ),
          Button(
              title: 'Add Task',
              onpressed: () async {
                await Get.to(const AddTaskPage());
                taskController.getTasks();
              }),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          AppMethods().showToast(
              title: Get.isDarkMode
                  ? 'Activated Light Theme'
                  : 'Activated Dark Theme');
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
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

  showBottomSheet(BuildContext context, TaskModel task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreyClr : white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            task.isCompleted == 1
                ? Container()
                : bottomSheetButton(
                    label: 'Task Completed',
                    clr: primaryClr,
                    ontap: () {
                      taskController.taskCompleted(task.id!);
                      Get.back();
                    },
                    context: context,
                  ),
            bottomSheetButton(
              label: 'Delete Task',
              clr: Colors.red,
              ontap: () {
                taskController.delete(task);
                taskController.getTasks();
                Get.back();
              },
              context: context,
            ),
            const SizedBox(
              height: 20,
            ),
            bottomSheetButton(
              label: 'Close',
              isClose: true,
              clr: Colors.red,
              ontap: () {
                Get.back();
              },
              context: context,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  bottomSheetButton({
    required String label,
    required Color clr,
    required Function ontap,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: isClose == true ? Colors.transparent : clr,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: isClose ? titleStyle : titleStyle.copyWith(color: white),
          ),
        ),
      ),
    );
  }
}
