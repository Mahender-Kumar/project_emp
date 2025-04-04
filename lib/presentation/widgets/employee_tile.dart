import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  final FirestoreService firestoreService = FirestoreService();
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
              isDismissible == false
                  ? DismissDirection.none
                  : employee.isCurrent
                  ? DismissDirection.none
                  : DismissDirection.endToStart, // Swipe from right to left
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red[600],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 20),
                Text("Delete", style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(width: 8),
                const Icon(Icons.delete_forever_outlined, color: Colors.white),
              ],
            ),
          ),
          background: Container(
            // alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Theme.of(context).colorScheme.onSecondary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.person_remove_alt_1_outlined, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Terminate",
                  style: TextStyle(
                    // color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
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
                        FilledButton(
                          onPressed: () async {
                            await firestoreService.deleteEmployee(employee);
                            if (context.mounted) {
                              Navigator.of(context).pop(true);
                            }
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
              );
            }
            if (direction == DismissDirection.startToEnd) {
              return await showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Confirm Termination"),
                      content: const Text(
                        "Are you sure you want to terminate this employee?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                        FilledButton(
                          onPressed: () async {
                            await firestoreService.terminateEmployee(employee);
                            if (context.mounted) {
                              Navigator.of(context).pop(true);
                            }
                          },
                          child: const Text("Terminate"),
                        ),
                      ],
                    ),
              );
            }
            return null;
          },
          onDismissed: (direction) {},
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
                            context.pushNamed('edit', extra: employee);
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
