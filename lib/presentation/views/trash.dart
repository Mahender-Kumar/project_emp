import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/data/models/todo_model.dart';
import 'package:project_emp/presentation/services/firestore_service.dart';
import 'package:project_emp/presentation/views/history/history.dart';

class TrashPage extends StatelessWidget {
  TrashPage({super.key});

  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,

            title: ListTile(
              dense: true,
              leading: IconButton(
                iconSize: defaultIconSize,
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text("Trash"),
            ),
            pinned: true,
            floating: false,
            snap: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: _firestore.clearTrash,
                tooltip: "Clear Trash",
              ),
              SizedBox(width: defaultGapping),
            ],
          ),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _firestore.getDeletedTodos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverFillRemaining(
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverFillRemaining(
                  child: const Center(child: Text("No deleted items")),
                );
              }

              var deletedTodos = snapshot.data!;

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final todo = Employee.fromMap(deletedTodos[index]);

                  return TodoExpansionTile(
                    todo: todo,

                    trailingIcon: PopupMenuButton(
                      onSelected: (value) {
                        switch (value) {
                          case 'restore':
                            // todo.restoredAt = Timestamp.now();
                            // todo.timestamp = Timestamp.now();
                            // todo.isRestored = true;
                            // _firestore.restoreDeletedTodo(todo);

                            break;

                          default:
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'restore',
                            height: popupMenuButtonHeight,

                            child: ListTile(
                              dense: true,
                              trailing: const Icon(Icons.restore),
                              title: Text('Restore'),
                            ),
                          ),
                        ];
                      },
                    ),
                  );
                }, childCount: deletedTodos.length),
              );
            },
          ),
        ],
      ),
    );
  }
}
