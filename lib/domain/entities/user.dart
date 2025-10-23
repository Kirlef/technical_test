import 'address.dart';

class User {
  final int id;
  final String name;
  final String lastname;
  final String email;
  final String? birthDate;
  final List<Address> addresses;

  const User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    this.birthDate,
    this.addresses = const [],
  });
}
