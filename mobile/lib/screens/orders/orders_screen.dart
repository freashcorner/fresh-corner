import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/order.dart';
import '../../services/firebase_service.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const Map<String, String> STATUS_LABEL = {
    'pending': 'অপেক্ষমান',
    'confirmed': 'নিশ্চিত',
    'processing': 'প্রস্তুত',
    'shipped': 'পাঠানো',
    'delivered': 'পৌঁছেছে',
    'cancelled': 'বাতিল',
  };

  static const Map<String, Color> STATUS_COLOR = {
    'pending': Colors.orange,
    'confirmed': Colors.blue,
    'processing': Colors.purple,
    'shipped': Colors.cyan,
    'delivered': Colors.green,
    'cancelled': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().firebaseUser;

    if (user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('অর্ডার দেখতে লগইন করুন'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71)),
              child: const Text('লগইন', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('আমার অর্ডার'), backgroundColor: const Color(0xFF2ECC71), foregroundColor: Colors.white),
      body: FutureBuilder(
        future: FirebaseService.getUserOrders(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('কোনো অর্ডার নেই', style: TextStyle(color: Colors.grey)));
          }
          final orders = docs.map((d) => Order.fromMap(d.data() as Map<String, dynamic>, d.id)).toList();
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (_, i) {
              final o = orders[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: (STATUS_COLOR[o.status] ?? Colors.grey).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.receipt_long, color: STATUS_COLOR[o.status] ?? Colors.grey, size: 20),
                  ),
                  title: Text('৳${o.grandTotal.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B35))),
                  subtitle: Text('${o.items.length}টি পণ্য • ${o.paymentMethod.toUpperCase()}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (STATUS_COLOR[o.status] ?? Colors.grey).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(STATUS_LABEL[o.status] ?? o.status,
                        style: TextStyle(color: STATUS_COLOR[o.status] ?? Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
