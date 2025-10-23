import 'package:flutter/material.dart';
import 'package:technical_test_project/presentation/foundations/foundations.dart';

class AddressTile extends StatelessWidget {
  final String address;
  final String city;
  final VoidCallback? onTap;

  const AddressTile({
    super.key,
    required this.address,
    required this.city,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      tileColor: Theme.of(context).colorScheme.surface,
      title: Text(address, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(city, style: Theme.of(context).textTheme.bodyMedium),
      onTap: onTap,
    );
  }
}
