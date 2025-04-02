import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<String> {
  SearchCubit() : super('');

  void updateSearch(String query) => emit(query);
  void clearSearch() => emit('');
}