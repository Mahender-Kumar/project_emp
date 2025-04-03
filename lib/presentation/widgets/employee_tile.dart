import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/data/models/employee_model.dart';
import 'package:project_emp/presentation/services/firestore_service.dart';

class EmployeeTile extends StatelessWidget {
  final Employee employee;
  final bool? isDismissible;
  final bool showTrailingIcon;

  EmployeeTile({
    super.key,
    required this.employee,
    this.isDismissible = true,
    this.showTrailingIcon = true,
  });

  formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    String parsedDate = DateFormat("d MMM, yyyy").format(date);
    return parsedDate;
  }

  FirestoreService firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Dismissible(
          key: Key('${employee.id}'), // Unique key for dismissing
          direction:
              isDismissible == true
                  ? DismissDirection.endToStart
                  : DismissDirection.none, // Swipe from right to left
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
                        onPressed: () async {
                          await firestoreService.moveToTrash(employee);
                          Navigator.of(context).pop(true);
                        },
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
                Text(
                  !(employee.isCurrent)
                      ? '${formatDate(employee.hireDate)} - ${formatDate(employee.leavingDate)}'
                      : '${formatDate(employee.hireDate)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing:
                showTrailingIcon
                    ? PopupMenuButton(
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
                                        MediaQuery.of(context)
                                            .viewInsets
                                            .bottom, // Adjust for keyboard
                                  ),
                                  // child: EditTodo(todo: todo),
                                );
                              },
                            );
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
                              trailing: Icon(
                                Icons.edit,
                                size: listTileIconSize,
                              ),
                              title: Text('Edit'),
                            ),
                          ),
                        ];
                      },
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
