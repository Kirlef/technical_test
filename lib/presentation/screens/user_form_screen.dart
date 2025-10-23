// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:technical_test_project/domain/entities/address.dart';
import 'package:technical_test_project/domain/entities/user.dart';
import 'package:technical_test_project/presentation/atoms/atoms.dart';
import 'package:technical_test_project/presentation/bloc/user_bloc.dart';
import 'package:technical_test_project/presentation/bloc/user_event.dart';
import 'package:technical_test_project/presentation/bloc/user_state.dart';
import 'package:technical_test_project/presentation/organism/organism.dart';

class UserFormScreen extends StatefulWidget {
  final bool isEditing;
  final User? user;

  const UserFormScreen({
    super.key,
    this.isEditing = false,
    this.user,
  });

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();

  List<Address> _addresses = [];
  List<TextEditingController> _streetControllers = [];

  final _formKey = GlobalKey<FormState>();

  User? _currentUser;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Si se pasa un usuario directamente, inicializar inmediatamente
    if (widget.user != null) {
      _initializeForm(widget.user!);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _birthDateCtrl.dispose();
    for (var ctrl in _streetControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _initializeForm(User user) {
    if (_isInitialized) return;

    _currentUser = user;
    _nameCtrl.text = user.name;
    _lastNameCtrl.text = user.lastname;
    _emailCtrl.text = user.email;
    _birthDateCtrl.text = user.birthDate ?? '';

    _addresses = user.addresses.map((a) => a).toList();
    _streetControllers =
        _addresses.map((a) => TextEditingController(text: a.street)).toList();

    _isInitialized = true;
    // ✅ Importante: setState para actualizar la UI
    if (mounted) {
      setState(() {});
    }
  }

  void _addAddress() {
    setState(() {
      _addresses.add(const Address(
        id: 0,
        country: '',
        state: '',
        city: '',
        street: '',
      ));
      _streetControllers.add(TextEditingController());
    });
  }

  void _removeAddress(int index) {
    setState(() {
      _streetControllers[index].dispose();
      _streetControllers.removeAt(index);
      _addresses.removeAt(index);
    });
  }

  void _save() {
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      AppSnackbar.show(context,
          message: 'Por favor completa todos los campos obligatorios',
          type: SnackbarType.error);

      return;
    }

    if (_addresses.isEmpty) {
      AppSnackbar.show(context,
          message: 'Debes agregar al menos una dirección',
          type: SnackbarType.error);

      return;
    }

    final updatedAddresses = _addresses.asMap().entries.map((entry) {
      final index = entry.key;
      final address = entry.value;
      return Address(
        id: address.id,
        country: address.country,
        state: address.state,
        city: address.city,
        street: _streetControllers[index].text.trim(),
      );
    }).toList();

    final user = User(
      id: _currentUser?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: _nameCtrl.text.trim(),
      lastname: _lastNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      birthDate: _birthDateCtrl.text.trim(),
      addresses: updatedAddresses,
    );

    final bloc = context.read<UserBloc>();
    if (widget.isEditing) {
      bloc.add(UpdateUserEvent(user));
    } else {
      bloc.add(AddUserEvent(user));
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      context.go('/users/${user.id}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        // Cuando se actualiza exitosamente, recargar el usuario
        if (state is UserLoaded && widget.isEditing && _currentUser != null) {
          // Recargar el detalle del usuario después de actualizar
          context.read<UserBloc>().add(GetUserByIdEvent(_currentUser!.id));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditing ? 'Editar usuario' : 'Nuevo usuario'),
        ),
        body: widget.isEditing && !_isInitialized
            ? BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  // Solo si estamos editando y NO se pasó usuario, intentar desde el bloc
                  if (widget.user == null && state is UserDetailLoaded) {
                    // Usar addPostFrameCallback para evitar setState durante build
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!_isInitialized) {
                        _initializeForm(state.user);
                      }
                    });
                  }

                  // Mostrar loading mientras se inicializa
                  return const Center(child: CircularProgressIndicator());
                },
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: UserForm(
                    nameController: _nameCtrl,
                    lastNameController: _lastNameCtrl,
                    emailController: _emailCtrl,
                    birthDateController: _birthDateCtrl,
                    addresses: _addresses,
                    streetControllers: _streetControllers,
                    onAddAddress: _addAddress,
                    onRemoveAddress: _removeAddress,
                    onSubmit: _save,
                  ),
                ),
              ),
      ),
    );
  }
}
