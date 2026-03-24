enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? userName;
  final String? unit;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userName,
    this.unit,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userName,
    String? unit,
  }) {
    return AuthState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      unit: unit ?? this.unit,
    );
  }
}