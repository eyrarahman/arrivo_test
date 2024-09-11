import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../user/controllers/user_controller.dart';
import '../controllers/todo_controller.dart';

class Todo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Todo'),
      // ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<TodosController>(
            create: (context) =>
                TodosController()..add(TodosInitialFetchEvent()),
          ),
          BlocProvider<UsersController>(
            create: (context) =>
                UsersController()..add(UsersInitialFetchEvent()),
          ),
        ],
        child: BlocBuilder<TodosController, TodosState>(
          builder: (context, todoState) {
            if (todoState is TodosFetchingLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (todoState is TodoFetchingSuccessfulState) {
              return BlocBuilder<UsersController, UsersState>(
                builder: (context, userState) {
                  if (userState is UsersFetchingLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userState is UserFetchingSuccessfulState) {
                    return ListView.builder(
                      itemCount: todoState.todos.length,
                      itemBuilder: (context, index) {
                        final todo = todoState.todos[index];
                        final user = userState.users.firstWhere(
                          (user) => user.id == todo.userId,
                        );

                        return ListTile(
                          title: Text(todo.title),
                          subtitle: Text("Assigned to: ${user.name}"),
                          trailing: todo.completed
                              ? Icon(Icons.check, color: Colors.green)
                              : Icon(Icons.close, color: Colors.red),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Error fetching users'));
                  }
                },
              );
            } else {
              return const Center(child: Text('Error fetching todos'));
            }
          },
        ),
      ),
    );
  }
}
