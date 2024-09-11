import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../model/album_model.dart';
import '../../../utils/api_services.dart';

class AlbumsController extends Bloc<AlbumsEvent, AlbumsState> {
  final int userId;

  AlbumsController({required this.userId}) : super(AlbumsInitial()) {
    on<AlbumsInitialFetchEvent>(albumsInitialFetchEvent);
    on<AlbumAddEvent>(albumAddEvent);
  }

  // Event handler for fetching albums
  Future<void> albumsInitialFetchEvent(
      AlbumsInitialFetchEvent event, Emitter<AlbumsState> emit) async {
    emit(AlbumsFetchingLoadingState());

    try {
      List<AlbumModel> albums = await APIServices.fetchAlbums();

      // Filter posts by userId
      List<AlbumModel> userAlbums =
          albums.where((album) => album.userId == userId).toList();
      emit(AlbumFetchingSuccessfulState(albums: userAlbums));
    } catch (e) {
      log(e.toString());
      emit(AlbumsFetchingErrorState());
    }
  }

  // Event handler for adding a album
  Future<void> albumAddEvent(
      AlbumAddEvent event, Emitter<AlbumsState> emit) async {
    bool success = await APIServices.addAlbum();
    if (success) {
      emit(AlbumsAdditionSuccessState());
    } else {
      emit(AlbumsAdditionErrorState());
    }
  }
}

// Define AlbumsEvent class and its events
@immutable
abstract class AlbumsEvent {}

class AlbumsInitialFetchEvent extends AlbumsEvent {}

class AlbumAddEvent extends AlbumsEvent {}

// Define AlbumsState class and its states
abstract class AlbumsState {}

abstract class AlbumsActionState extends AlbumsState {}

class AlbumsInitial extends AlbumsState {}

class AlbumsFetchingLoadingState extends AlbumsState {}

class AlbumsFetchingErrorState extends AlbumsState {}

class AlbumFetchingSuccessfulState extends AlbumsState {
  final List<AlbumModel> albums;

  AlbumFetchingSuccessfulState({required this.albums});
}

class AlbumsAdditionSuccessState extends AlbumsState {}

class AlbumsAdditionErrorState extends AlbumsState {}
