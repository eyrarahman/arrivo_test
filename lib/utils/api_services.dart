import 'dart:convert';
import 'dart:developer';

import '../../../model/post_model.dart';
import 'package:http/http.dart' as http;

import '../model/album_model.dart';
import '../model/comment_model.dart';
import '../model/photo_model.dart';
import '../model/todo_model.dart';
import '../model/user_model.dart';

class APIServices {
  //------------------ get ------------------------

  //post
  static Future<List<PostModel>> fetchPosts() async {
    var client = http.Client();
    List<PostModel> posts = [];
    try {
      var response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      List result = jsonDecode(response.body);
      for (int i = 0; i < result.length; i++) {
        PostModel post = PostModel.fromMap(result[i] as Map<String, dynamic>);
        posts.add(post);
      }
      return posts;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

//user
  static Future<List<UserModel>> fetchUsers() async {
    var client = http.Client();
    List<UserModel> users = [];
    try {
      var response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

      List result = jsonDecode(response.body);
      for (int i = 0; i < result.length; i++) {
        UserModel user = UserModel.fromMap(result[i] as Map<String, dynamic>);
        users.add(user);
      }
      return users;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

//album
  static Future<List<AlbumModel>> fetchAlbums() async {
    var client = http.Client();
    List<AlbumModel> albums = [];
    try {
      var response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

      List result = jsonDecode(response.body);
      for (int i = 0; i < result.length; i++) {
        AlbumModel album =
            AlbumModel.fromMap(result[i] as Map<String, dynamic>);
        albums.add(album);
      }
      return albums;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  //comment
  static Future<List<CommentModel>> fetchComments() async {
    var client = http.Client();
    List<CommentModel> comments = [];
    try {
      var response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));

      List result = jsonDecode(response.body);
      for (int i = 0; i < result.length; i++) {
        CommentModel comment =
            CommentModel.fromMap(result[i] as Map<String, dynamic>);
        comments.add(comment);
      }
      return comments;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  //photo
  static Future<List<PhotoModel>> fetchPhotos() async {
    var client = http.Client();
    List<PhotoModel> photos = [];
    try {
      var response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

      List result = jsonDecode(response.body);
      for (int i = 0; i < result.length; i++) {
        PhotoModel photo =
            PhotoModel.fromMap(result[i] as Map<String, dynamic>);
        photos.add(photo);
      }
      return photos;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  //todo
  static Future<List<TodoModel>> fetchTodos() async {
    var client = http.Client();
    List<TodoModel> todos = [];
    try {
      var response = await client
          .get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

      List result = jsonDecode(response.body);
      for (int i = 0; i < result.length; i++) {
        TodoModel todo = TodoModel.fromMap(result[i] as Map<String, dynamic>);
        todos.add(todo);
      }
      return todos;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  //------------------ post ------------------------
  static Future<bool> addPost() async {
    var client = http.Client();
    try {
      var response = await client.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          body: {"title": "yeay", "body": "i make it", "userId": "34"});

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> addUser() async {
    var client = http.Client();
    try {
      var response = await client.post(
          Uri.parse('https://jsonplaceholder.typicode.com/users'),
          body: {});

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> addAlbum() async {
    var client = http.Client();
    try {
      var response = await client.post(
          Uri.parse('https://jsonplaceholder.typicode.com/albums'),
          body: {});

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> addTodo() async {
    var client = http.Client();
    try {
      var response = await client.post(
          Uri.parse('https://jsonplaceholder.typicode.com/todos/1'),
          body: {});

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
