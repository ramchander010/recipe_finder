import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth_event.bloc.dart';
import 'package:recipe_app/data/viewmodels/auth_bloc.dart/auth_state.bloc.dart';
import '../../../core/storage/app_keys.dart';
import '../../../core/storage/app_prefs.dart';
 

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<CheckUser>(_onCheckUser);
    on<SaveUser>(_onSaveUser);
    on<Logout>(_onLogout);
  }

  /// 🔍 Check if user already exists
  Future<void> _onCheckUser(
      CheckUser event, Emitter<AuthState> emit) async {

    final name = await AppPrefs.getString(AppKeys.userName);
    final unit = await AppPrefs.getString(AppKeys.userUnit);

    if (name != null && name.isNotEmpty) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        userName: name,
        unit: unit,
      ));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  /// 💾 Save user
  Future<void> _onSaveUser(
      SaveUser event, Emitter<AuthState> emit) async {

    await AppPrefs.setString(AppKeys.userName, event.name);
    await AppPrefs.setString(AppKeys.userUnit, event.unit);

    emit(state.copyWith(
      status: AuthStatus.authenticated,
      userName: event.name,
      unit: event.unit,
    ));
  }

  /// 🚪 Logout
  Future<void> _onLogout(
      Logout event, Emitter<AuthState> emit) async {

    await AppPrefs.clearAll();

    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}