import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/firebase_service.dart';
import '../../models/product.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_screen.dart';
import 'widgets/product_card.dart';
import 'widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  List<Map<String, dynamic>> _categories = [];
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final [catDocs, prodDocs] = await Future.wait([
      FirebaseService.getCategories(),
      FirebaseService.getProducts(),
    ]);

    setState(() {
      _categories = catDocs.map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}).toList();
      _products = prodDocs.map((d) => Product.fromMap(d.data() as Map<String, dynamic>, d.id)).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().count;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: IndexedStack(
        index: _tab,
        children: [
          _HomeTab(categories: _categories, products: _products, loading: _loading),
          const CartScreen(),
          const OrdersScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'হোম'),
          NavigationDestination(
            icon: Badge(count: cartCount, child: const Icon(Icons.shopping_cart_outlined)),
            selectedIcon: Badge(count: cartCount, child: const Icon(Icons.shopping_cart)),
            label: 'কার্ট',
          ),
          const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'অর্ডার'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final List<Product> products;
  final bool loading;

  const _HomeTab({required this.categories, required this.products, required this.loading});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 140,
          floating: false,
          pinned: true,
          backgroundColor: const Color(0xFF2ECC71),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF1A4731), Color(0xFF2ECC71)]),
              ),
              padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('ফ্রেশ কর্নার', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('তাজা বাজার, দোরগোড়ায় ডেলিভারি', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),

        if (loading)
          const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
        else ...[
          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('ক্যাটাগরি', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categories.length,
                itemBuilder: (_, i) => CategoryChip(category: categories[i]),
              ),
            ),
          ),

          // Products
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: const Text('সব পণ্য', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, i) => ProductCard(product: products[i]),
                childCount: products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
