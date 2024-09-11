// To parse this JSON data, do
//
//     final photoModel = photoModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PhotoModel photoModelFromMap(String str) =>
    PhotoModel.fromMap(json.decode(str));

String photoModelToMap(PhotoModel data) => json.encode(data.toMap());

class PhotoModel {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  PhotoModel({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory PhotoModel.fromMap(Map<String, dynamic> json) => PhotoModel(
        albumId: json["albumId"],
        id: json["id"],
        title: json["title"],
        url: json["url"],
        thumbnailUrl: json["thumbnailUrl"],
      );

  Map<String, dynamic> toMap() => {
        "albumId": albumId,
        "id": id,
        "title": title,
        "url": url,
        "thumbnailUrl": thumbnailUrl,
      };
}
