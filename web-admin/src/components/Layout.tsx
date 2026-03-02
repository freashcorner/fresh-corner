import { Outlet, NavLink, useNavigate } from "react-router-dom";
import { signOut } from "firebase/auth";
import { auth } from "../lib/firebase";
import {
  LayoutDashboard, Activity, ShoppingCart, Truck, RotateCcw,
  Package, Warehouse, Tag, Users, Bike, Store, Shield,
  Percent, Bell, Image, DollarSign, CreditCard,
  BarChart3, FileText, HeadphonesIcon, Settings, ScrollText,
  LogOut,
} from "lucide-react";
import clsx from "clsx";

interface NavItem {
  to: string;
  label: string;
  icon: any;
  exact?: boolean;
  badge?: number;
}

interface NavSection {
  title: string;
  items: NavItem[];
}

const SECTIONS: NavSection[] = [
  {
    title: "প্রধান",
    items: [
      { to: "/", label: "ড্যাশবোর্ড", icon: LayoutDashboard, exact: true },
      { to: "/live-monitor", label: "লাইভ মনিটর", icon: Activity },
    ],
  },
  {
    title: "অর্ডার",
    items: [
      { to: "/orders", label: "অর্ডার", icon: ShoppingCart },
      { to: "/dispatch", label: "ডিসপ্যাচ পোর্টাল", icon: Truck },
      { to: "/returns", label: "রিটার্ন ও রিফান্ড", icon: RotateCcw },
    ],
  },
  {
    title: "পণ্য",
    items: [
      { to: "/products", label: "পণ্য ক্যাটালগ", icon: Package },
      { to: "/inventory", label: "ইনভেন্টরি", icon: Warehouse },
      { to: "/categories", label: "ক্যাটাগরি", icon: Tag },
    ],
  },
  {
    title: "ব্যবহারকারী",
    items: [
      { to: "/customers", label: "গ্রাহক", icon: Users },
      { to: "/riders", label: "রাইডার", icon: Bike },
      { to: "/vendors", label: "ভেন্ডর", icon: Store },
      { to: "/staff", label: "স্টাফ ও রোল", icon: Shield },
    ],
  },
  {
    title: "মার্কেটিং",
    items: [
      { to: "/promos", label: "প্রোমো ও কুপন", icon: Percent },
      { to: "/notifications", label: "নোটিফিকেশন", icon: Bell },
      { to: "/banners", label: "ব্যানার", icon: Image },
    ],
  },
  {
    title: "অর্থ",
    items: [
      { to: "/finance", label: "ফাইন্যান্স", icon: DollarSign },
      { to: "/payouts", label: "পেআউট", icon: CreditCard },
    ],
  },
  {
    title: "বিশ্লেষণ",
    items: [
      { to: "/analytics", label: "অ্যানালিটিক্স", icon: BarChart3 },
      { to: "/reports", label: "রিপোর্ট সেন্টার", icon: FileText },
    ],
  },
  {
    title: "সিস্টেম",
    items: [
      { to: "/support", label: "সাপোর্ট টিকেট", icon: HeadphonesIcon },
      { to: "/settings", label: "সেটিংস", icon: Settings },
      { to: "/activity-logs", label: "অ্যাক্টিভিটি লগ", icon: ScrollText },
    ],
  },
];

export default function Layout() {
  const navigate = useNavigate();

  async function handleLogout() {
    await signOut(auth);
    navigate("/login");
  }

  return (
    <div className="flex h-screen w-full overflow-hidden bg-[#1C1C1C]">
      {/* Sidebar */}
      <aside className="w-[220px] flex flex-col bg-[#252525] border-r border-white/10 flex-shrink-0">
        {/* Logo */}
        <div className="flex items-center gap-3 px-4 py-4 border-b border-white/10">
          <div className="w-8 h-8 rounded-lg bg-yaru-orange flex items-center justify-center text-white font-bold text-sm">FC</div>
          <div>
            <div className="text-sm font-semibold text-white font-bangla">ফ্রেশ কর্নার</div>
            <div className="text-[10px] text-white/40">Admin Panel</div>
          </div>
        </div>

        {/* Nav */}
        <nav className="flex-1 overflow-y-auto py-2 px-2">
          {SECTIONS.map((section) => (
            <div key={section.title} className="mb-1">
              <div className="text-[10px] font-medium text-white/40 uppercase tracking-wider px-3 pt-3 pb-1 font-bangla">
                {section.title}
              </div>
              {section.items.map(({ to, label, icon: Icon, exact, badge }) => (
                <NavLink
                  key={to}
                  to={to}
                  end={exact}
                  className={({ isActive }) =>
                    clsx(
                      "flex items-center gap-2.5 px-3 py-1.5 rounded-lg text-[13px] transition-colors font-bangla",
                      isActive
                        ? "bg-yaru-orange text-white"
                        : "text-white/60 hover:bg-white/8 hover:text-white"
                    )
                  }
                >
                  <Icon size={15} />
                  <span className="flex-1 truncate">{label}</span>
                  {badge !== undefined && badge > 0 && (
                    <span className="bg-red-500 text-white text-[10px] px-1.5 py-0.5 rounded-full min-w-[18px] text-center">{badge}</span>
                  )}
                </NavLink>
              ))}
            </div>
          ))}
        </nav>

        {/* Logout */}
        <button
          onClick={handleLogout}
          className="flex items-center gap-3 px-5 py-3 border-t border-white/10 text-sm text-white/40 hover:text-red-400 transition-colors font-bangla"
        >
          <LogOut size={15} />
          লগআউট
        </button>
      </aside>

      {/* Main */}
      <main className="flex-1 overflow-y-auto">
        <Outlet />
      </main>
    </div>
  );
}
