const STATUS_STYLES: Record<string, string> = {
  pending: "bg-blue-500/15 text-blue-400",
  confirmed: "bg-yellow-500/15 text-yellow-400",
  processing: "bg-purple-500/15 text-purple-400",
  shipped: "bg-cyan-500/15 text-cyan-400",
  delivered: "bg-green-500/15 text-green-400",
  cancelled: "bg-red-500/15 text-red-400",
  returned: "bg-orange-500/15 text-orange-400",
  active: "bg-green-500/15 text-green-400",
  inactive: "bg-red-500/15 text-red-400",
  approved: "bg-green-500/15 text-green-400",
  rejected: "bg-red-500/15 text-red-400",
  open: "bg-blue-500/15 text-blue-400",
  closed: "bg-white/10 text-white/40",
  resolved: "bg-green-500/15 text-green-400",
  online: "bg-green-500/15 text-green-400",
  offline: "bg-white/10 text-white/40",
  busy: "bg-yellow-500/15 text-yellow-400",
  paid: "bg-green-500/15 text-green-400",
  unpaid: "bg-red-500/15 text-red-400",
};

const STATUS_LABEL: Record<string, string> = {
  pending: "অপেক্ষমান",
  confirmed: "নিশ্চিত",
  processing: "প্রস্তুত হচ্ছে",
  shipped: "পাঠানো হয়েছে",
  delivered: "পৌঁছে গেছে",
  cancelled: "বাতিল",
  returned: "ফেরত",
  active: "সক্রিয়",
  inactive: "নিষ্ক্রিয়",
  approved: "অনুমোদিত",
  rejected: "প্রত্যাখ্যাত",
  open: "চলমান",
  closed: "বন্ধ",
  resolved: "সমাধান",
  online: "অনলাইন",
  offline: "অফলাইন",
  busy: "ব্যস্ত",
  paid: "পরিশোধিত",
  unpaid: "অপরিশোধিত",
};

interface StatusBadgeProps {
  status: string;
  label?: string;
}

export default function StatusBadge({ status, label }: StatusBadgeProps) {
  return (
    <span className={`text-xs px-2 py-1 rounded-full font-bangla ${STATUS_STYLES[status] || "bg-white/10 text-white/60"}`}>
      {label || STATUS_LABEL[status] || status}
    </span>
  );
}
