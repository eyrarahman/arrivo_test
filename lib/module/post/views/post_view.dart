import 'package:arrivo_test/module/post/controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Post extends StatefulWidget {
  final int userId;

  const Post({super.key, required this.userId});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late PostsController postsController;

  // final PostsBloc postsBloc = PostsBloc();

  @override
  void initState() {
    super.initState();
    postsController = PostsController(userId: widget.userId);
    postsController.add(PostsInitialFetchEvent());
  }

  @override
  void dispose() {
    postsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: Text('Posts')),
      // ),
      //to add new post
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            postsController.add(PostAddEvent());
          }),
      body: BlocConsumer<PostsController, PostsState>(
          bloc: postsController,
          listenWhen: (previous, current) => current is PostsActionState,
          buildWhen: (previous, current) => current is! PostsActionState,
          builder: (context, state) {
            switch (state.runtimeType) {
              case PostsFetchingLoadingState:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case PostFetchingSuccessfulState:
                final successState = state as PostFetchingSuccessfulState;
                return Container(
                  child: ListView.builder(
                    itemCount: successState.posts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.indigo.shade100,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Title: ${successState.posts[index].title}"),
                            Text("Body: ${successState.posts[index].body}"),
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
