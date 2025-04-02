import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/blocs/auth/auth_event.dart';
import 'package:project_emp/blocs/auth/auth_state.dart';
import 'package:project_emp/presentation/services/auth_service.dart'; 

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading()); // 🔄 Show loading state

    try {
      final user = await authService.login(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess()); // ✅ Successful login
      } else {
        emit(AuthFailure(error: "Invalid credentials")); // ❌ Failed login
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
