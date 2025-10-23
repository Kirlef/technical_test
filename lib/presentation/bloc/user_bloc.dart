import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_test_project/domain/usecases/usecases.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsers getUsers;
  final GetUserById getUserById;
  final AddUser addUser;
  final UpdateUser updateUser;
  final DeleteUser deleteUser;

  UserBloc({
    required this.getUsers,
    required this.getUserById,
    required this.addUser,
    required this.updateUser,
    required this.deleteUser,
  }) : super(UserInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<GetUserByIdEvent>(_onGetUserById);
    on<AddUserEvent>(_onAddUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onLoadUsers(
    LoadUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final users = await getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Error al cargar usuarios'));
    }
  }

  Future<void> _onGetUserById(
    GetUserByIdEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final user = await getUserById(event.id);
      if (user != null) {
        emit(UserDetailLoaded(user));
      } else {
        emit(UserError('Usuario no encontrado'));
      }
    } catch (e) {
      emit(UserError('Error al obtener usuario'));
    }
  }

  Future<void> _onAddUser(AddUserEvent event, Emitter<UserState> emit) async {
    try {
      await addUser(event.user);
      // Recargar la lista inmediatamente después de agregar
     final users = await getUsers();
      emit(UserLoaded(users)); 
    } catch (e) {
      emit(UserError('Error al agregar usuario'));
    }
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      await updateUser(event.user);

      final users = await getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Error al actualizar usuario'));
    }
  }

  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      await deleteUser(event.userId);
      // Recargar la lista inmediatamente después de eliminar
      final users = await getUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError('Error al eliminar usuario'));
    }
  }
}
