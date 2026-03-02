import { DollarSign, TrendingUp, TrendingDown, CreditCard } from "lucide-react";
import StatCard from "../components/StatCard";
import SectionHeader from "../components/SectionHeader";

const MOCK_TRANSACTIONS = [
  { id: "TXN-001", type: "order", description: "অর্ডার #ORD-2401", amount: 1250, date: "২০২৬-০৩-০২ ১০:৩০", status: "paid" },
  { id: "TXN-002", type: "refund", description: "রিফান্ড #RET-001", amount: -450, date: "২০২৬-০৩-০১ ১৫:২০", status: "paid" },
  { id: "TXN-003", type: "order", description: "অর্ডার #ORD-2400", amount: 890, date: "২০২৬-০৩-০১ ১২:১০", status: "paid" },
  { id: "TXN-004", type: "payout", description: "রাইডার পেআউট - করিম", amount: -2500, date: "২০২৬-০৩-০১ ০৯:০০", status: "paid" },
  { id: "TXN-005", type: "order", description: "অর্ডার #ORD-2399", amount: 2100, date: "২০২৬-০২-২৮ ১৮:৪৫", status: "unpaid" },
  { id: "TXN-006", type: "order", description: "অর্ডার #ORD-2398", amount: 560, date: "২০২৬-০২-২৮ ১৬:৩০", status: "paid" },
];

const TYPE_LABELS: Record<string, string> = { order: "অর্ডার", refund: "রিফান্ড", payout: "পেআউট" };
const TYPE_COLORS: Record<string, string> = { order: "text-green-400", refund: "text-red-400", payout: "text-yellow-400" };

export default function Finance() {
  const totalRevenue = MOCK_TRANSACTIONS.filter((t) => t.amount > 0).reduce((s, t) => s + t.amount, 0);
  const totalExpense = Math.abs(MOCK_TRANSACTIONS.filter((t) => t.amount < 0).reduce((s, t) => s + t.amount, 0));

  return (
    <div className="p-6 space-y-6">
      <SectionHeader title="ফাইন্যান্স" />

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard label="মোট আয়" value={`৳${totalRevenue.toLocaleString()}`} icon={TrendingUp} color="bg-green-500/10 text-green-400" />
        <StatCard label="মোট ব্যয়" value={`৳${totalExpense.toLocaleString()}`} icon={TrendingDown} color="bg-red-500/10 text-red-400" />
        <StatCard label="নিট আয়" value={`৳${(totalRevenue - totalExpense).toLocaleString()}`} icon={DollarSign} color="bg-yaru-orange/10 text-yaru-orange" />
        <StatCard label="লেনদেন" value={MOCK_TRANSACTIONS.length} icon={CreditCard} color="bg-blue-500/10 text-blue-400" />
      </div>

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <div className="px-5 py-4 border-b border-white/10">
          <h2 className="text-sm font-semibold text-white font-bangla">সাম্প্রতিক লেনদেন</h2>
        </div>
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">আইডি</th>
              <th className="text-left px-4 py-3 font-bangla">বিবরণ</th>
              <th className="text-left px-4 py-3 font-bangla">ধরন</th>
              <th className="text-left px-4 py-3 font-bangla">পরিমাণ</th>
              <th className="text-left px-4 py-3 font-bangla">তারিখ</th>
              <th className="text-left px-4 py-3 font-bangla">স্ট্যাটাস</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {MOCK_TRANSACTIONS.map((t) => (
              <tr key={t.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white/60 font-mono text-xs">{t.id}</td>
                <td className="px-4 py-3 text-white font-bangla">{t.description}</td>
                <td className="px-4 py-3">
                  <span className={`text-xs font-bangla ${TYPE_COLORS[t.type]}`}>{TYPE_LABELS[t.type]}</span>
                </td>
                <td className={`px-4 py-3 font-semibold ${t.amount > 0 ? "text-green-400" : "text-red-400"}`}>
                  {t.amount > 0 ? "+" : ""}৳{Math.abs(t.amount).toLocaleString()}
                </td>
                <td className="px-4 py-3 text-white/40 text-xs">{t.date}</td>
                <td className="px-4 py-3">
                  <span className={`text-xs px-2 py-1 rounded-full ${t.status === "paid" ? "bg-green-500/15 text-green-400" : "bg-red-500/15 text-red-400"} font-bangla`}>
                    {t.status === "paid" ? "পরিশোধিত" : "অপরিশোধিত"}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
