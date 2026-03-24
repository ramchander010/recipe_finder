abstract class AuthEvent {}

class CheckUser extends AuthEvent {}

class SaveUser extends AuthEvent {
  final String name;
  final String unit;

  SaveUser({required this.name, required this.unit});
}

class Logout extends AuthEvent {}