import 'package:firebase_auth/firebase_auth.dart';
import 'package:nana/features/auth/bloc/auth_event.dart';
import 'package:nana/features/auth/bloc/auth_state.dart';
import 'package:nana/features/auth/repositories/auth_repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositories repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<GoogleLogin>((event, emit) async {
      try {
        emit(AuthLoading());
        await repository.googleLogin();
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError("Google Login failed"));
        }
      } catch (e) {
        print('google login error: $e');

        emit(AuthError(e.toString()));
      }
    });
    on<FacebookLogin>((event, emit) async {
      emit(AuthLoading());

      try {
        await repository.facebookLogin();
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError('Facebook login failed'));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<Logout>((event, emit) async {
      try {
        emit(AuthLoading());
        await repository.logout();
        emit(AuthLogout());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<EmailLogin>((event, emit) async {
      emit(AuthLoading());

      try {
        final response = await repository.signIn(event.email, event.password);

        emit(AuthAuthenticated(response.user!));
      } on FirebaseAuthException catch (e) {
        String message = 'Login failed';

        if (e.code == 'user-not-found') {
          message = 'No user found';
        } else if (e.code == 'wrong-password') {
          message = 'Incorrect password';
        } else if (e.code == 'invalid-credential') {
          message = 'Incorrect email and password';
        } else if (e.code == 'invalid-email') {
          message = 'Incorrect email';
        }

        emit(AuthError(message));
      } catch (e) {
        emit(AuthError('Something went wrong'));
      }
    });
    on<Signup>((event, emit) async {
      emit(AuthLoading());

      try {
        final response = await repository.signUp(
          event.name,
          event.email,
          event.password,
        );

        if (response.user != null) {
          emit(AuthAuthenticated(response.user!));
        } else {
          emit(AuthError('Account creation failed'));
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Account creation failed';

        if (e.code == 'email-already-in-use') {
          message = 'This email is already registered';
        } else if (e.code == 'invalid-email') {
          message = 'Please enter a valid email';
        } else if (e.code == 'weak-password') {
          message = 'Password is too weak';
        } else if (e.code == 'operation-not-allowed') {
          message = 'Email/password login is not enabled';
        }

        emit(AuthError(message));
      } catch (e) {
        print('SIGNUP ERROR: $e');
        emit(AuthError('Something went wrong'));
      }
    });
    on<ForgotPassword>((event, emit) async {
      emit(ForgotPasswordLoading());

      try {
        await repository.forget(event.email);

        emit(ForgotPasswordSuccess());
      } on FirebaseAuthException catch (e) {
        String message = 'Password reset failed';

        if (e.code == 'invalid-email') {
          message = 'Please enter a valid email';
        } else if (e.code == 'user-not-found') {
          message = 'No account found with this email';
        } else if (e.code == 'network-request-failed') {
          message = 'Please check your internet connection';
        }

        emit(ForgotPasswordError(message));
      } catch (e) {
        emit(ForgotPasswordError('Something went wrong. Please try again.'));
      }
    });
  }
}
