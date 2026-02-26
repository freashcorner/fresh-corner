import { Outlet, NavLink, useNavigate } from "react-router-dom";
import { signOut } from "firebase/auth";
import { auth } from "../lib/firebase";
import {
  LayoutDashboard, Package, Tag, ShoppingCart,
  Users, Truck, LogOut
} from "lucide-react";
import clsx from "clsx";

const NAV = [
  { to: "/", label: "ড্যাশবোর্ড", icon: LayoutDashboard, exact: true },
  { to: "/products", label: "পণ্য", icon: Package },
  { to: "/categories", label: "ক্যাটাগরি", icon: Tag },
  { to: "/orders", label: "অর্ডার", icon: ShoppingCart },
  { to: "/users", label: "ব্যবহারকারী", icon: Users },
  { to: "/delivery", label: "ডেলিভারি", icon: Truck },
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
      <aside className="w-56 flex flex-col bg-[#252525] border-r border-white/10 flex-shrink-0">
        {/* Logo */}
        <div className="flex items-center gap-3 px-4 py-4 border-b border-white/10">
          <div className="w-8 h-8 rounded-lg bg-yaru-orange flex items-center justify-center text-white font-bold text-sm">FC</div>
          <div>
            <div className="text-sm font-semibold text-white font-bangla">ফ্রেশ কর্নার</div>
            <div className="text-[10px] text-white/40">Admin Panel</div>
          </div>
        </div>

        {/* Nav */}
        <nav className="flex-1 overflow-y-auto py-3 px-2 space-y-0.5">
          {NAV.map(({ to, label, icon: Icon, exact }) => (
            <NavLink
              key={to}
              to={to}
              end={exact}
              className={({ isActive }) =>
                clsx(
                  "flex items-center gap-3 px-3 py-2 rounded-lg text-sm transition-colors font-bangla",
                  isActive
                    ? "bg-yaru-orange text-white"
                    : "text-white/60 hover:bg-white/8 hover:text-white"
                )
              }
            >
              <Icon size={16} />
              {label}
            </NavLink>
          ))}
        </nav>

        {/* Logout */}
        <button
          onClick={handleLogout}
          className="flex items-center gap-3 px-5 py-4 border-t border-white/10 text-sm text-white/40 hover:text-red-400 transition-colors font-bangla"
        >
          <LogOut size={16} />
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
