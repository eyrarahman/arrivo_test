import 'dart:ui';

import 'package:flutter/material.dart';

import '../../comment/controllers/comment_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Comments extends StatefulWidget {
  final int postId;
  final int userId;

  const Comments({super.key, required this.postId, required this.userId});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  late CommentsController commentsController;

  @override
  void initState() {
    super.initState();
    commentsController = CommentsController(postId: widget.postId);
    commentsController.add(CommentsInitialFetchEvent());
  }

  @override
  void dispose() {
    commentsController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: BlocConsumer<CommentsController, CommentsState>(
          bloc: commentsController,
          listenWhen: (previous, current) => current is CommentsActionState,
          buildWhen: (previous, current) => current is! CommentsActionState,
          builder: (context, state) {
            switch (state.runtimeType) {
              case CommentsFetchingLoadingState:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case CommentFetchingSuccessfulState:
                final successState = state as CommentFetchingSuccessfulState;
                return Container(
                  child: ListView.builder(
                    itemCount: successState.comments.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(top: 30),
                        margin: const EdgeInsets.only(right: 8),
                        height: 180,
                        child: ListTile(
                          isThreeLine: true,
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/people.jpg'),
                          ),
                          title: Text(
                            successState.comments[index].name,
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: successState.comments[index].email,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black38), // Style for email
                                ),
                                const TextSpan(
                                  text:
                                      "\n\n", // Line break between email and body
                                ),
                                TextSpan(
                                  text: successState.comments[index].body,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors
                                          .black87), // Different size for body
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      // return Container(
                      //   color: Colors.indigo.shade100,
                      //   padding: const EdgeInsets.all(16),
                      //   margin: const EdgeInsets.all(16),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //           "username: ${successState.comments[index].name}, Post ID: ${successState.comments[index].postId}"),
                      //       Text(
                      //           "Body: ${successState.comments[index].name}\n, post title:${successState} "),
                      //     ],
                      //   ),
                      // );
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
