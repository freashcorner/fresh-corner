class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final double? discountPrice;
  final String unit;
  final int stock;
  final String categoryId;
  final String imageUrl;
  final String imagePublicId;
  final bool isActive;
  final bool isFeatured;

  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.discountPrice,
    required this.unit,
    required this.stock,
    required this.categoryId,
    required this.imageUrl,
    required this.imagePublicId,
    this.isActive = true,
    this.isFeatured = false,
  });

  double get effectivePrice => discountPrice ?? price;

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'],
      price: (map['price'] ?? 0).toDouble(),
      discountPrice: map['discountPrice']?.toDouble(),
      unit: map['unit'] ?? 'piece',
      stock: map['stock'] ?? 0,
      categoryId: map['categoryId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      imagePublicId: map['imagePublicId'] ?? '',
      isActive: map['isActive'] ?? true,
      isFeatured: map['isFeatured'] ?? false,
    );
  }
}
