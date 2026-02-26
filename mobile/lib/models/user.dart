class UserAddress {
  final String label;
  final String street;
  final String area;
  final String city;
  final String phone;

  const UserAddress({
    required this.label,
    required this.street,
    required this.area,
    required this.city,
    required this.phone,
  });

  Map<String, dynamic> toMap() => {'label': label, 'street': street, 'area': area, 'city': city, 'phone': phone};

  factory UserAddress.fromMap(Map<String, dynamic> map) {
    return UserAddress(label: map['label'] ?? '', street: map['street'] ?? '', area: map['area'] ?? '', city: map['city'] ?? '', phone: map['phone'] ?? '');
  }
}

class AppUser {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final List<UserAddress> addresses;
  final String role;
  final bool isActive;
  final String? fcmToken;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.addresses,
    required this.role,
    required this.isActive,
    this.fcmToken,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      addresses: (map['addresses'] as List?)?.map((a) => UserAddress.fromMap(a)).toList() ?? [],
      role: map['role'] ?? 'customer',
      isActive: map['isActive'] ?? true,
      fcmToken: map['fcmToken'],
    );
  }
}
