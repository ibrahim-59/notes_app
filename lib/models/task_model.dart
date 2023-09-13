class TaskModel {
  int? id;
  String title;
  String note;
  int? isCompleted;
  String date;
  String startTime;
  String endTime;
  int color;
  int remind;
  String repeat;

  TaskModel({
    this.id,
    required this.date,
    required this.title,
    required this.note,
    required this.color,
    required this.endTime,
    this.isCompleted,
    required this.remind,
    required this.repeat,
    required this.startTime,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      date: json['date'],
      title: json['title'],
      note: json['note'],
      color: json['color'],
      endTime: json['endTime'],
      isCompleted: json['isCompleted'],
      remind: json['remind'],
      repeat: json['repeat'],
      startTime: json['startTime'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['date'] = date;
    data['title'] = title;
    data['note'] = note;
    data['color'] = color;
    data['endTime'] = endTime;
    data['isCompleted'] = isCompleted;
    data['remind'] = remind;
    data['repeat'] = repeat;
    data['startTime'] = startTime;
    return data;
  }
}
