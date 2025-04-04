import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:project_emp/blocs/date_picker/date_select_event.dart';
import 'package:project_emp/blocs/date_picker/date_select_state.dart';
import 'package:project_emp/blocs/employee/add_employee_bloc.dart';
import 'package:project_emp/blocs/employee/employee_event.dart';
import 'package:project_emp/blocs/employee/employee_state.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/cubit/job/job_cubit.dart';
import 'package:project_emp/data/models/employee_model.dart';
import 'package:project_emp/data/models/jobs_model.dart';
import 'package:project_emp/blocs/date_picker/date_select_bloc.dart';
import 'package:project_emp/presentation/widgets/date_picker.dart';
import 'package:project_emp/presentation/widgets/role_sheet.dart';
import 'package:uuid/uuid.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
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

    final datesState = context.read<EmployeeDatesBloc>().state;
    employee.hireDate = datesState.hireDate;
    employee.leavingDate = datesState.leavingDate;

    context.read<AddEmployeeBloc>().add(AddEmployeeEvent(employee));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => EmployeeDatesBloc(
            initialHireDate: employee.hireDate,
            initialLeavingDate: employee.leavingDate,
          ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Employee Details')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: BlocListener<AddEmployeeBloc, EmployeeState>(
              listener: (context, state) {
                // print(' state: $state');
                if (state is EmployeeSuccess) {
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
                  ); // Reset the Employee object

                  context.read<EmployeeDatesBloc>().add(
                    HireDateChanged(DateTime.now()),
                  );
                  context.read<EmployeeDatesBloc>().add(
                    LeavingDateChanged(null),
                  );
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
                  Flexible(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Employee Name",
                            isDense: true,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_2_outlined),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty ? "Please enter name" : null,
                          onChanged: (value) => employee.name = value,
                        ),
                        const SizedBox(height: defaultGapping),
                        BlocListener<JobCubit, Job?>(
                          listener: (context, state) {
                            employee.position = state!.id;
                          },
                          child: TextFormField(
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
                              );
                            },
                            controller: TextEditingController(
                              text:
                                  context.watch<JobCubit>().state?.title ??
                                  'Select Role',
                            ),
                            validator: (value) {
                              return (value!.isEmpty || value == 'Select Role')
                                  ? "Please enter role"
                                  : null;
                            },
                            onChanged: (value) => employee.position = value,
                          ),
                        ),
                        const SizedBox(height: defaultGapping),

                        BlocBuilder<EmployeeDatesBloc, EmployeeDatesState>(
                          builder: (context, datesState) {
                            return Row(
                              children: [
                                Flexible(
                                  child: DatePicker(
                                    key: ValueKey(datesState.hireDate),
                                    validate: true,
                                    showMondayButton: true,
                                    showTuesdayButton: true,
                                    showTodayButton: true,
                                    showOneweekAfterButton: true,
                                    initialDate: datesState.hireDate,
                                    maxDate: datesState.leavingDate,
                                    controller: TextEditingController(
                                      text: DateFormat.yMMMd(
                                        'en_US',
                                      ).format(datesState.hireDate),
                                    ),
                                    onDateTimeSelected: (dateSelected) {
                                      context.read<EmployeeDatesBloc>().add(
                                        HireDateChanged(dateSelected!),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: defaultGapping),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: btnFontSize * 1.5,
                                ),
                                const SizedBox(width: defaultGapping),

                                Flexible(
                                  child: DatePicker(
                                    showNoDateButton: true,
                                    showTodayButton: true,
                                    minDate: datesState.hireDate,
                                    initialDate:
                                        (datesState.leavingDate != null &&
                                                datesState.leavingDate!.isAfter(
                                                  datesState.hireDate,
                                                ))
                                            ? datesState.leavingDate
                                            : null,
                                    controller: TextEditingController(
                                      text:
                                          datesState.leavingDate != null
                                              ? DateFormat.yMMMd(
                                                'en_US',
                                              ).format(datesState.leavingDate!)
                                              : 'No Date',
                                    ),
                                    onDateTimeSelected: (dateSelected) {
                                      // print(dateSelected);
                                      // employee.leavingDate = dateSelected;
                                      context.read<EmployeeDatesBloc>().add(
                                        LeavingDateChanged(dateSelected),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: defaultGapping),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(btnRadius),
                          ),
                        ),
                        onPressed: () {
                          context.pop(); // Close the screen
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.titleSmall?.color,
                          ),
                        ),
                      ),
                      SizedBox(width: defaultGapping),
                      BlocConsumer<AddEmployeeBloc, EmployeeState>(
                        listener: (context, state) {
                          if (state is EmployeeSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Employee added successfully"),
                              ),
                            );
                            Navigator.pop(context); // Pop the screen on success
                          } else if (state is EmployeeFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error)),
                            );
                          }
                        },
                        builder: (context, state) {
                          return FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
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
                                    : state is EmployeeSuccess
                                    ? const Text("Saved")
                                    : const Text("Save"),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
