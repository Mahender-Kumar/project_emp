import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/data/models/employee_model.dart';
import 'package:project_emp/presentation/services/firestore_service.dart';
import 'package:project_emp/presentation/widgets/employee_tile.dart';
import 'package:project_emp/presentation/views/search/components/search_field.dart';
import 'package:project_emp/cubit/search/search_cubit.dart';

class SearchPage extends StatelessWidget {
  final FirestoreService firestoreService;
  SearchPage({super.key}) : firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: BlocProvider(
          create: (context) => SearchCubit(),
          child: Column(
            children: [
              SearchField(),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<SearchCubit, String>(
                  builder: (context, searchQuery) {
                    return StreamBuilder<List<Map<String, dynamic>>>(
                      stream: firestoreService.searchEmployee(searchQuery),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No results found'));
                        }

                        var items = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            Employee employee = Employee.fromMap(items[index]);
                            return EmployeeTile(
                              employee: employee,
                              showTrailingIcon: false,
                              isDismissible: false,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
