// To parse this JSON data, do
//
//     final commentModel = commentModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CommentModel commentModelFromMap(String str) =>
    CommentModel.fromMap(json.decode(str));

String commentModelToMap(CommentModel data) => json.encode(data.toMap());

class CommentModel {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  CommentModel({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory CommentModel.fromMap(Map<String, dynamic> json) => CommentModel(
        postId: json["postId"],
        id: json["id"],
        name: json["name"],
        email: json["email"],
        body: json["body"],
      );

  Map<String, dynamic> toMap() => {
        "postId": postId,
        "id": id,
        "name": name,
        "email": email,
        "body": body,
      };
}
