import 'package:arrivo_test/module/post/controllers/post_controller.dart';
import 'package:arrivo_test/module/user/widgets/user_album_photo.dart';
import 'package:arrivo_test/module/user/widgets/user_post_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/user_model.dart';
import '../../album/controllers/album_controller.dart'; // Adjust according to your model's location

class UserDetails extends StatelessWidget {
  final UserModel user;

  // Constructor that assigns the 'user' variable
  const UserDetails({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PostsController>(
          create: (context) =>
              PostsController(userId: user.id)..add(PostsInitialFetchEvent()),
        ),
        BlocProvider<AlbumsController>(
          create: (context) => AlbumsController(userId: user.id)
            ..add(AlbumsInitialFetchEvent()), //
        ),
      ],
      child: DefaultTabController(
        length: 2, // Two tabs: Posts and Albums
        child: Scaffold(
          body: Column(
            children: [
              // Top Stack with Profile and Info
              Stack(
                children: [
                  // Background Gradient
                  Container(
                    height: 400,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 199, 172, 53),
                          Color.fromARGB(255, 228, 228, 106),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Back Button
                  Positioned(
                    top: 50,
                    left: 10,
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Go back to previous page
                      },
                    ),
                  ),

                  // Profile Info
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              AssetImage('assets/images/profile.jpg'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.company.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user.company.catchPhrase,
                          style: const TextStyle(
                              fontSize: 19, color: Colors.black),
                        ),
                        const SizedBox(height: 15),
                        // User Details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.email),
                            const SizedBox(width: 8),
                            Text(
                              user.email,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.call),
                            const SizedBox(width: 8),
                            Text(
                              user.phone,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.pin_drop),
                            const SizedBox(width: 8),
                            Text(
                              "${user.address.street}, ${user.address.city}",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // TabBar
              const TabBar(
                labelColor: Colors.indigo,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.indigo,
                tabs: [
                  Tab(text: "Posts"),
                  Tab(text: "Albums"),
                ],
              ),

              // Expanded TabBarView for Posts and Albums
              Expanded(
                child: TabBarView(
                  children: [
                    // Posts Tab
                    BlocBuilder<PostsController, PostsState>(
                      builder: (context, state) {
                        if (state is PostsFetchingLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is PostFetchingSuccessfulState) {
                          if (state.posts.isEmpty) {
                            return const Center(child: Text('No posts found'));
                          }
                          return ListView.builder(
                            itemCount: state.posts.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(Icons.article,
                                    color: Color.fromARGB(255, 126, 126, 12)),
                                title: Text(state.posts[index].title),
                                // subtitle: Text(state.posts[index].body),
                                subtitle: Text("${state.posts[index].body}, "),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Comments(
                                          postId: state.posts[index].id,
                                          userId: state.posts[index]
                                              .userId), // Pass the post.id to Comments
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('Error fetching posts'));
                        }
                      },
                    ),
                    //Album tab

                    BlocBuilder<AlbumsController, AlbumsState>(
                      builder: (context, state) {
                        if (state is AlbumsFetchingLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is AlbumFetchingSuccessfulState) {
                          if (state.albums.isEmpty) {
                            return const Center(child: Text('No albums found'));
                          }
                          return ListView.builder(
                            itemCount: state.albums.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(Icons.photo_album,
                                    color: Color.fromARGB(255, 126, 126, 12)),
                                title: Text(state.albums[index].title),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Photos(
                                          albumId: state.albums[index].id,
                                          userId: state.albums[index].userId),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('Error fetching albums'));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
