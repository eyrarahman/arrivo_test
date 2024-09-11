import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../model/post_model.dart';
import '../../../utils/api_services.dart';

class PostsController extends Bloc<PostsEvent, PostsState> {
  final int userId;

  PostsController({required this.userId}) : super(PostsInitial()) {
    on<PostsInitialFetchEvent>(postsInitialFetchEvent);
    on<PostAddEvent>(postAddEvent);
  }

  // Event handler for fetching posts
  Future<void> postsInitialFetchEvent(
      PostsInitialFetchEvent event, Emitter<PostsState> emit) async {
    emit(PostsFetchingLoadingState());

    try {
      List<PostModel> posts = await APIServices.fetchPosts();

      // Filter posts by userId
      List<PostModel> userPosts =
          posts.where((post) => post.userId == userId).toList();

      // emit(PostFetchingSuccessfulState(posts: posts));
      emit(PostFetchingSuccessfulState(posts: userPosts));
    } catch (e) {
      log(e.toString());
      emit(PostsFetchingErrorState());
    }
  }

  // Event handler for adding a post
  Future<void> postAddEvent(
      PostAddEvent event, Emitter<PostsState> emit) async {
    bool success = await APIServices.addPost();
    if (success) {
      emit(PostsAdditionSuccessState());
    } else {
      emit(PostsAdditionErrorState());
    }
  }
}

// Define PostsEvent class and its events
@immutable
abstract class PostsEvent {}

class PostsInitialFetchEvent extends PostsEvent {}

class PostAddEvent extends PostsEvent {}

// Define PostsState class and its states
abstract class PostsState {}

abstract class PostsActionState extends PostsState {}

class PostsInitial extends PostsState {}

class PostsFetchingLoadingState extends PostsState {}

class PostsFetchingErrorState extends PostsState {}

class PostFetchingSuccessfulState extends PostsState {
  final List<PostModel> posts;

  PostFetchingSuccessfulState({required this.posts});
}

class PostsAdditionSuccessState extends PostsState {}

class PostsAdditionErrorState extends PostsState {}
