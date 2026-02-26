class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int qty;
  final String unit;
  final String imageUrl;
  final double subtotal;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.qty,
    required this.unit,
    required this.imageUrl,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'name': name,
    'price': price,
    'qty': qty,
    'unit': unit,
    'imageUrl': imageUrl,
    'subtotal': subtotal,
  };

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      qty: map['qty'] ?? 1,
      unit: map['unit'] ?? 'piece',
      imageUrl: map['imageUrl'] ?? '',
      subtotal: (map['subtotal'] ?? 0).toDouble(),
    );
  }
}

class Order {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final List<OrderItem> items;
  final double totalAmount;
  final double deliveryCharge;
  final double grandTotal;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.items,
    required this.totalAmount,
    required this.deliveryCharge,
    required this.grandTotal,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhone: map['userPhone'] ?? '',
      items: (map['items'] as List?)?.map((i) => OrderItem.fromMap(i)).toList() ?? [],
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      deliveryCharge: (map['deliveryCharge'] ?? 0).toDouble(),
      grandTotal: (map['grandTotal'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      paymentMethod: map['paymentMethod'] ?? 'cod',
      paymentStatus: map['paymentStatus'] ?? 'unpaid',
      createdAt: (map['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }
}
