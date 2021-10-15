part of 'auth_cubit.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class UserNotLoggedState extends AuthState {
  @override
  List<Object?> get props => [];
}

class UserLogedState extends AuthState {
  final User user;

  UserLogedState(this.user);
  @override
  List<Object?> get props => [user];
}
