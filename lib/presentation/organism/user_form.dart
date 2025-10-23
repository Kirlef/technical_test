import 'package:flutter/material.dart';
import 'package:technical_test_project/presentation/atoms/atoms.dart';
import 'package:technical_test_project/presentation/foundations/foundations.dart';
import 'package:technical_test_project/domain/entities/address.dart';
import 'package:technical_test_project/presentation/organism/address_picker.dart';

class UserForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController birthDateController;
  final List<Address> addresses;
  final List<TextEditingController> streetControllers;
  final void Function() onAddAddress;
  final void Function(int index) onRemoveAddress;
  final void Function() onSubmit;

  const UserForm({
    super.key,
    required this.nameController,
    required this.lastNameController,
    required this.emailController,
    required this.birthDateController,
    required this.addresses,
    required this.streetControllers,
    required this.onAddAddress,
    required this.onRemoveAddress,
    required this.onSubmit,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText('Nombre'),
          AppTextField(
            controller: widget.nameController,
            hint: 'Juan',
            validator: (v) =>
                v == null || v.isEmpty ? 'Campo obligatorio' : null,
          ),
          const SizedBox(height: AppSpacing.md),
          const AppText('Apellido'),
          AppTextField(
            controller: widget.lastNameController,
            hint: 'Pérez',
            validator: (v) =>
                v == null || v.isEmpty ? 'Campo obligatorio' : null,
          ),
          const SizedBox(height: AppSpacing.md),
          const AppText('Correo electrónico'),
          AppTextField(
            controller: widget.emailController,
            hint: 'ejemplo@correo.com',
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'Campo obligatorio';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(v)) {
                return 'Ingresa un correo válido';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          const AppText('Fecha de nacimiento'),
          AppTextField(
            controller: widget.birthDateController,
            hint: 'dd/mm/yyyy',
            label: 'Fecha de nacimiento',
            readOnly: true,
            onTap: () async {
              // Si ya tiene una fecha previa, la usamos como inicial
              DateTime initialDate = DateTime(1995, 1, 1);

              if (widget.birthDateController.text.isNotEmpty) {
                try {
                  final parts = widget.birthDateController.text.split('/');
                  if (parts.length == 3) {
                    final day = int.parse(parts[0]);
                    final month = int.parse(parts[1]);
                    final year = int.parse(parts[2]);
                    initialDate = DateTime(year, month, day);
                  }
                } catch (_) {
                  // Si falla el parseo, mantenemos la fecha por defecto
                }
              }

              final picked = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (picked != null) {
                widget.birthDateController.text =
                    '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
              }
            },
            validator: (v) =>
                v == null || v.isEmpty ? 'Campo obligatorio' : null,
          ),

          const SizedBox(height: AppSpacing.lg),
          const AppText('Direcciones'),
          const SizedBox(height: AppSpacing.sm),
          if (widget.addresses.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Text(
                'No hay direcciones agregadas. Presiona "Agregar dirección" para añadir una.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ..._buildAddressCards(),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Agregar dirección',
                  onPressed: widget.onAddAddress,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Guardar',
                  onPressed: widget.onSubmit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Dentro de _buildAddressCards()
  List<Widget> _buildAddressCards() {
    return widget.addresses.asMap().entries.map((entry) {
      final index = entry.key;
      final address = entry.value;

      // Para pruebas, podemos inicializar los valores si son nulos
      final country = address.country ?? 'Colombia';
      final state = address.state ?? 'Cundinamarca';
      final city = address.city ?? 'Bogotá';

      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Dirección ${index + 1}', style: AppTypography.h1),
                    IconButton(
                      onPressed: () => widget.onRemoveAddress(index),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Eliminar dirección',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                SelectStatePicker(
                  key: Key('select_state_picker_$index'),
                  initialCountry: country,
                  initialState: state,
                  initialCity: city,
                  onCountryChanged: (value) {
                    setState(() {
                      final current = widget.addresses[index];
                      widget.addresses[index] = Address(
                        id: current.id,
                        country: value,
                        state: current.state,
                        city: current.city,
                        street: current.street,
                      );
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      final current = widget.addresses[index];
                      widget.addresses[index] = Address(
                        id: current.id,
                        country: current.country,
                        state: value,
                        city: current.city,
                        street: current.street,
                      );
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      final current = widget.addresses[index];
                      widget.addresses[index] = Address(
                        id: current.id,
                        country: current.country,
                        state: current.state,
                        city: value,
                        street: current.street,
                      );
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  key: Key('street_field_$index'),
                  controller: widget.streetControllers[index],
                  hint: 'Ej: Calle 123 #45-67',
                  onTap: null,
                  readOnly: false,
                  validator: (_) => null,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

}
