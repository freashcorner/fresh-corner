import { useEffect, useState } from "react";
import { collection, getDocs, query, where, orderBy, limit } from "firebase/firestore";
import { db } from "../lib/firebase";
import { ShoppingCart, Package, Users, TrendingUp } from "lucide-react";

interface Stats {
  totalOrders: number;
  pendingOrders: number;
  totalProducts: number;
  totalUsers: number;
  todayRevenue: number;
}

export default function Dashboard() {
  const [stats, setStats] = useState<Stats>({
    totalOrders: 0, pendingOrders: 0, totalProducts: 0, totalUsers: 0, todayRevenue: 0,
  });
  const [recentOrders, setRecentOrders] = useState<any[]>([]);

  useEffect(() => {
    async function fetchStats() {
      const [ordersSnap, productsSnap, usersSnap, pendingSnap] = await Promise.all([
        getDocs(collection(db, "orders")),
        getDocs(query(collection(db, "products"), where("isActive", "==", true))),
        getDocs(collection(db, "users")),
        getDocs(query(collection(db, "orders"), where("status", "==", "pending"))),
      ]);

      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const todayRevenue = ordersSnap.docs
        .filter((d) => {
          const createdAt = d.data().createdAt?.toDate?.();
          return createdAt && createdAt >= today && d.data().status === "delivered";
        })
        .reduce((sum, d) => sum + (d.data().grandTotal || 0), 0);

      setStats({
        totalOrders: ordersSnap.size,
        pendingOrders: pendingSnap.size,
        totalProducts: productsSnap.size,
        totalUsers: usersSnap.size,
        todayRevenue,
      });
    }

    async function fetchRecentOrders() {
      const snap = await getDocs(
        query(collection(db, "orders"), orderBy("createdAt", "desc"), limit(5))
      );
      setRecentOrders(snap.docs.map((d) => ({ id: d.id, ...d.data() })));
    }

    fetchStats();
    fetchRecentOrders();
  }, []);

  const cards = [
    { label: "মোট অর্ডার", value: stats.totalOrders, icon: ShoppingCart, color: "bg-blue-500/10 text-blue-400" },
    { label: "অপেক্ষমান অর্ডার", value: stats.pendingOrders, icon: ShoppingCart, color: "bg-yellow-500/10 text-yellow-400" },
    { label: "মোট পণ্য", value: stats.totalProducts, icon: Package, color: "bg-g1/10 text-g1" },
    { label: "মোট ব্যবহারকারী", value: stats.totalUsers, icon: Users, color: "bg-purple-500/10 text-purple-400" },
    { label: "আজকের আয় (৳)", value: stats.todayRevenue.toFixed(0), icon: TrendingUp, color: "bg-yaru-orange/10 text-yaru-orange" },
  ];

  const STATUS_COLORS: Record<string, string> = {
    pending: "text-yellow-400",
    confirmed: "text-blue-400",
    processing: "text-purple-400",
    shipped: "text-cyan-400",
    delivered: "text-green-400",
    cancelled: "text-red-400",
  };

  const STATUS_LABEL: Record<string, string> = {
    pending: "অপেক্ষমান", confirmed: "নিশ্চিত", processing: "প্রস্তুত",
    shipped: "পাঠানো", delivered: "পৌঁছে গেছে", cancelled: "বাতিল",
  };

  return (
    <div className="p-6 space-y-6">
      <h1 className="text-xl font-semibold text-white font-bangla">ড্যাশবোর্ড</h1>

      {/* Stats */}
      <div className="grid grid-cols-2 lg:grid-cols-5 gap-4">
        {cards.map(({ label, value, icon: Icon, color }) => (
          <div key={label} className="bg-[#2D2D2D] rounded-xl p-4 border border-white/10">
            <div className={`w-10 h-10 rounded-lg ${color} flex items-center justify-center mb-3`}>
              <Icon size={18} />
            </div>
            <div className="text-2xl font-bold text-white">{value}</div>
            <div className="text-xs text-white/40 mt-1 font-bangla">{label}</div>
          </div>
        ))}
      </div>

      {/* Recent Orders */}
      <div className="bg-[#2D2D2D] rounded-xl border border-white/10">
        <div className="px-5 py-4 border-b border-white/10">
          <h2 className="text-sm font-semibold text-white font-bangla">সাম্প্রতিক অর্ডার</h2>
        </div>
        <div className="divide-y divide-white/5">
          {recentOrders.length === 0 && (
            <div className="px-5 py-8 text-center text-white/30 text-sm font-bangla">কোনো অর্ডার নেই</div>
          )}
          {recentOrders.map((order) => (
            <div key={order.id} className="px-5 py-3 flex items-center justify-between">
              <div>
                <div className="text-sm text-white font-bangla">{order.userName || "—"}</div>
                <div className="text-xs text-white/40">{order.id.slice(0, 8)}...</div>
              </div>
              <div className="text-right">
                <div className="text-sm font-semibold text-white">৳{order.grandTotal}</div>
                <div className={`text-xs font-bangla ${STATUS_COLORS[order.status] || "text-white/40"}`}>
                  {STATUS_LABEL[order.status] || order.status}
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
