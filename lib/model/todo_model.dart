// To parse this JSON data, do
//
//     final todoModel = todoModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TodoModel todoModelFromMap(String str) => TodoModel.fromMap(json.decode(str));

String todoModelToMap(TodoModel data) => json.encode(data.toMap());

class TodoModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  TodoModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        completed: json["completed"],
      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
      };
}
