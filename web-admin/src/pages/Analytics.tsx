import { BarChart3, TrendingUp, ShoppingCart, Users } from "lucide-react";
import StatCard from "../components/StatCard";
import SectionHeader from "../components/SectionHeader";

const MONTHLY_DATA = [
  { month: "সেপ্টে", revenue: 45000 },
  { month: "অক্টো", revenue: 52000 },
  { month: "নভে", revenue: 48000 },
  { month: "ডিসে", revenue: 61000 },
  { month: "জানু", revenue: 58000 },
  { month: "ফেব্রু", revenue: 67000 },
];

const CATEGORY_BREAKDOWN = [
  { name: "চাল ও ডাল", percentage: 28, color: "bg-yaru-orange" },
  { name: "শাকসবজি", percentage: 22, color: "bg-green-500" },
  { name: "মাছ ও মাংস", percentage: 18, color: "bg-blue-500" },
  { name: "দুধ ও দই", percentage: 12, color: "bg-purple-500" },
  { name: "মসলা", percentage: 10, color: "bg-yellow-500" },
  { name: "অন্যান্য", percentage: 10, color: "bg-white/20" },
];

export default function Analytics() {
  const maxRevenue = Math.max(...MONTHLY_DATA.map((d) => d.revenue));

  return (
    <div className="p-6 space-y-6">
      <SectionHeader title="অ্যানালিটিক্স" />

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard label="মাসিক আয়" value="৳৬৭,০০০" icon={TrendingUp} color="bg-green-500/10 text-green-400" trend="+১৫.৫%" />
        <StatCard label="মোট অর্ডার" value="১,২৩৪" icon={ShoppingCart} color="bg-blue-500/10 text-blue-400" trend="+৮.২%" />
        <StatCard label="নতুন গ্রাহক" value="১৮৯" icon={Users} color="bg-purple-500/10 text-purple-400" trend="+১২.৩%" />
        <StatCard label="গড় অর্ডার মূল্য" value="৳৫৪৩" icon={BarChart3} color="bg-yaru-orange/10 text-yaru-orange" trend="+৩.১%" />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Revenue Chart */}
        <div className="bg-[#2D2D2D] rounded-xl border border-white/10 p-5">
          <h2 className="text-sm font-semibold text-white font-bangla mb-4">মাসিক আয়</h2>
          <div className="flex items-end gap-3 h-48">
            {MONTHLY_DATA.map((d) => (
              <div key={d.month} className="flex-1 flex flex-col items-center gap-2">
                <div className="text-xs text-white/40">৳{(d.revenue / 1000).toFixed(0)}k</div>
                <div
                  className="w-full bg-yaru-orange/80 rounded-t-lg transition-all"
                  style={{ height: `${(d.revenue / maxRevenue) * 140}px` }}
                />
                <div className="text-xs text-white/40 font-bangla">{d.month}</div>
              </div>
            ))}
          </div>
        </div>

        {/* Category Breakdown */}
        <div className="bg-[#2D2D2D] rounded-xl border border-white/10 p-5">
          <h2 className="text-sm font-semibold text-white font-bangla mb-4">ক্যাটাগরি অনুযায়ী বিক্রি</h2>
          <div className="space-y-3">
            {CATEGORY_BREAKDOWN.map((c) => (
              <div key={c.name}>
                <div className="flex justify-between text-sm mb-1">
                  <span className="text-white/60 font-bangla">{c.name}</span>
                  <span className="text-white font-semibold">{c.percentage}%</span>
                </div>
                <div className="h-2 bg-white/5 rounded-full overflow-hidden">
                  <div className={`h-full ${c.color} rounded-full`} style={{ width: `${c.percentage}%` }} />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
