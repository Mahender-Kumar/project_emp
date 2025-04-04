import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/data/models/jobs_model.dart';

class JobCubit extends Cubit<Job?> {
  JobCubit() : super(null);

  void selectJob(Job job) {
    emit(job);
  }
}