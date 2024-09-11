import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../model/user_model.dart';
import '../../../utils/api_services.dart';

class UsersController extends Bloc<UsersEvent, UsersState> {
  UsersController() : super(UsersInitial()) {
    on<UsersInitialFetchEvent>(usersInitialFetchEvent);
    on<UserAddEvent>(userAddEvent);
  }

  // Event handler for fetching users
  Future<void> usersInitialFetchEvent(
      UsersInitialFetchEvent event, Emitter<UsersState> emit) async {
    emit(UsersFetchingLoadingState());

    try {
      List<UserModel> users = await APIServices.fetchUsers();
      emit(UserFetchingSuccessfulState(users: users));
    } catch (e) {
      log(e.toString());
      emit(UsersFetchingErrorState());
    }
  }

  // Event handler for adding a user
  Future<void> userAddEvent(
      UserAddEvent event, Emitter<UsersState> emit) async {
    bool success = await APIServices.addUser();
    if (success) {
      emit(UsersAdditionSuccessState());
    } else {
      emit(UsersAdditionErrorState());
    }
  }
}

// Define UsersEvent class and its events
@immutable
abstract class UsersEvent {}

class UsersInitialFetchEvent extends UsersEvent {}

class UserAddEvent extends UsersEvent {}

// Define UsersState class and its states
abstract class UsersState {}

abstract class UsersActionState extends UsersState {}

class UsersInitial extends UsersState {}

class UsersFetchingLoadingState extends UsersState {}

class UsersFetchingErrorState extends UsersState {}

class UserFetchingSuccessfulState extends UsersState {
  final List<UserModel> users;

  UserFetchingSuccessfulState({required this.users});
}

class UsersAdditionSuccessState extends UsersState {}

class UsersAdditionErrorState extends UsersState {}
