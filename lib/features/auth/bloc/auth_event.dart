abstract class AuthEvent {}

class GoogleLogin extends AuthEvent {}

class FacebookLogin extends AuthEvent {}

class Logout extends AuthEvent {}

class EmailLogin extends AuthEvent {
  final String email;
  final String password;

  EmailLogin({required this.email, required this.password});
}

class Signup extends AuthEvent {
  final String name;
  final String email;
  final String password;

  Signup({required this.name, required this.email, required this.password});
}

class ForgotPassword extends AuthEvent {
  final String email;

  ForgotPassword({required this.email});
}
