import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controllers/user_controller.dart';
import '../widgets/user_details.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UsersState();
}

class _UsersState extends State<User> {
  final UsersController usersController = UsersController();

  @override
  void initState() {
    super.initState();
    usersController.add(UsersInitialFetchEvent());
  }

  @override
  void dispose() {
    usersController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UsersController, UsersState>(
          bloc: usersController,
          listenWhen: (previous, current) => current is UsersActionState,
          buildWhen: (previous, current) => current is! UsersActionState,
          builder: (context, state) {
            switch (state.runtimeType) {
              case UsersFetchingLoadingState:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case UserFetchingSuccessfulState:
                final successState = state as UserFetchingSuccessfulState;
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4), // Add margin between tiles
                  child: ListView.builder(
                    itemCount: successState.users.length,
                    itemBuilder: (context, index) {
                      // return UserTile(user: successState.users[index]);
                      return ListTile(
                        tileColor: index % 2 == 0
                            ? Colors.grey.shade100 // Color for even index
                            : Colors.grey.shade300,
                        leading: CircleAvatar(
                          child: Text(
                            "${successState.users[index].id}",
                            style: TextStyle(fontSize: 20),
                          ),
                          radius: 30,
                          backgroundColor: Color.fromARGB(255, 206, 214, 139),
                        ),
                        title: Text(
                          successState.users[index].name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.public),
                            const Text("  "),
                            Text(
                              successState.users[index].website,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.more_horiz),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UserDetails(
                                    user: successState.users[index]);
                              },
                            ),
                          );
                        },
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
