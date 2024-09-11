import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../model/comment_model.dart';
import '../../../utils/api_services.dart';

class CommentsController extends Bloc<CommentsEvent, CommentsState> {
  final int postId;

  CommentsController({required this.postId}) : super(CommentsInitial()) {
    on<CommentsInitialFetchEvent>(commentsInitialFetchEvent);
    // on<CommentAddEvent>(commentAddEvent);
  }

  // Event handler for fetching comments
  Future<void> commentsInitialFetchEvent(
      CommentsInitialFetchEvent event, Emitter<CommentsState> emit) async {
    emit(CommentsFetchingLoadingState());

    try {
      List<CommentModel> comments = await APIServices.fetchComments();

      // Filter comments by postId
      List<CommentModel> postComments =
          comments.where((comment) => comment.postId == postId).toList();

      // emit(CommentFetchingSuccessfulState(comments: comments));
      emit(CommentFetchingSuccessfulState(comments: postComments));
    } catch (e) {
      log(e.toString());
      emit(CommentsFetchingErrorState());
    }
  }

  // Event handler for adding a comment
  // Future<void> commentAddEvent(
  //     CommentAddEvent event, Emitter<CommentsState> emit) async {
  //   bool success = await APIServices.addComment();
  //   if (success) {
  //     emit(CommentsAdditionSuccessState());
  //   } else {
  //     emit(CommentsAdditionErrorState());
  //   }
  // }
}

// Define CommentsEvent class and its events
@immutable
abstract class CommentsEvent {}

class CommentsInitialFetchEvent extends CommentsEvent {}

class CommentAddEvent extends CommentsEvent {}

// Define CommentsState class and its states
abstract class CommentsState {}

abstract class CommentsActionState extends CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsFetchingLoadingState extends CommentsState {}

class CommentsFetchingErrorState extends CommentsState {}

class CommentFetchingSuccessfulState extends CommentsState {
  final List<CommentModel> comments;

  CommentFetchingSuccessfulState({required this.comments});
}

class CommentsAdditionSuccessState extends CommentsState {}

class CommentsAdditionErrorState extends CommentsState {}
