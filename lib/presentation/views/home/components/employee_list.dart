import 'package:flutter/material.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/data/models/todo_model.dart';
import 'package:project_emp/presentation/services/firestore_service.dart';
import 'package:project_emp/presentation/views/history/history.dart';
import 'package:project_emp/presentation/widgets/todo_widget.dart';

class ExployeeListview extends StatelessWidget {
  final FirestoreService _firestoreService;

  ExployeeListview({super.key}) : _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _firestoreService.getTodos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return SliverFillRemaining(
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: Text("No employee records found")),
          );
        }

        final todos = snapshot.data!;

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final todo = Employee.fromMap(todos[index]);
            return TodoExpansionTile(
              todo: Employee(
                id: todo.id,
                name: todo.name,
                phone: todo.phone,
                email: todo.email,
                position: todo.position,
                department: todo.department,
                salary: todo.salary,
                hireDate: todo.hireDate,
                location: todo.location,
              ),

              // leadingIcon: Checkbox(
              //   value: todo.isCompleted,
              //   onChanged: (value) {
              //     _firestoreService.toggleTodoStatus(
              //       todo.id!,
              //       !(todo.isCompleted),
              //     );
              //   },
              // ),
              trailingIcon: PopupMenuButton(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      showModalBottomSheet(
                        useRootNavigator: true,
                        useSafeArea: true,
                        showDragHandle: true,
                        // isScrollControlled: true,
                        enableDrag: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(
                                    context,
                                  ).viewInsets.bottom, // Adjust for keyboard
                            ),
                            child: EditTodo(todo: todo),
                          );
                        },
                      );
                      break;
                    case 'delete':
                      // todo.deletedAt = Timestamp.now();
                      // todo.timestamp = Timestamp.now();
                      // _firestoreService.moveToTrash(todo);
                      break;
                    default:
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'edit',
                      height: popupMenuButtonHeight,
                      child: ListTile(
                        dense: true,
                        trailing: Icon(Icons.edit, size: listTileIconSize),
                        title: Text('Edit'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      height: popupMenuButtonHeight,
                      child: ListTile(
                        dense: true,

                        trailing: Icon(Icons.delete, size: listTileIconSize),
                        title: Text('Delete'),
                      ),
                    ),
                  ];
                },
              ),
            );
          }, childCount: todos.length),
        );
      },
    );
  }
}
