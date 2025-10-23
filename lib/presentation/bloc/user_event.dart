import 'package:equatable/equatable.dart';
import 'package:technical_test_project/domain/entities/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsersEvent extends UserEvent {}

class AddUserEvent extends UserEvent {
  final User user;
  const AddUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateUserEvent extends UserEvent {
  final User user;
  const UpdateUserEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class DeleteUserEvent extends UserEvent {
  final int userId;
  const DeleteUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetUserByIdEvent extends UserEvent {
  final int id;
  const GetUserByIdEvent(this.id);
}
