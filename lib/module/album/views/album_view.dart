import 'package:arrivo_test/module/album/controllers/album_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Album extends StatefulWidget {
  final int userId;

  const Album({super.key, required this.userId});

  @override
  State<Album> createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  late AlbumsController albumsController;

  // final AlbumsBloc albumsBloc = AlbumsBloc();

  @override
  void initState() {
    super.initState();
    albumsController = AlbumsController(userId: widget.userId);

    albumsController.add(AlbumsInitialFetchEvent());
  }

  @override
  void dispose() {
    albumsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: Text('Albums')),
      // ),
      //to add new album
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            albumsController.add(AlbumAddEvent());
          }),
      body: BlocConsumer<AlbumsController, AlbumsState>(
          bloc: albumsController,
          listenWhen: (previous, current) => current is AlbumsActionState,
          buildWhen: (previous, current) => current is! AlbumsActionState,
          builder: (context, state) {
            switch (state.runtimeType) {
              case AlbumsFetchingLoadingState:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case AlbumFetchingSuccessfulState:
                final successState = state as AlbumFetchingSuccessfulState;
                return Container(
                  child: ListView.builder(
                    itemCount: successState.albums.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.indigo.shade100,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Title: ${successState.albums[index].title}"),
                            Text("Body: ${successState.albums[index].userId}"),
                          ],
                        ),
                      );
                    },
                  ),
                );
              default:
                return const SizedBox();
            }
            ;
          },
          listener: (context, state) {}),
    );
  }
}
