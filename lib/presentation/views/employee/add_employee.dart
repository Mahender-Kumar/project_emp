import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/blocs/employee/add_employee_bloc.dart';
import 'package:project_emp/blocs/employee/add_employee_event.dart';
import 'package:project_emp/blocs/employee/add_employee_state.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/data/models/employee_model.dart';
import 'package:project_emp/extensions/time_extensions.dart';
import 'package:project_emp/presentation/widgets/date_picker.dart';
import 'package:project_emp/presentation/widgets/expanded_btn.dart';
import 'package:project_emp/presentation/widgets/role_sheet.dart';
import 'package:uuid/uuid.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();

  late Employee employee;

  @override
  void initState() {
    employee = Employee(
      id: const Uuid().v4(),
      name: '',
      position: '',
      department: '',
      email: '',
      phone: '',
      salary: 0.0,
      hireDate: DateTime.now(),
      location: '',
      isCurrent: true,
    );
    super.initState();
  }

  void _addEmployee(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<AddEmployeeBloc>().add(AddEmployeeEvent(employee));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Employee Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: BlocListener<AddEmployeeBloc, EmployeeState>(
            listener: (context, state) {
              // print(' state: $state');
              if (state is EmployeeSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Todo Added Successfully")),
                );
                _formKey.currentState!.reset(); // Reset the form

                employee = Employee(
                  id: const Uuid().v4(),

                  name: '',
                  position: '',
                  department: '',
                  email: '',
                  phone: '',
                  salary: 0.0,
                  hireDate: DateTime.now(),
                  location: '',
                  isCurrent: true,
                ); // Reset the todo object
                // Close screen on success
              } else if (state is EmployeeFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${state.error}")),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Employee Name",
                    isDense: true,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_2_outlined),
                  ),
                  validator:
                      (value) => value!.isEmpty ? "Please enter name" : null,
                  onChanged: (value) => employee.name = value,
                ),
                const SizedBox(height: defaultGapping),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'Select Role',
                    isDense: true,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work_outline),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  onTap: () {
                    JobSelectionBottomSheet.showJobSelectionSheet(
                      context: context,
                      onJobSelected: (job) {
                        employee.position = job;
                      },
                    );
                  },
                  // validator:
                  //     (value) => value!.isEmpty ? "Please enter role" : null,
                  onChanged: (value) => employee.position = value,
                ),
                const SizedBox(height: defaultGapping),

                Row(
                  children: [
                    Flexible(
                      child: DatePicker(
                        validate: true,
                        showMondayButton: true,
                        showTuesdayButton: true,
                        showTodayButton: true,
                        showOneweekAfterButton: true,
                        controller: TextEditingController(
                          text: employee.hireDate.toString(),
                        ),
                        onDateTimeSelected: (dateSelected) {
                          employee.hireDate = dateSelected;
                        },
                      ),
                    ),
                    const SizedBox(width: defaultGapping),
                    Icon(Icons.arrow_forward_rounded, size: btnFontSize * 1.5),
                    const SizedBox(width: defaultGapping),

                    Flexible(
                      child: DatePicker(
                        showNoDateButton: true,
                        showTodayButton: true,
                        controller: TextEditingController(
                          text: employee.leavingDate.toString(),
                        ),
                        onDateTimeSelected: (dateSelected) {
                          // todo.dueDate = Timestamp.fromDate(dateSelected);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: defaultGapping),

                BlocBuilder<AddEmployeeBloc, EmployeeState>(
                  builder: (context, state) {
                    return ExpandedBtn(
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(btnRadius),
                        ),
                      ),
                      onPressed:
                          state is EmployeeLoading
                              ? null
                              : () => _addEmployee(context),
                      child:
                          state is EmployeeLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text("Save"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
