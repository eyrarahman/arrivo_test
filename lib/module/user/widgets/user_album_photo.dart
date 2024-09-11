import 'dart:ui';

import 'package:flutter/material.dart';

import '../../photo/controllers/photo_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../photo/controllers/photo_controller.dart';
import '../../photo/controllers/photo_controller.dart';

class Photos extends StatefulWidget {
  final int albumId;
  final int userId;

  const Photos({super.key, required this.albumId, required this.userId});

  @override
  State<Photos> createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  late PhotosController photosController;

  @override
  void initState() {
    super.initState();
    photosController = PhotosController(albumId: widget.albumId);
    photosController.add(PhotosInitialFetchEvent());
  }

  @override
  void dispose() {
    photosController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Photo"),
        ),
        body: BlocConsumer<PhotosController, PhotosState>(
          bloc: photosController,
          listenWhen: (previous, current) => current is PhotosActionState,
          buildWhen: (previous, current) => current is! PhotosActionState,
          builder: (context, state) {
            switch (state.runtimeType) {
              case PhotosFetchingLoadingState:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case PhotoFetchingSuccessfulState:
                final successState = state as PhotoFetchingSuccessfulState;
                return GridView.builder(
                  padding: const EdgeInsets.all(
                      8), // Optional: Padding around the grid
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 10, // Space between grid columns
                    mainAxisSpacing: 10, // Space between grid rows
                    childAspectRatio: 1, // Aspect ratio for each grid tile
                  ),
                  itemCount: successState.photos.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // Changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(successState
                                .photos[index]
                                .thumbnailUrl), // Load thumbnail image from network
                          ),
                          const SizedBox(
                              height: 2), // Spacing between avatar and text
                          Center(
                            child: Text(
                              "Album ID: ${successState.photos[index].title}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black38),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              default:
                return const SizedBox();
            }
          },
          listener: (context, state) {},
        ));
  }
}
