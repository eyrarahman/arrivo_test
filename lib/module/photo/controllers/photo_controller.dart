import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../model/photo_model.dart';
import '../../../model/photo_model.dart';
import '../../../utils/api_services.dart';

class PhotosController extends Bloc<PhotosEvent, PhotosState> {
  final int albumId;

  PhotosController({required this.albumId}) : super(PhotosInitial()) {
    on<PhotosInitialFetchEvent>(photosInitialFetchEvent);
    // on<PhotoAddEvent>(photoAddEvent);
  }

  // Event handler for fetching photos
  Future<void> photosInitialFetchEvent(
      PhotosInitialFetchEvent event, Emitter<PhotosState> emit) async {
    emit(PhotosFetchingLoadingState());

    try {
      List<PhotoModel> photos = await APIServices.fetchPhotos();

      // Filter photos by albumId
      List<PhotoModel> albumPhoto =
          photos.where((photo) => photo.albumId == albumId).toList();

      // emit(PhotoFetchingSuccessfulState(photos: photos));
      emit(PhotoFetchingSuccessfulState(photos: albumPhoto));
    } catch (e) {
      log(e.toString());
      emit(PhotosFetchingErrorState());
    }
  }

  // Event handler for adding a photo
  // Future<void> photoAddEvent(
  //     PhotoAddEvent event, Emitter<PhotosState> emit) async {
  //   bool success = await APIServices.addPhoto();
  //   if (success) {
  //     emit(PhotosAdditionSuccessState());
  //   } else {
  //     emit(PhotosAdditionErrorState());
  //   }
  // }
}

// Define PhotosEvent class and its events
@immutable
abstract class PhotosEvent {}

class PhotosInitialFetchEvent extends PhotosEvent {}

class PhotoAddEvent extends PhotosEvent {}

// Define PhotosState class and its states
abstract class PhotosState {}

abstract class PhotosActionState extends PhotosState {}

class PhotosInitial extends PhotosState {}

class PhotosFetchingLoadingState extends PhotosState {}

class PhotosFetchingErrorState extends PhotosState {}

class PhotoFetchingSuccessfulState extends PhotosState {
  final List<PhotoModel> photos;

  PhotoFetchingSuccessfulState({required this.photos});
}

class PhotosAdditionSuccessState extends PhotosState {}

class PhotosAdditionErrorState extends PhotosState {}
