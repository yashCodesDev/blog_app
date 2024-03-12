import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp; // Private variable

  AuthBloc({
    required UserSignUp
        userSignUp, //Constructor of AuthBloc takes a required parameter userSignUp of type UserSignUp.
  })  : _userSignUp =
            userSignUp, //  and initializes the private _userSignUp variable with the provided value.
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      final res = await _userSignUp(
        UserSignUpParams(
            email: event.email, password: event.password, name: event.name),
      );
      res.fold((l) => emit(AuthFailure(l.message)),
          (user) => emit(AuthSuccess(user)));
    });
  }
}
