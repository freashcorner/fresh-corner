import { useEffect, useState } from "react";
import api from "../lib/api";
import { AlertTriangle, Package, XCircle } from "lucide-react";
import StatCard from "../components/StatCard";
import SectionHeader from "../components/SectionHeader";
import SearchField from "../components/SearchField";

interface Product {
  id: string;
  name: string;
  stock: number;
  unit: string;
  price: number;
  categoryId: string;
}

export default function Inventory() {
  const [products, setProducts] = useState<Product[]>([]);
  const [search, setSearch] = useState("");
  const [filter, setFilter] = useState<"all" | "low" | "out">("all");

  useEffect(() => {
    api.get("/api/products").then((res) => setProducts(res.data.products || []));
  }, []);

  const lowStock = products.filter((p) => p.stock > 0 && p.stock <= 10);
  const outOfStock = products.filter((p) => p.stock === 0);

  const filtered = products.filter((p) => {
    if (filter === "low" && !(p.stock > 0 && p.stock <= 10)) return false;
    if (filter === "out" && p.stock !== 0) return false;
    if (search && !p.name.toLowerCase().includes(search.toLowerCase())) return false;
    return true;
  });

  return (
    <div className="p-6 space-y-6">
      <SectionHeader title="ইনভেন্টরি" count={products.length}>
        <SearchField value={search} onChange={setSearch} placeholder="পণ্য খুঁজুন..." />
      </SectionHeader>

      <div className="grid grid-cols-3 gap-4">
        <StatCard label="মোট পণ্য" value={products.length} icon={Package} color="bg-blue-500/10 text-blue-400" />
        <StatCard label="কম স্টক" value={lowStock.length} icon={AlertTriangle} color="bg-yellow-500/10 text-yellow-400" />
        <StatCard label="স্টক নেই" value={outOfStock.length} icon={XCircle} color="bg-red-500/10 text-red-400" />
      </div>

      <div className="flex gap-2">
        {(["all", "low", "out"] as const).map((f) => (
          <button key={f} onClick={() => setFilter(f)} className={`text-xs px-3 py-1.5 rounded-lg font-bangla transition-colors ${filter === f ? "bg-yaru-orange text-white" : "bg-white/8 text-white/60"}`}>
            {f === "all" ? "সব" : f === "low" ? "কম স্টক" : "স্টক নেই"}
          </button>
        ))}
      </div>

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">পণ্য</th>
              <th className="text-left px-4 py-3 font-bangla">মূল্য</th>
              <th className="text-left px-4 py-3 font-bangla">স্টক</th>
              <th className="text-left px-4 py-3 font-bangla">ইউনিট</th>
              <th className="text-left px-4 py-3 font-bangla">অবস্থা</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {filtered.length === 0 && (
              <tr><td colSpan={5} className="text-center py-8 text-white/30 font-bangla">কোনো পণ্য নেই</td></tr>
            )}
            {filtered.map((p) => (
              <tr key={p.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white font-bangla">{p.name}</td>
                <td className="px-4 py-3 text-white">৳{p.price}</td>
                <td className="px-4 py-3 text-white font-semibold">{p.stock}</td>
                <td className="px-4 py-3 text-white/60">{p.unit}</td>
                <td className="px-4 py-3">
                  {p.stock === 0 ? (
                    <span className="text-xs px-2 py-1 rounded-full bg-red-500/15 text-red-400 font-bangla">স্টক নেই</span>
                  ) : p.stock <= 10 ? (
                    <span className="text-xs px-2 py-1 rounded-full bg-yellow-500/15 text-yellow-400 font-bangla">কম স্টক</span>
                  ) : (
                    <span className="text-xs px-2 py-1 rounded-full bg-green-500/15 text-green-400 font-bangla">পর্যাপ্ত</span>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
