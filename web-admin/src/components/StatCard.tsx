import { LucideIcon } from "lucide-react";

interface StatCardProps {
  label: string;
  value: string | number;
  icon: LucideIcon;
  color: string;
  trend?: string;
}

export default function StatCard({ label, value, icon: Icon, color, trend }: StatCardProps) {
  return (
    <div className="bg-[#2D2D2D] rounded-xl p-4 border border-white/10">
      <div className={`w-10 h-10 rounded-lg ${color} flex items-center justify-center mb-3`}>
        <Icon size={18} />
      </div>
      <div className="text-2xl font-bold text-white">{value}</div>
      <div className="text-xs text-white/40 mt-1 font-bangla">{label}</div>
      {trend && <div className="text-xs text-g1 mt-1">{trend}</div>}
    </div>
  );
}
