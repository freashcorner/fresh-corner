import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  bool _ordering = false;

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();

    if (auth.firebaseUser == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    setState(() => _ordering = true);
    try {
      final orderItems = cart.items.map((i) => i.product).map((p) {
        final item = cart.getItem(p.id)!;
        return {
          'productId': p.id,
          'name': p.name,
          'price': p.effectivePrice,
          'qty': item.qty,
          'unit': p.unit,
          'imageUrl': p.imageUrl,
          'subtotal': item.subtotal,
        };
      }).toList();

      await ApiService.post('/api/orders', {
        'userName': _nameCtrl.text,
        'userPhone': _phoneCtrl.text,
        'items': orderItems,
        'address': {
          'label': 'বাসা',
          'street': _streetCtrl.text,
          'area': _areaCtrl.text,
          'city': 'ঢাকা',
          'phone': _phoneCtrl.text,
        },
        'paymentMethod': 'cod',
      });

      cart.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('অর্ডার সফল হয়েছে!'), backgroundColor: Color(0xFF2ECC71)),
        );
      }
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('অর্ডার ব্যর্থ হয়েছে')));
    } finally {
      setState(() => _ordering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    if (cart.items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('কার্ট খালি', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('কার্ট'), backgroundColor: const Color(0xFF2ECC71), foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...cart.items.map((item) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item.product.imageUrl.isNotEmpty
                    ? Image.network(item.product.imageUrl, width: 48, height: 48, fit: BoxFit.cover)
                    : const SizedBox(width: 48, height: 48, child: Center(child: Text('🥦'))),
              ),
              title: Text(item.product.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              subtitle: Text('৳${item.product.effectivePrice.toInt()} × ${item.qty} = ৳${item.subtotal.toInt()}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: () => cart.updateQty(item.product.id, item.qty - 1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF2ECC71)),
                    onPressed: () => cart.addItem(item.product),
                  ),
                ],
              ),
            ),
          )),

          const SizedBox(height: 16),
          const Text('ডেলিভারি ঠিকানা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          _field(_nameCtrl, 'নাম'),
          _field(_phoneCtrl, 'ফোন নম্বর', inputType: TextInputType.phone),
          _field(_streetCtrl, 'রাস্তা ও বাড়ি নম্বর'),
          _field(_areaCtrl, 'এলাকা'),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _summaryRow('পণ্যের মূল্য', '৳${cart.total.toInt()}'),
                _summaryRow('ডেলিভারি চার্জ', '৳30'),
                const Divider(),
                _summaryRow('মোট', '৳${(cart.total + 30).toInt()}', bold: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _ordering ? null : _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2ECC71),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _ordering
                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : Text('অর্ডার করুন — ৳${(cart.total + 30).toInt()}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String hint, {TextInputType? inputType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: ctrl,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String val, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(val, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: bold ? const Color(0xFFFF6B35) : null)),
        ],
      ),
    );
  }
}
