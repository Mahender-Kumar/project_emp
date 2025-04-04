import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/blocs/employee/employee_state.dart';
import 'package:project_emp/blocs/employee/fetch_emploee_bloc.dart';
import 'package:project_emp/presentation/widgets/employee_tile.dart';

class ExployeeListview extends StatelessWidget {
  const ExployeeListview({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: ListView(
        // mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<FetchEmployeeBloc, EmployeeState>(
            builder: (context, state) {
              if (state is EmployeeLoading) {
                return const Center(child: LinearProgressIndicator());
              } else if (state is EmployeeFailure) {
                return Center(child: Text("Error: ${state.error}"));
              } else if (state is EmployeeSuccess) {
                if (state.employees.isEmpty) {
                  return Flexible(
                    child: Center(child: Text("No employee records found")),
                  );
                }

                final currentEmployees =
                    state.employees.where((e) => e.isCurrent).toList();
                final previousEmployees =
                    state.employees.where((e) => !e.isCurrent).toList();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          ListTile(
                            tileColor:
                                Theme.of(context).colorScheme.surfaceContainer,
                            dense: true,
                            title: const Text('Current Employees'),
                          ),

                          ListView.builder(
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: currentEmployees.length,
                            itemBuilder: (context, index) {
                              final employee = currentEmployees[index];
                              return EmployeeTile(
                                employee: employee,
                                isDismissible: true,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // ExpansionTile(
                    //   dense: true,
                    //   initiallyExpanded: true,
                    //   // tilePadding: EdgeInsets.all(0),
                    //   // minTileHeight: 42,
                    //   title: ListTile(
                    //     dense: true,
                    //     title: const Text('Current Employees'),
                    //   ),
                    //   children: [
                    //     ListView.builder(
                    //       shrinkWrap: true,
                    //       physics: const NeverScrollableScrollPhysics(),
                    //       itemCount: currentEmployees.length,
                    //       itemBuilder: (context, index) {
                    //         final employee = currentEmployees[index];
                    //         return EmployeeTile(
                    //           employee: employee,
                    //           isDismissible: true,
                    //         );
                    //       },
                    //     ),
                    //   ],
                    // ),
                    Flexible(
                      child: Column(
                        children: [
                          ListTile(
                            dense: true,
                            tileColor:
                                Theme.of(context).colorScheme.surfaceContainer,
                            title: const Text('Previous Employees'),
                          ),
                          ListView.builder(
                            padding: const EdgeInsets.all(0),
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
                    ),
                    // ExpansionTile(
                    //   dense: true,
                    //   initiallyExpanded: true,
                    //   title: ListTile(
                    //     dense: true,
                    //     title: const Text('Previous Employees'),
                    //     // trailing: IconButton(icon: const Icon(Icons.history)),
                    //   ),
                    //   children: [
                    //     ListView.builder(
                    //       shrinkWrap: true,
                    //       physics: const NeverScrollableScrollPhysics(),
                    //       itemCount: previousEmployees.length,
                    //       itemBuilder: (context, index) {
                    //         final employee = previousEmployees[index];
                    //         return EmployeeTile(employee: employee);
                    //       },
                    //     ),
                    //   ],
                    // ),
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
