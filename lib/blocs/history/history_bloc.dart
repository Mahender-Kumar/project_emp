
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/blocs/history/history_event.dart';
import 'package:project_emp/blocs/history/history_state.dart';
import 'package:project_emp/presentation/services/firestore_service.dart'; 

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final FirestoreService _firestoreService;

  HistoryBloc(this._firestoreService) : super(HistoryInitial()) {
    on<FetchHistoryEvent>(_onFetchHistory);
  }

  Future<void> _onFetchHistory(
    FetchHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());

    try {
      await emit.forEach(
        _firestoreService.fetchHistory(event.selectedDate), // ✅ Await Stream
        onData: (historyItems) => HistoryLoaded(historyItems),
        onError: (error, stackTrace) => HistoryError(error.toString()),
      );
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
