import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _wishlisted = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cart = context.watch<CartProvider>();
    final cartItem = cart.getItem(product.id);
    final hasDiscount = product.discountPrice != null && product.discountPrice! < product.price;
    final discountPct = hasDiscount
        ? (((product.price - product.discountPrice!) / product.price) * 100).round()
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1A2332)),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => setState(() => _wishlisted = !_wishlisted),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      _wishlisted ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: _wishlisted ? Colors.red : const Color(0xFF1A2332),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF8F9FA), Color(0xFFE8F5E9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: product.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (_, __, ___) => const Center(child: Text('🥦', style: TextStyle(fontSize: 80))),
                      )
                    : const Center(child: Text('🥦', style: TextStyle(fontSize: 80))),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Row(
                    children: [
                      if (hasDiscount)
                        _tag('$discountPct% ছাড়', const Color(0xFFE8F5E9), const Color(0xFF27AE60)),
                      const SizedBox(width: 6),
                      if (product.isFeatured)
                        _tag('ফিচার্ড', const Color(0xFFFFF0EB), const Color(0xFFFF6B35)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2332))),
                  const SizedBox(height: 4),
                  Text(product.unit, style: const TextStyle(fontSize: 13, color: Colors.grey)),

                  const SizedBox(height: 14),
                  // Price row
                  Row(
                    children: [
                      Text(
                        '৳${product.effectivePrice.toInt()}',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2ECC71)),
                      ),
                      const SizedBox(width: 10),
                      if (hasDiscount) ...[
                        Text(
                          '৳${product.price.toInt()}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _tag('৳${(product.price - product.effectivePrice).toInt()} সাশ্রয়', const Color(0xFFE8F5E9), const Color(0xFF27AE60)),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Stock info
                  Row(
                    children: [
                      Icon(
                        product.stock > 0 ? Icons.check_circle : Icons.cancel,
                        size: 16,
                        color: product.stock > 0 ? const Color(0xFF2ECC71) : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.stock > 0 ? 'স্টকে আছে (${product.stock} ${product.unit})' : 'স্টকে নেই',
                        style: TextStyle(
                          fontSize: 13,
                          color: product.stock > 0 ? const Color(0xFF27AE60) : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  if (product.description != null && product.description!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('বিবরণ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(product.description!, style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.6)),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -2))],
        ),
        child: product.stock > 0
            ? cartItem != null
                ? Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: const Color(0xFF2ECC71), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            _cartBtn(Icons.remove, () => cart.updateQty(product.id, cartItem.qty - 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text('${cartItem.qty}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                            ),
                            _cartBtn(Icons.add, () => cart.addItem(product)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/home'),
                          child: Text('কার্টে আছে — ৳${(cartItem.subtotal).toInt()}'),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () { cart.addItem(product); ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} কার্টে যোগ হয়েছে'),
                          backgroundColor: const Color(0xFF2ECC71),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      ); },
                      child: const Text('কার্টে যোগ করুন'),
                    ),
                  )
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300),
                  child: const Text('স্টক নেই', style: TextStyle(color: Colors.grey)),
                ),
              ),
      ),
    );
  }

  Widget _tag(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fg)),
    );
  }

  Widget _cartBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
