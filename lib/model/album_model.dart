// To parse this JSON data, do
//
//     final albumModel = albumModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AlbumModel albumModelFromMap(String str) =>
    AlbumModel.fromMap(json.decode(str));

String albumModelToMap(AlbumModel data) => json.encode(data.toMap());

class AlbumModel {
  final int userId;
  final int id;
  final String title;

  AlbumModel({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory AlbumModel.fromMap(Map<String, dynamic> json) => AlbumModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "id": id,
        "title": title,
      };
}
