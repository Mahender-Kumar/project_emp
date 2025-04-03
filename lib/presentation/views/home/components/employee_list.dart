import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/data/models/employee_model.dart';
import 'package:project_emp/emploee_bloc.dart';
import 'package:project_emp/presentation/services/firestore_service.dart';
import 'package:project_emp/presentation/views/history/history.dart';
import 'package:project_emp/presentation/widgets/todo_widget.dart';

class ExployeeListview extends StatelessWidget {
  final FirestoreService _firestoreService;

  ExployeeListview({super.key}) : _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        children: [
          BlocBuilder<EmployeeBloc, EmployeeState>(
            builder: (context, state) {
              if (state is EmployeeLoading) {
                return const Center(child: LinearProgressIndicator());
              } else if (state is EmployeeFailure) {
                return Center(child: Text("Error: ${state.error}"));
              } else if (state is EmployeeSuccess) {
                if (state.employees.isEmpty) {
                  return const Center(child: Text("No employee records found"));
                }

                final currentEmployees =
                    state.employees.where((e) => e.isCurrent).toList();
                final previousEmployees =
                    state.employees.where((e) => !e.isCurrent).toList();
                return Column(
                  children: [
                    ExpansionTile(
                      dense: true,
                      initiallyExpanded: true,
                      title: ListTile(
                        dense: true,
                        title: const Text('Current Employees'),
                        // trailing: IconButton(icon: const Icon(Icons.history)),
                      ),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: currentEmployees.length,
                          itemBuilder: (context, index) {
                            final employee = currentEmployees[index];
                            return EmployeeTile(employee: employee);
                          },
                        ),
                      ],
                    ),

                    ExpansionTile(
                      dense: true,
                      initiallyExpanded: true,
                      title: ListTile(
                        dense: true,
                        title: const Text('Previous Employees'),
                        // trailing: IconButton(icon: const Icon(Icons.history)),
                      ),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: previousEmployees.length,
                          itemBuilder: (context, index) {
                            final employee = previousEmployees[index];
                            return EmployeeTile(employee: employee);
                          },
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return const Center(child: Text("No data available"));
              }
            },
          ),
        ],
      ),
    );
  }
}
