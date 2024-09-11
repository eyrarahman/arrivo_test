import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../model/todo_model.dart';
import '../../../utils/api_services.dart';

class TodosController extends Bloc<TodosEvent, TodosState> {
  TodosController() : super(TodosInitial()) {
    on<TodosInitialFetchEvent>(todosInitialFetchEvent);
    on<TodoAddEvent>(todoAddEvent);
  }

  // Event handler for fetching todos
  Future<void> todosInitialFetchEvent(
      TodosInitialFetchEvent event, Emitter<TodosState> emit) async {
    emit(TodosFetchingLoadingState());

    try {
      List<TodoModel> todos = await APIServices.fetchTodos();
      emit(TodoFetchingSuccessfulState(todos: todos));
    } catch (e) {
      log(e.toString());
      emit(TodosFetchingErrorState());
    }
  }

  // Event handler for adding a todo
  Future<void> todoAddEvent(
      TodoAddEvent event, Emitter<TodosState> emit) async {
    bool success = await APIServices.addTodo();
    if (success) {
      emit(TodosAdditionSuccessState());
    } else {
      emit(TodosAdditionErrorState());
    }
  }
}

// Define TodosEvent class and its events
@immutable
abstract class TodosEvent {}

class TodosInitialFetchEvent extends TodosEvent {}

class TodoAddEvent extends TodosEvent {}

// Define TodosState class and its states
abstract class TodosState {}

abstract class TodosActionState extends TodosState {}

class TodosInitial extends TodosState {}

class TodosFetchingLoadingState extends TodosState {}

class TodosFetchingErrorState extends TodosState {}

class TodoFetchingSuccessfulState extends TodosState {
  final List<TodoModel> todos;

  TodoFetchingSuccessfulState({required this.todos});
}

class TodosAdditionSuccessState extends TodosState {}

class TodosAdditionErrorState extends TodosState {}
