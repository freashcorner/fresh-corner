import 'dart:math';

class MockDataService {
  static final _rng = Random(42);

  static String _bengaliName(int i) {
    const names = ['রহিম উদ্দিন', 'করিম হোসেন', 'জামাল আহমেদ', 'ফাতেমা বেগম', 'আয়েশা খাতুন',
      'সালমা আক্তার', 'মোহাম্মদ আলী', 'শাহিদা পারভীন', 'নাসরিন সুলতানা', 'আবদুল্লাহ আল মামুন',
      'তানভীর হাসান', 'নুসরাত জাহান', 'শাকিল আহমেদ', 'রুমানা আফরোজ', 'মাহফুজ রহমান'];
    return names[i % names.length];
  }

  static String _phone(int i) => '01${700 + i % 100}${100000 + i * 137 % 900000}';
  static String _area(int i) {
    const areas = ['মিরপুর', 'ধানমন্ডি', 'গুলশান', 'বনানী', 'উত্তরা', 'মোহাম্মদপুর', 'লালবাগ', 'তেজগাঁও', 'বাড্ডা', 'রামপুরা'];
    return areas[i % areas.length];
  }

  // Riders
  static List<Map<String, dynamic>> riders() => List.generate(15, (i) => {
    'id': 'RD${1000 + i}',
    'name': _bengaliName(i + 5),
    'phone': _phone(i + 50),
    'status': i % 4 == 0 ? 'inactive' : 'active',
    'deliveries': 80 + _rng.nextInt(200),
    'rating': (3.5 + _rng.nextDouble() * 1.5).toStringAsFixed(1),
    'earnings': '৳${8000 + _rng.nextInt(15000)}',
    'area': _area(i),
  });

  // Customers
  static List<Map<String, dynamic>> customers() => List.generate(20, (i) => {
    'id': 'CU${2000 + i}',
    'name': _bengaliName(i),
    'phone': _phone(i),
    'orders': 5 + _rng.nextInt(40),
    'spent': '৳${2000 + _rng.nextInt(20000)}',
    'area': _area(i),
    'tier': i % 5 == 0 ? 'Premium' : i % 3 == 0 ? 'Regular' : 'New',
    'joined': '2024-${(i % 12 + 1).toString().padLeft(2, '0')}-${(i % 28 + 1).toString().padLeft(2, '0')}',
  });

  // Vendors
  static List<Map<String, dynamic>> vendors() => List.generate(10, (i) => {
    'id': 'VN${3000 + i}',
    'name': ['তাজা ফার্ম', 'গ্রীন ভ্যালি', 'ফ্রেশ মার্ট', 'কৃষক বাজার', 'অর্গানিক হাব',
      'দেশি ফুড', 'প্রকৃতি', 'সবুজ কৃষি', 'ন্যাচারাল ফুড', 'হেলদি চয়েস'][i],
    'contact': _bengaliName(i + 10),
    'phone': _phone(i + 100),
    'products': 10 + _rng.nextInt(50),
    'status': i % 3 == 0 ? 'inactive' : 'active',
    'rating': (3.0 + _rng.nextDouble() * 2.0).toStringAsFixed(1),
  });

  // Staff
  static List<Map<String, dynamic>> staff() => List.generate(8, (i) => {
    'id': 'ST${4000 + i}',
    'name': _bengaliName(i + 15),
    'email': 'staff${i + 1}@freshcorner.com',
    'role': ['Super Admin', 'Manager', 'Order Manager', 'Support Agent', 'Inventory Manager', 'Finance', 'Marketing', 'Viewer'][i],
    'status': 'active',
    'lastLogin': '2025-02-${(20 + i % 8).toString().padLeft(2, '0')} ${10 + i}:30',
  });

  // Promos
  static List<Map<String, dynamic>> promos() => List.generate(8, (i) => {
    'id': 'PR${5000 + i}',
    'code': ['FRESH20', 'SAVE10', 'NEWUSER', 'SUMMER', 'EID50', 'FREE100', 'COMBO', 'WINTER'][i],
    'type': i % 2 == 0 ? 'শতাংশ' : 'নির্দিষ্ট',
    'value': i % 2 == 0 ? '${10 + i * 5}%' : '৳${50 + i * 25}',
    'used': _rng.nextInt(200),
    'limit': 200 + i * 50,
    'status': i < 5 ? 'active' : 'inactive',
    'expires': '2025-${(i % 12 + 3).toString().padLeft(2, '0')}-${(i % 28 + 1).toString().padLeft(2, '0')}',
  });

