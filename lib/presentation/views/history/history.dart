import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/blocs/history/history_bloc.dart';
import 'package:project_emp/blocs/history/history_event.dart';
import 'package:project_emp/blocs/history/history_state.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/data/enum/status.dart';
import 'package:project_emp/data/models/employee_model.dart';
import 'package:project_emp/extensions/time_extensions.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  final DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(FetchHistoryEvent(_selectedDay));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: const Text("History"),
        leading: IconButton(
          iconSize: defaultIconSize,
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              elevation: 0,
              child: SfCalendar(
                view: CalendarView.month,
                onTap: (calendarTapDetails) {
                  if (calendarTapDetails.date != null) {
                    if (calendarTapDetails.date != null) {
                      context.read<HistoryBloc>().add(
                        FetchHistoryEvent(calendarTapDetails.date!),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is HistoryError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  if (state is HistoryLoaded) {
                    var historyItems = state.historyItems;
                    if (historyItems.isEmpty) {
                      return const Center(
                        child: Text('No history found for this date.'),
                      );
                    }
                    return ListView.builder(
                      itemCount: historyItems.length,
                      itemBuilder: (context, index) {
                        final historyTodo = Employee.fromMap(
                          historyItems[index],
                        );
                        return EmployeeTile(employee: historyTodo);
                      },
                    );
                  }
                  return const Center(
                    child: Text('Select a date to view history.'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeTile extends StatelessWidget {
  final Employee employee;

  const EmployeeTile({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryExpansionTileBloc(),
      child: BlocBuilder<HistoryExpansionTileBloc, HistoryExpansionTileState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Dismissible(
                key: Key('${employee.id}'), // Unique key for dismissing
                direction:
                    DismissDirection.endToStart, // Swipe from right to left
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
                      Text(
                        employee.position,
                        style: const TextStyle(fontSize: 12),
                      ),
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
                                      MediaQuery.of(context)
                                          .viewInsets
                                          .bottom, // Adjust for keyboard
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

                            trailing: Icon(
                              Icons.delete,
                              size: listTileIconSize,
                            ),
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
        },
      ),
    );
  }
}

// Events
abstract class HistoryExpansionTileEvent {}

class ToggleExpansionEvent extends HistoryExpansionTileEvent {}

// States
abstract class HistoryExpansionTileState {}

class HistoryTileExpanded extends HistoryExpansionTileState {
  final bool isExpanded;
  HistoryTileExpanded(this.isExpanded);
}

// Bloc
class HistoryExpansionTileBloc
    extends Bloc<HistoryExpansionTileEvent, HistoryExpansionTileState> {
  HistoryExpansionTileBloc() : super(HistoryTileExpanded(false)) {
    on<ToggleExpansionEvent>((event, emit) {
      final currentState = state as HistoryTileExpanded;
      emit(HistoryTileExpanded(!currentState.isExpanded));
    });
  }
}
