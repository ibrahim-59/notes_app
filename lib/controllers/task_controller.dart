import 'package:get/get.dart';
import 'package:notes_app/db/db_helper.dart';
import 'package:notes_app/models/task_model.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taksList = <TaskModel>[].obs;

  Future<int> addTask({TaskModel? task}) async {
    return await DbHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DbHelper.query();
    taksList.assignAll(tasks.map((data) => TaskModel.fromJson(data)).toList());
  }

  void delete(TaskModel taskModel) {
    DbHelper.delete(taskModel);
  }

  void taskCompleted(int id) async {
    await DbHelper.update(id);
    getTasks();
  }
}