  // Notifications (sent)
  static List<Map<String, dynamic>> sentNotifications() => List.generate(10, (i) => {
    'id': 'NT${6000 + i}',
    'title': ['নতুন অফার!', 'ডেলিভারি আপডেট', 'অর্ডার নিশ্চিত', 'ঈদ স্পেশাল', 'স্টক আপডেট',
      'পেমেন্ট সফল', 'রিভিউ দিন', 'ফ্রি ডেলিভারি', 'নতুন পণ্য', 'ক্যাশব্যাক'][i],
    'type': i % 3 == 0 ? 'Push' : i % 3 == 1 ? 'SMS' : 'Email',
    'sent': '${1000 + _rng.nextInt(5000)}',
    'opened': '${500 + _rng.nextInt(3000)}',
    'date': '2025-02-${(15 + i % 10).toString().padLeft(2, '0')}',
  });

  // Banners
  static List<Map<String, dynamic>> banners() => List.generate(6, (i) => {
    'id': 'BN${7000 + i}',
    'title': ['হোম স্লাইডার ১', 'ঈদ ব্যানার', 'ক্যাটাগরি ব্যানার', 'অফার পেজ', 'চেকআউট প্রোমো', 'অ্যাপ ওপেন'][i],
    'position': ['হোম টপ', 'হোম মিড', 'ক্যাটাগরি', 'অফার', 'চেকআউট', 'স্প্ল্যাশ'][i],
    'status': i < 4 ? 'active' : 'inactive',
    'clicks': _rng.nextInt(3000),
    'impressions': 5000 + _rng.nextInt(20000),
  });

  // Finance / Transactions
  static List<Map<String, dynamic>> transactions() => List.generate(15, (i) => {
    'id': 'TX${8000 + i}',
    'date': '2025-02-${(28 - i).toString().padLeft(2, '0')}',
    'type': i % 3 == 0 ? 'অর্ডার আয়' : i % 3 == 1 ? 'রাইডার পেমেন্ট' : 'রিফান্ড',
    'amount': '৳${500 + _rng.nextInt(5000)}',
    'method': i % 2 == 0 ? 'bKash' : 'Cash',
    'status': i % 4 == 0 ? 'pending' : 'delivered',
  });

  // Payouts
  static List<Map<String, dynamic>> payouts() => List.generate(10, (i) => {
    'id': 'PO${9000 + i}',
    'rider': _bengaliName(i + 5),
    'amount': '৳${3000 + _rng.nextInt(8000)}',
    'method': i % 2 == 0 ? 'bKash' : 'Bank',
    'status': i < 6 ? 'delivered' : 'pending',
    'date': '2025-02-${(25 - i).toString().padLeft(2, '0')}',
  });

  // Returns
  static List<Map<String, dynamic>> returns() => List.generate(8, (i) => {
    'id': 'RT${1100 + i}',
    'orderId': 'ORD${5000 + i}',
    'customer': _bengaliName(i),
    'reason': ['ভুল পণ্য', 'নষ্ট পণ্য', 'দেরি', 'মান খারাপ', 'অন্যান্য', 'ভুল পণ্য', 'নষ্ট পণ্য', 'দেরি'][i],
    'amount': '৳${200 + _rng.nextInt(1000)}',
    'status': i < 3 ? 'pending' : i < 6 ? 'confirmed' : 'cancelled',
    'date': '2025-02-${(20 + i % 8).toString().padLeft(2, '0')}',
  });

  // Categories
  static List<Map<String, dynamic>> categories() => [
    {'id': 'C1', 'name': 'শাকসবজি', 'products': 45, 'icon': '🥬', 'status': 'active'},
    {'id': 'C2', 'name': 'ফলমূল', 'products': 32, 'icon': '🍎', 'status': 'active'},
    {'id': 'C3', 'name': 'মাছ', 'products': 28, 'icon': '🐟', 'status': 'active'},
    {'id': 'C4', 'name': 'মাংস', 'products': 18, 'icon': '🥩', 'status': 'active'},
    {'id': 'C5', 'name': 'দুধ ও ডেইরি', 'products': 22, 'icon': '🥛', 'status': 'active'},
    {'id': 'C6', 'name': 'মসলা', 'products': 35, 'icon': '🌶️', 'status': 'active'},
    {'id': 'C7', 'name': 'চাল ও ডাল', 'products': 15, 'icon': '🍚', 'status': 'active'},
    {'id': 'C8', 'name': 'স্ন্যাকস', 'products': 40, 'icon': '🍪', 'status': 'inactive'},
    {'id': 'C9', 'name': 'পানীয়', 'products': 25, 'icon': '🥤', 'status': 'active'},
    {'id': 'C10', 'name': 'হিমায়িত', 'products': 12, 'icon': '🧊', 'status': 'active'},
  ];

