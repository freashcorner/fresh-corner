import { Search } from "lucide-react";

interface SearchFieldProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
}

export default function SearchField({ value, onChange, placeholder = "খুঁজুন..." }: SearchFieldProps) {
  return (
    <div className="relative">
      <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-white/30" />
      <input
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="bg-[#3C3C3C] border border-white/10 rounded-lg pl-9 pr-3 py-2 text-sm text-white outline-none focus:border-yaru-orange w-64 font-bangla"
      />
    </div>
  );
}
