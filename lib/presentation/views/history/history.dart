import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/blocs/history/history_bloc.dart';
import 'package:project_emp/blocs/history/history_event.dart';
import 'package:project_emp/blocs/history/history_state.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/data/models/todo_model.dart';
import 'package:project_emp/extensions/time_extensions.dart';
import 'package:project_emp/presentation/widgets/priority_badge.dart';
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
                        return TodoExpansionTile(todo: historyTodo);
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

class TodoExpansionTile extends StatelessWidget {
  final Employee todo;
  final Widget? trailingIcon;
  final Widget? leadingIcon;
  const TodoExpansionTile({
    super.key,
    required this.todo,
    this.trailingIcon,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryExpansionTileBloc(),
      child: BlocBuilder<HistoryExpansionTileBloc, HistoryExpansionTileState>(
        builder: (context, state) {
          final isExpanded = (state as HistoryTileExpanded).isExpanded;
          return Card(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            elevation: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  onTap: () {
                    context.read<HistoryExpansionTileBloc>().add(
                      ToggleExpansionEvent(),
                    );
                  },
                  leading:
                      leadingIcon ??
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(btnRadius / 2),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 18,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        todo.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: defaultGapping / 2),
                      // PriorityBadge(status: todo.priority),
                    ],
                  ),
                  trailing: SafeArea(
                    child: Row(
                      // alignment: WrapAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: trailingIcon ?? const SizedBox.shrink(),
                        ),
                        // SizedBox(width: defaultGapping / 2),
                        Flexible(
                          child: AnimatedRotation(
                            turns:
                                isExpanded
                                    ? 0.5
                                    : 0.0, // Rotates 180° when expanded
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Icon(
                              Icons.expand_more,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child:
                        isExpanded
                            ? const SizedBox.shrink()
                            : Text(
                              todo.name,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                  ),
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 200),
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(todo.name, style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 6),
                        Text(
                          "Due: ${todo.department}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        Text(
                          "Done At: ${todo.phone}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                  crossFadeState:
                      isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                ),
              ],
            ),
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
