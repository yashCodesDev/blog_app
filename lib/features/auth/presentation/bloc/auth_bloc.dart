import 'dart:async';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp; // Private variable
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    //Constructor of AuthBloc takes a required parameter userSignUp of type UserSignUp.
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _appUserCubit =
            appUserCubit, //  and initializes the private _userSignUp variable with the provided value.
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);

    on<AuthSignIn>(_onAuthSignIn);

    on<AuthIsUserLoggedIn>(_onAuthUserLoggedIn);
  }
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignIn(
      UserSignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _currentUser(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