  // Support tickets
  static List<Map<String, dynamic>> supportTickets() => List.generate(12, (i) => {
    'id': 'TK${200 + i}',
    'customer': _bengaliName(i),
    'subject': ['ডেলিভারি দেরি', 'ভুল পণ্য পেয়েছি', 'রিফান্ড চাই', 'অ্যাপ সমস্যা', 'পেমেন্ট ফেইল',
      'রাইডার সমস্যা', 'পণ্যের মান', 'অর্ডার ক্যান্সেল', 'কুপন কাজ করছে না', 'অ্যাকাউন্ট সমস্যা', 'ডেলিভারি এরিয়া', 'অন্যান্য'][i],
    'priority': i % 3 == 0 ? 'high' : i % 3 == 1 ? 'medium' : 'low',
    'status': i < 4 ? 'open' : i < 9 ? 'resolved' : 'closed',
    'assigned': _bengaliName(i + 15),
    'created': '2025-02-${(28 - i).toString().padLeft(2, '0')} ${10 + i % 8}:${15 + i * 3 % 45}',
  });

  // Activity logs
  static List<Map<String, dynamic>> activityLogs() => List.generate(20, (i) => {
    'id': 'AL${300 + i}',
    'user': _bengaliName(i % 8 + 15),
    'action': ['অর্ডার স্ট্যাটাস পরিবর্তন', 'নতুন পণ্য যোগ', 'রাইডার নিযুক্ত', 'প্রোমো কোড তৈরি',
      'ব্যানার আপডেট', 'ইনভেন্টরি আপডেট', 'রিফান্ড প্রসেস', 'ইউজার ব্লক', 'সেটিংস পরিবর্তন', 'রিপোর্ট জেনারেট',
      'অর্ডার স্ট্যাটাস পরিবর্তন', 'নতুন পণ্য যোগ', 'রাইডার নিযুক্ত', 'প্রোমো কোড তৈরি',
      'ব্যানার আপডেট', 'ইনভেন্টরি আপডেট', 'রিফান্ড প্রসেস', 'ইউজার ব্লক', 'সেটিংস পরিবর্তন', 'রিপোর্ট জেনারেট'][i],
    'target': 'ORD-${5000 + i * 7}',
    'time': '${(23 - i % 12)}:${(59 - i * 3 % 50).toString().padLeft(2, '0')}',
    'date': '2025-02-${(28 - i ~/ 3).toString().padLeft(2, '0')}',
    'color': [0xFFE95420, 0xFF26A269, 0xFF1C71D8, 0xFF9141AC, 0xFFF5C211][i % 5],
  });

  // Live monitor data
  static Map<String, dynamic> liveData() => {
    'activeOrders': 23,
    'onlineRiders': 8,
    'avgDeliveryTime': '28 মিনিট',
    'pendingDispatch': 5,
    'recentOrders': List.generate(8, (i) => {
      'id': 'ORD-${6000 + i}',
      'customer': _bengaliName(i),
      'area': _area(i),
      'status': ['pending', 'confirmed', 'processing', 'shipped', 'delivered', 'pending', 'confirmed', 'processing'][i],
      'time': '${i + 1} মিনিট আগে',
    }),
    'heatmap': List.generate(10, (i) => {'area': _area(i), 'orders': 5 + _rng.nextInt(25)}),
  };

  // Analytics summary
  static Map<String, dynamic> analyticsSummary() => {
    'dailyRevenue': List.generate(7, (i) => BarChartEntry('${22 + i} ফেব', 5000.0 + _rng.nextInt(15000))),
    'categoryBreakdown': [
      DonutEntry('শাকসবজি', 35, 0xFF26A269),
      DonutEntry('ফলমূল', 22, 0xFFF5C211),
      DonutEntry('মাছ', 18, 0xFF1C71D8),
      DonutEntry('মাংস', 15, 0xFFE01B24),
      DonutEntry('অন্যান্য', 10, 0xFF9141AC),
    ],
    'totalRevenue': '৳১,২৫,৪৮০',
    'totalOrders': '৩,২৪৫',
    'avgOrderValue': '৳৩৮৬',
    'repeatRate': '৬৮%',
  };
}

class BarChartEntry {
  final String label;
  final double value;
  BarChartEntry(this.label, this.value);
}

class DonutEntry {
  final String label;
  final double value;
  final int colorValue;
  DonutEntry(this.label, this.value, this.colorValue);
}
