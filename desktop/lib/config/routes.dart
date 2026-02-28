import 'package:flutter/material.dart';

enum PageId {
  dashboard,
  liveMonitor,
  orders,
  dispatch,
  returns,
  products,
  inventory,
  categories,
  customers,
  riders,
  vendors,
  staff,
  promos,
  notifications,
  banners,
  finance,
  payouts,
  analytics,
  reports,
  support,
  settings,
  activityLogs,
}

class NavSection {
  final String label;
  final List<NavItem> items;
  const NavSection(this.label, this.items);
}

class NavItem {
  final PageId id;
  final String label;
  final IconData icon;
  final int badge;
  const NavItem(this.id, this.label, this.icon, [this.badge = 0]);
}

final List<NavSection> navSections = [
  const NavSection('প্রধান', [
    NavItem(PageId.dashboard, 'ড্যাশবোর্ড', Icons.dashboard_outlined),
    NavItem(PageId.liveMonitor, 'লাইভ মনিটর', Icons.monitor_heart_outlined, 23),
  ]),
  const NavSection('অর্ডার', [
    NavItem(PageId.orders, 'সকল অর্ডার', Icons.receipt_long_outlined, 7),
    NavItem(PageId.dispatch, 'ডিসপ্যাচ পোর্টাল', Icons.local_shipping_outlined),
    NavItem(PageId.returns, 'রিটার্ন ও রিফান্ড', Icons.assignment_return_outlined),
  ]),
  const NavSection('পণ্য', [
    NavItem(PageId.products, 'পণ্য ক্যাটালগ', Icons.inventory_2_outlined),
    NavItem(PageId.inventory, 'ইনভেন্টরি', Icons.warehouse_outlined, 5),
    NavItem(PageId.categories, 'ক্যাটাগরি', Icons.category_outlined),
  ]),
  const NavSection('ব্যবহারকারী', [
    NavItem(PageId.customers, 'কাস্টমার', Icons.people_outline),
    NavItem(PageId.riders, 'রাইডার', Icons.delivery_dining_outlined),
    NavItem(PageId.vendors, 'ভেন্ডর', Icons.store_outlined),
    NavItem(PageId.staff, 'স্টাফ ও ভূমিকা', Icons.admin_panel_settings_outlined),
  ]),
  const NavSection('মার্কেটিং', [
    NavItem(PageId.promos, 'প্রোমো ও কুপন', Icons.local_offer_outlined),
    NavItem(PageId.notifications, 'নোটিফিকেশন', Icons.notifications_outlined),
    NavItem(PageId.banners, 'ব্যানার', Icons.image_outlined),
  ]),
  const NavSection('অর্থ', [
    NavItem(PageId.finance, 'আয় ও লেনদেন', Icons.account_balance_outlined),
    NavItem(PageId.payouts, 'পেআউট', Icons.payments_outlined),
  ]),
  const NavSection('বিশ্লেষণ', [
    NavItem(PageId.analytics, 'অ্যানালিটিক্স', Icons.analytics_outlined),
    NavItem(PageId.reports, 'রিপোর্ট সেন্টার', Icons.summarize_outlined),
  ]),
  const NavSection('সিস্টেম', [
    NavItem(PageId.support, 'সাপোর্ট টিকেট', Icons.support_agent_outlined, 12),
    NavItem(PageId.settings, 'সেটিংস', Icons.settings_outlined),
    NavItem(PageId.activityLogs, 'অ্যাক্টিভিটি লগ', Icons.history_outlined),
  ]),
];

String pageBengaliLabel(PageId id) {
  for (final s in navSections) {
    for (final item in s.items) {
      if (item.id == id) return item.label;
    }
  }
  return '';
}

String pageSectionLabel(PageId id) {
  for (final s in navSections) {
    for (final item in s.items) {
      if (item.id == id) return s.label;
    }
  }
  return '';
}
