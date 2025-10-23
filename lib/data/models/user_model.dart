import 'package:technical_test_project/domain/entities/user.dart';
import 'address_model.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.lastname,
    required super.addresses,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        lastname: json['lastname'],
        email: json['email'],
        addresses: (json['addresses'] as List<dynamic>? ?? [])
            .map((e) => AddressModel.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lastname': lastname,
        'email': email,
        'addresses': addresses
            .map(
              (e) => (e is AddressModel)
                  ? e.toJson()
                  : AddressModel.fromEntity(e).toJson(),
            )
            .toList(),
      };

  factory UserModel.fromEntity(User entity) => UserModel(
        id: entity.id,
        name: entity.name,
        lastname: entity.lastname,
        email: entity.email,
        addresses:
            entity.addresses.map((a) => AddressModel.fromEntity(a)).toList(),
      );

  User toEntity() => User(
        id: id,
        name: name,
        lastname: lastname,
        email: email,
        addresses: addresses
            .map((a) => (a is AddressModel) ? a.toEntity() : a)
            .toList(),
      );
}
