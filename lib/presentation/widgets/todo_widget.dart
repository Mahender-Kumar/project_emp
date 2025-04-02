import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/data/models/employee_model.dart';
import 'package:project_emp/extensions/string_extensions.dart';
import 'package:project_emp/extensions/time_extensions.dart';
import 'package:project_emp/presentation/services/firestore_service.dart';
import 'package:project_emp/presentation/widgets/date_picker.dart';
import 'package:project_emp/presentation/widgets/expanded_btn.dart';
import 'package:project_emp/services/generate_tags.dart';

class TodoItemWidget extends StatelessWidget {
  final Employee todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: .5,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.threeLine,
        // leading: Checkbox(
        //   // value: todo.isCompleted,
        //   onChanged: (value) => onToggle(),
        // ),
        title: Text(
          todo.name,
          style: TextStyle(
            // decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(todo.email ?? ''),
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
                    return EditTodo(todo: todo);
                  },
                );
                break;
              case 'delete':
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
                  leading: Icon(Icons.edit, size: listTileIconSize),
                  title: Text('Edit'),
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                height: popupMenuButtonHeight,
                child: ListTile(
                  dense: true,

                  leading: Icon(Icons.delete, size: listTileIconSize),
                  title: Text('Delete'),
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}

class EditTodo extends StatefulWidget {
  final Employee? todo;
  const EditTodo({super.key, this.todo});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  FirestoreService firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: TextEditingController(text: widget.todo?.name ?? ''),
              decoration: InputDecoration(
                isDense: true,
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) => value!.isEmpty ? "Please enter a title" : null,
              onChanged: (value) {
                // widget.todo?.name = value;
              },
            ),
            SizedBox(height: defaultGapping),
            TextFormField(
              maxLines: 3,
              minLines: 3,
              controller: TextEditingController(text: widget.todo?.name ?? ''),
              decoration: InputDecoration(
                isDense: true,

                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              validator:
                  (value) => value!.isEmpty ? "Please enter a title" : null,
              onChanged: (value) {
                // widget.todo?.name = value;
              },
            ),
            SizedBox(height: defaultGapping),

            DatePicker(
              label: 'Due Date',
              validate: true,
              controller: TextEditingController(
                // text: widget.todo?.dueDate?.toFormattedTimestampString(),
              ),
              onDateTimeSelected: (dateSelected) {
                // widget.todo?.dueDate = Timestamp.fromDate(dateSelected);
              },
            ),

            SizedBox(height: defaultGapping),
            // DropdownButtonFormField<Priorities>(
            //   decoration: const InputDecoration(
            //     isDense: true,
            //     labelText: "Priority",
            //     border: OutlineInputBorder(),
            //   ),
            //   // value: widget.todo?.priority ?? Priorities.low,
            //   items:
            //       Priorities.values
            //           .map(
            //             (e) => DropdownMenuItem(
            //               value: e,
            //               child: Text(e.name.toTitleCase()),
            //             ),
            //           )
            //           .toList(),
            //   onChanged: (value) {
            //     // widget.todo?.priority = value ?? Priorities.low;
            //   },
            //   validator:
            //       (value) => value == null ? "Please select a priority" : null,
            // ),
            const SizedBox(height: 20),

            ExpandedBtn(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                // widget.todo?.updatedAt = Timestamp.now();
                // widget.todo?.timestamp = Timestamp.now();
                // firestoreService.saveTodo(
                //   widget.todo!,
                //   tags: generateTags(widget.todo?.title ?? ''),
                // );
                context.pop();

                // todo.priority = value ?? Priorities.low;
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(btnRadius),
                ),
              ),

              child: Text('Update'),
            ),
            SizedBox(height: bottomGapping),
          ],
        ),
      ),
    );
  }
}
