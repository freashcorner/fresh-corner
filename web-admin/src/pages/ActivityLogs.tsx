import SectionHeader from "../components/SectionHeader";

const MOCK_LOGS = [
  { id: 1, user: "আবির হোসেন", action: "পণ্য যোগ করেছেন", target: "বাসমতি চাল ৫কেজি", time: "১০ মিনিট আগে", type: "create" },
  { id: 2, user: "আবির হোসেন", action: "অর্ডার স্ট্যাটাস পরিবর্তন", target: "ORD-2401 → প্রস্তুত", time: "২৫ মিনিট আগে", type: "update" },
  { id: 3, user: "রাকিব হাসান", action: "রাইডার নিযুক্ত করেছেন", target: "ORD-2400 → করিম হাসান", time: "১ ঘণ্টা আগে", type: "update" },
  { id: 4, user: "নাফিসা আক্তার", action: "টিকেট সমাধান করেছেন", target: "TKT-003", time: "২ ঘণ্টা আগে", type: "update" },
  { id: 5, user: "আবির হোসেন", action: "পণ্য মুছে ফেলেছেন", target: "পুরানো আটা ২কেজি", time: "৩ ঘণ্টা আগে", type: "delete" },
  { id: 6, user: "রাকিব হাসান", action: "ক্যাটাগরি যোগ করেছেন", target: "অর্গানিক খাবার", time: "৫ ঘণ্টা আগে", type: "create" },
  { id: 7, user: "আবির হোসেন", action: "ব্যানার আপডেট করেছেন", target: "রমজান স্পেশাল", time: "৬ ঘণ্টা আগে", type: "update" },
  { id: 8, user: "আবির হোসেন", action: "সেটিংস পরিবর্তন", target: "স্টোর খোলা → বন্ধ", time: "১ দিন আগে", type: "update" },
];

const TYPE_COLORS: Record<string, string> = {
  create: "bg-green-500/15 text-green-400",
  update: "bg-blue-500/15 text-blue-400",
  delete: "bg-red-500/15 text-red-400",
};
const TYPE_LABELS: Record<string, string> = { create: "তৈরি", update: "আপডেট", delete: "মুছে ফেলা" };

export default function ActivityLogs() {
  return (
    <div className="p-6">
      <SectionHeader title="অ্যাক্টিভিটি লগ" count={MOCK_LOGS.length} />

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">ব্যবহারকারী</th>
              <th className="text-left px-4 py-3 font-bangla">কার্যক্রম</th>
              <th className="text-left px-4 py-3 font-bangla">বিষয়</th>
              <th className="text-left px-4 py-3 font-bangla">ধরন</th>
              <th className="text-left px-4 py-3 font-bangla">সময়</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {MOCK_LOGS.map((log) => (
              <tr key={log.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white font-bangla">{log.user}</td>
                <td className="px-4 py-3 text-white/60 font-bangla">{log.action}</td>
                <td className="px-4 py-3 text-white/40 font-bangla">{log.target}</td>
                <td className="px-4 py-3">
                  <span className={`text-xs px-2 py-1 rounded-full font-bangla ${TYPE_COLORS[log.type]}`}>{TYPE_LABELS[log.type]}</span>
                </td>
                <td className="px-4 py-3 text-white/40 text-xs font-bangla">{log.time}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
