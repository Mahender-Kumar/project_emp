import 'package:flutter/material.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/data/models/employee_model.dart';

class EmployeeTile extends StatelessWidget {
  final Employee employee;

  const EmployeeTile({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Dismissible(
          key: Key('${employee.id}'), // Unique key for dismissing
          direction: DismissDirection.endToStart, // Swipe from right to left
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Theme.of(context).colorScheme.errorContainer,
            child: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.white,
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text("Confirm Deletion"),
                    content: const Text(
                      "Are you sure you want to delete this employee?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
            );
          },
          onDismissed: (direction) {
            // onDismissed(employee); // Call the provided dismissal handler
          },
          child: ListTile(
            dense: true,

            title: Text(
              employee.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee.position, style: const TextStyle(fontSize: 12)),
                // Text(
                //   !employee.isCurrent
                //       ? '${employee.hireDate}-${employee.leavingDate}'
                //       : employee.hireDate,
                //   style: const TextStyle(fontSize: 12),
                // ),
              ],
            ),
            trailing: PopupMenuButton(
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
                          // child: EditTodo(todo: todo),
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
          ),
        ),
      ],
    );
  }
}
