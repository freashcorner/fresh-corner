import { DollarSign, Users } from "lucide-react";
import StatCard from "../components/StatCard";
import StatusBadge from "../components/StatusBadge";
import SectionHeader from "../components/SectionHeader";

const MOCK_PAYOUTS = [
  { id: "PAY-001", rider: "করিম হাসান", phone: "01712345678", amount: 2500, deliveries: 12, period: "মার্চ ১ সপ্তাহ", status: "paid", date: "২০২৬-০৩-০১" },
  { id: "PAY-002", rider: "জামাল উদ্দিন", phone: "01812345678", amount: 3200, deliveries: 15, period: "মার্চ ১ সপ্তাহ", status: "paid", date: "২০২৬-০৩-০১" },
  { id: "PAY-003", rider: "রাজু আহমেদ", phone: "01912345678", amount: 1800, deliveries: 8, period: "মার্চ ১ সপ্তাহ", status: "pending", date: "২০২৬-০৩-০২" },
  { id: "PAY-004", rider: "সোহেল রানা", phone: "01612345678", amount: 4100, deliveries: 20, period: "ফেব্রুয়ারি ৪ সপ্তাহ", status: "paid", date: "২০২৬-০২-২৮" },
];

export default function Payouts() {
  const totalPaid = MOCK_PAYOUTS.filter((p) => p.status === "paid").reduce((s, p) => s + p.amount, 0);
  const totalPending = MOCK_PAYOUTS.filter((p) => p.status === "pending").reduce((s, p) => s + p.amount, 0);

  return (
    <div className="p-6 space-y-6">
      <SectionHeader title="পেআউট" />

      <div className="grid grid-cols-3 gap-4">
        <StatCard label="মোট পরিশোধিত" value={`৳${totalPaid.toLocaleString()}`} icon={DollarSign} color="bg-green-500/10 text-green-400" />
        <StatCard label="অপেক্ষমান" value={`৳${totalPending.toLocaleString()}`} icon={DollarSign} color="bg-yellow-500/10 text-yellow-400" />
        <StatCard label="রাইডার সংখ্যা" value={new Set(MOCK_PAYOUTS.map((p) => p.rider)).size} icon={Users} color="bg-blue-500/10 text-blue-400" />
      </div>

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">রাইডার</th>
              <th className="text-left px-4 py-3 font-bangla">ফোন</th>
              <th className="text-left px-4 py-3 font-bangla">সময়কাল</th>
              <th className="text-left px-4 py-3 font-bangla">ডেলিভারি</th>
              <th className="text-left px-4 py-3 font-bangla">পরিমাণ</th>
              <th className="text-left px-4 py-3 font-bangla">স্ট্যাটাস</th>
              <th className="text-left px-4 py-3 font-bangla">তারিখ</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {MOCK_PAYOUTS.map((p) => (
              <tr key={p.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white font-bangla">{p.rider}</td>
                <td className="px-4 py-3 text-white/60">{p.phone}</td>
                <td className="px-4 py-3 text-white/60 font-bangla">{p.period}</td>
                <td className="px-4 py-3 text-white">{p.deliveries}</td>
                <td className="px-4 py-3 text-white font-semibold">৳{p.amount.toLocaleString()}</td>
                <td className="px-4 py-3"><StatusBadge status={p.status} /></td>
                <td className="px-4 py-3 text-white/40 text-xs">{p.date}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
