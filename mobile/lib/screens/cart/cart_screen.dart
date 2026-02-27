import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../services/firebase_service.dart';

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
  double _deliveryCharge = 30;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await FirebaseService.getSettings();
      if (settings != null && mounted) {
        setState(() => _deliveryCharge = (settings['deliveryCharge'] ?? 30).toDouble());
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _streetCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();

    if (auth.firebaseUser == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }
    if (_nameCtrl.text.trim().isEmpty || _streetCtrl.text.trim().isEmpty || _areaCtrl.text.trim().isEmpty) {
      _showSnack('ডেলিভারি ঠিকানা সম্পূর্ণ করুন');
      return;
    }

    setState(() => _ordering = true);
    try {
      final orderItems = cart.items.map((item) => {
        'productId': item.product.id,
        'name': item.product.name,
        'price': item.product.effectivePrice,
        'qty': item.qty,
        'unit': item.product.unit,
        'imageUrl': item.product.imageUrl,
        'subtotal': item.subtotal,
      }).toList();

      await ApiService.post('/api/orders', {
        'userName': _nameCtrl.text.trim(),
        'userPhone': _phoneCtrl.text.trim().isNotEmpty
            ? _phoneCtrl.text.trim()
            : auth.appUser?.phone ?? '',
        'items': orderItems,
        'address': {
          'label': 'বাসা',
          'street': _streetCtrl.text.trim(),
          'area': _areaCtrl.text.trim(),
          'city': 'ঢাকা',
          'phone': _phoneCtrl.text.trim(),
        },
        'paymentMethod': 'cod',
      });

      cart.clear();
      _nameCtrl.clear();
      _phoneCtrl.clear();
      _streetCtrl.clear();
      _areaCtrl.clear();

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (_) {
      _showSnack('অর্ডার দেওয়া যায়নি। আবার চেষ্টা করুন।');
    } finally {
      setState(() => _ordering = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Color(0xFF2ECC71), size: 40),
            ),
            const SizedBox(height: 16),
            const Text('অর্ডার সফল!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('আপনার অর্ডার গ্রহণ করা হয়েছে', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ঠিক আছে'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    if (cart.items.isEmpty) {
      return _EmptyCart();
    }

    final total = cart.total;
    final grand = total + _deliveryCharge;

    return Scaffold(
      appBar: AppBar(
        title: Text('কার্ট (${cart.count}টি পণ্য)'),
        actions: [
          TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('কার্ট খালি করবেন?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('না')),
                  TextButton(onPressed: () { cart.clear(); Navigator.pop(context); }, child: const Text('হ্যাঁ', style: TextStyle(color: Colors.red))),
                ],
              ),
            ),
            child: const Text('খালি করুন', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Cart items
          ...cart.items.map((item) => _CartItemCard(
            item: item,
            onAdd: () => cart.addItem(item.product),
            onRemove: () => cart.updateQty(item.product.id, item.qty - 1),
          )),

          const SizedBox(height: 16),

          // Delivery address
          _sectionTitle('ডেলিভারি ঠিকানা'),
          const SizedBox(height: 10),
          _field(_nameCtrl, 'প্রাপকের নাম', Icons.person_outline),
          _field(_phoneCtrl, 'ফোন নম্বর', Icons.phone_outlined, inputType: TextInputType.phone),
          _field(_streetCtrl, 'রাস্তা ও বাড়ি নম্বর', Icons.home_outlined),
          _field(_areaCtrl, 'এলাকা / থানা', Icons.location_on_outlined),

          const SizedBox(height: 16),

          // Order summary
          _sectionTitle('অর্ডার সারসংক্ষেপ'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
            ),
            child: Column(
              children: [
                _summaryRow('পণ্যের মূল্য', '৳${total.toInt()}'),
                const SizedBox(height: 6),
                _summaryRow('ডেলিভারি চার্জ', '৳${_deliveryCharge.toInt()}'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                _summaryRow('মোট পরিশোধ', '৳${grand.toInt()}', bold: true, color: const Color(0xFFFF6B35)),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Payment method
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2ECC71), width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(9)),
                  child: const Icon(Icons.money, color: Color(0xFF27AE60), size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ক্যাশ অন ডেলিভারি', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('ডেলিভারির সময় নগদ পরিশোধ', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.check_circle, color: Color(0xFF2ECC71)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _ordering ? null : _placeOrder,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _ordering
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      'অর্ডার করুন — ৳${grand.toInt()}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2332)));
  }

  Widget _field(TextEditingController ctrl, String hint, IconData icon, {TextInputType? inputType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 18, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String val, {bool bold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: bold ? const Color(0xFF1A2332) : Colors.grey)),
        Text(val, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: color ?? (bold ? const Color(0xFF1A2332) : Colors.grey))),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _CartItemCard({required this.item, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: item.product.imageUrl.isNotEmpty
                ? Image.network(item.product.imageUrl, width: 52, height: 52, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder())
                : _placeholder(),
          ),
          const SizedBox(width: 10),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(item.product.unit, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 4),
                Text('৳${item.product.effectivePrice.toInt()} × ${item.qty} = ৳${item.subtotal.toInt()}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF2ECC71), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Qty controls
          Container(
            decoration: BoxDecoration(color: const Color(0xFF2ECC71), borderRadius: BorderRadius.circular(9)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _btn(Icons.remove, onRemove),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('${item.qty}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                _btn(Icons.add, onAdd),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: Colors.white, size: 14),
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 52, height: 52, color: const Color(0xFFF5F5F5),
    child: const Center(child: Text('🥦', style: TextStyle(fontSize: 24))),
  );
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(color: const Color(0xFFF5F5F5), shape: BoxShape.circle),
            child: const Center(child: Text('🛒', style: TextStyle(fontSize: 46))),
          ),
          const SizedBox(height: 20),
          const Text('কার্ট খালি', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2332))),
          const SizedBox(height: 6),
          const Text('পণ্য যোগ করুন এবং অর্ডার দিন', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text('কেনাকাটা করুন'),
          ),
        ],
      ),
    );
  }
}
