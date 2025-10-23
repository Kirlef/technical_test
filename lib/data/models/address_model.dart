import 'package:technical_test_project/domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.id,
    required super.country,
    required super.state,
    required super.city,
    required super.street,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'],
        country: json['country'] ?? '',
        state: json['state'] ?? '',
        city: json['city'] ?? '',
        street: json['street'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'country': country,
        'state': state,
        'city': city,
        'street': street,
      };

  factory AddressModel.fromEntity(Address entity) => AddressModel(
        id: entity.id,
        country: entity.country,
        state: entity.state,
        city: entity.city,
        street: entity.street,
      );

  Address toEntity() => Address(
        id: id,
        country: country,
        state: state,
        city: city,
        street: street,
      );

  AddressModel copyWith({
    int? id,
    String? country,
    String? state,
    String? city,
    String? street,
  }) {
    return AddressModel(
      id: id ?? this.id,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      street: street ?? this.street,
    );
  }
}
