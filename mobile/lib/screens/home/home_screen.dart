import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firebase_service.dart';
import '../../models/product.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_screen.dart';
import '../product/product_detail_screen.dart';
import 'widgets/product_card.dart';
import 'widgets/category_chip.dart';
import 'widgets/shimmer_grid.dart';
import 'widgets/banner_slider.dart';

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
    try {
      final results = await Future.wait([
        FirebaseService.getCategories(),
        FirebaseService.getProducts(),
      ]);
      if (mounted) {
        setState(() {
          _categories = results[0].map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>}).toList();
          _products = results[1].map((d) => Product.fromMap(d.data() as Map<String, dynamic>, d.id)).toList();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().count;

    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          _HomeTab(categories: _categories, products: _products, loading: _loading),
          const CartScreen(),
          const OrdersScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -2))],
        ),
        child: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          height: 64,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'হোম',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'কার্ট',
            ),
            const NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'অর্ডার',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final List<Product> products;
  final bool loading;

  const _HomeTab({required this.categories, required this.products, required this.loading});

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  String _selectedCategory = 'all';
  final _searchCtrl = TextEditingController();
  bool _searching = false;

  List<Product> get _filteredProducts {
    var list = widget.products;
    if (_selectedCategory != 'all') {
      list = list.where((p) => p.categoryId == _selectedCategory).toList();
    }
    if (_searchCtrl.text.isNotEmpty) {
      final q = _searchCtrl.text.toLowerCase();
      list = list.where((p) => p.name.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final username = auth.appUser?.name ?? 'বন্ধু';

    return CustomScrollView(
      slivers: [
        // Sticky header
        SliverAppBar(
          expandedHeight: 160,
          floating: false,
          pinned: true,
          backgroundColor: const Color(0xFF2ECC71),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A4731), Color(0xFF2ECC71)],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 52, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text('ঢাকা, বাংলাদেশ', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.75))),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'হ্যালো, $username 👋',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'পণ্য খুঁজুন...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () { _searchCtrl.clear(); setState(() {}); },
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),

        if (widget.loading)
          const SliverFillRemaining(child: ShimmerGrid())
        else ...[
          // Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
              child: BannerSlider(),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ক্যাটাগরি', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2332))),
                  Text('সব দেখুন', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 92,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  CategoryChip(
                    category: {'id': 'all', 'icon': '🛒', 'name': 'সব'},
                    isSelected: _selectedCategory == 'all',
                    onTap: () => setState(() => _selectedCategory = 'all'),
                  ),
                  ...widget.categories.map((c) => CategoryChip(
                    category: c,
                    isSelected: _selectedCategory == c['id'],
                    onTap: () => setState(() => _selectedCategory = c['id']),
                  )),
                ],
              ),
            ),
          ),

          // Products heading
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCategory == 'all' ? 'সব পণ্য' : 'পণ্যসমূহ',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2332)),
                  ),
                  Text(
                    '${_filteredProducts.length}টি পণ্য',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),

          // Products grid
          if (_filteredProducts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('😕', style: TextStyle(fontSize: 44)),
                    const SizedBox(height: 12),
                    Text(
                      _searchCtrl.text.isNotEmpty ? 'কোনো পণ্য পাওয়া যায়নি' : 'এই ক্যাটাগরিতে পণ্য নেই',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ProductCard(
                    product: _filteredProducts[i],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: _filteredProducts[i])),
                    ),
                  ),
                  childCount: _filteredProducts.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
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
