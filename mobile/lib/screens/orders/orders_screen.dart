import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/order.dart';
import '../../services/firebase_service.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const Map<String, String> _statusLabel = {
    'pending': 'অপেক্ষমান',
    'confirmed': 'নিশ্চিত',
    'processing': 'প্রস্তুত হচ্ছে',
    'shipped': 'পাঠানো হয়েছে',
    'delivered': 'পৌঁছেছে',
    'cancelled': 'বাতিল',
  };

  static const Map<String, Color> _statusColor = {
    'pending': Color(0xFFFF6B35),
    'confirmed': Color(0xFF3498DB),
    'processing': Color(0xFF9B59B6),
    'shipped': Color(0xFF00BCD4),
    'delivered': Color(0xFF2ECC71),
    'cancelled': Color(0xFFE74C3C),
  };

  static const Map<String, IconData> _statusIcon = {
    'pending': Icons.hourglass_empty,
    'confirmed': Icons.check_circle_outline,
    'processing': Icons.restaurant,
    'shipped': Icons.local_shipping_outlined,
    'delivered': Icons.check_circle,
    'cancelled': Icons.cancel_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().firebaseUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('📦', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 20),
                const Text('অর্ডার দেখতে লগইন করুন', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('আপনার সমস্ত অর্ডার একটি জায়গায়', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('লগইন করুন'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('আমার অর্ডার')),
      body: FutureBuilder(
        future: FirebaseService.getUserOrders(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('📦', style: TextStyle(fontSize: 56)),
                  SizedBox(height: 16),
                  Text('কোনো অর্ডার নেই', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('কেনাকাটা শুরু করুন!', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          final orders = docs.map((d) => Order.fromMap(d.data() as Map<String, dynamic>, d.id)).toList();
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
            itemCount: orders.length,
            itemBuilder: (_, i) => _OrderCard(order: orders[i]),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  static const Map<String, String> _statusLabel = {
    'pending': 'অপেক্ষমান',
    'confirmed': 'নিশ্চিত',
    'processing': 'প্রস্তুত হচ্ছে',
    'shipped': 'পাঠানো হয়েছে',
    'delivered': 'পৌঁছেছে',
    'cancelled': 'বাতিল',
  };
  static const Map<String, Color> _statusColor = {
    'pending': Color(0xFFFF6B35),
    'confirmed': Color(0xFF3498DB),
    'processing': Color(0xFF9B59B6),
    'shipped': Color(0xFF00BCD4),
    'delivered': Color(0xFF2ECC71),
    'cancelled': Color(0xFFE74C3C),
  };
  static const Map<String, IconData> _statusIcon = {
    'pending': Icons.hourglass_empty,
    'confirmed': Icons.check_circle_outline,
    'processing': Icons.restaurant,
    'shipped': Icons.local_shipping_outlined,
    'delivered': Icons.check_circle,
    'cancelled': Icons.cancel_outlined,
  };

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor[order.status] ?? Colors.grey;
    final icon = _statusIcon[order.status] ?? Icons.receipt;
    final label = _statusLabel[order.status] ?? order.status;
    final date = DateFormat('dd MMM yyyy, hh:mm a').format(order.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('#${order.id.substring(0, 8).toUpperCase()}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A2332))),
                      Text(date, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            // Items preview
            ...order.items.take(2).map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Text('${item.qty}×', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(width: 6),
                  Expanded(child: Text(item.name, style: const TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Text('৳${item.subtotal.toInt()}', style: const TextStyle(fontSize: 12, color: Color(0xFF2ECC71), fontWeight: FontWeight.w600)),
                ],
              ),
            )),
            if (order.items.length > 2)
              Text('+ ${order.items.length - 2}টি আরও', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.money, size: 15, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(order.paymentMethod.toUpperCase(), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                Text(
                  'মোট ৳${order.grandTotal.toInt()}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFFF6B35)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
