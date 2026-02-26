import { useEffect, useState } from "react";
import api from "../lib/api";
import toast from "react-hot-toast";
import { Plus, Pencil, Trash2, X } from "lucide-react";

interface Product {
  id: string;
  name: string;
  price: number;
  discountPrice?: number;
  unit: string;
  stock: number;
  categoryId: string;
  imageUrl: string;
  imagePublicId: string;
  isActive: boolean;
}

interface Category { id: string; name: string; }

export default function Products() {
  const [products, setProducts] = useState<Product[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [modal, setModal] = useState(false);
  const [editing, setEditing] = useState<Product | null>(null);
  const [imageFile, setImageFile] = useState<File | null>(null);
  const [form, setForm] = useState({ name: "", price: "", discountPrice: "", unit: "kg", stock: "", categoryId: "" });
  const [loading, setLoading] = useState(false);

  async function load() {
    const [p, c] = await Promise.all([api.get("/api/products"), api.get("/api/categories")]);
    setProducts(p.data.products || []);
    setCategories(c.data || []);
  }

  useEffect(() => { load(); }, []);

  function openCreate() {
    setEditing(null);
    setForm({ name: "", price: "", discountPrice: "", unit: "kg", stock: "", categoryId: "" });
    setImageFile(null);
    setModal(true);
  }

  function openEdit(p: Product) {
    setEditing(p);
    setForm({ name: p.name, price: String(p.price), discountPrice: String(p.discountPrice || ""), unit: p.unit, stock: String(p.stock), categoryId: p.categoryId });
    setImageFile(null);
    setModal(true);
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    try {
      let imageUrl = editing?.imageUrl || "";
      let imagePublicId = editing?.imagePublicId || "";

      if (imageFile) {
        const fd = new FormData();
        fd.append("image", imageFile);
        const uploadRes = await api.post("/api/upload/product", fd, { headers: { "Content-Type": "multipart/form-data" } });
        imageUrl = uploadRes.data.url;
        imagePublicId = uploadRes.data.publicId;
      }

      const payload = {
        ...form,
        price: Number(form.price),
        discountPrice: form.discountPrice ? Number(form.discountPrice) : undefined,
        stock: Number(form.stock),
        imageUrl,
        imagePublicId,
      };

      if (editing) {
        await api.put(`/api/products/${editing.id}`, payload);
        toast.success("পণ্য আপডেট হয়েছে");
      } else {
        await api.post("/api/products", payload);
        toast.success("পণ্য যোগ হয়েছে");
      }
      setModal(false);
      load();
    } catch {
      toast.error("সমস্যা হয়েছে");
    } finally {
      setLoading(false);
    }
  }

  async function handleDelete(id: string) {
    if (!confirm("পণ্যটি মুছে ফেলবেন?")) return;
    try {
      await api.delete(`/api/products/${id}`);
      toast.success("পণ্য মুছে গেছে");
      load();
    } catch {
      toast.error("সমস্যা হয়েছে");
    }
  }

  return (
    <div className="p-6">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-xl font-semibold text-white font-bangla">পণ্য ({products.length})</h1>
        <button onClick={openCreate} className="flex items-center gap-2 bg-yaru-orange hover:bg-yaru-orange-light text-white text-sm px-4 py-2 rounded-lg transition-colors font-bangla">
          <Plus size={16} /> নতুন পণ্য
        </button>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
        {products.map((p) => (
          <div key={p.id} className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden group">
            <div className="aspect-square bg-[#3C3C3C]">
              {p.imageUrl && <img src={p.imageUrl} alt={p.name} className="w-full h-full object-cover" />}
            </div>
            <div className="p-3">
              <div className="text-sm font-medium text-white font-bangla truncate">{p.name}</div>
              <div className="flex items-center gap-2 mt-1">
                <span className="text-yaru-orange font-semibold text-sm">৳{p.discountPrice || p.price}</span>
                {p.discountPrice && <span className="text-white/30 text-xs line-through">৳{p.price}</span>}
              </div>
              <div className="text-xs text-white/40 font-bangla">স্টক: {p.stock} {p.unit}</div>
              <div className="flex gap-2 mt-3">
                <button onClick={() => openEdit(p)} className="flex-1 flex items-center justify-center gap-1 bg-white/8 hover:bg-white/15 text-white/60 text-xs py-1.5 rounded-lg transition-colors">
                  <Pencil size={12} /> এডিট
                </button>
                <button onClick={() => handleDelete(p.id)} className="flex items-center justify-center w-8 bg-red-500/10 hover:bg-red-500/20 text-red-400 rounded-lg transition-colors">
                  <Trash2 size={12} />
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Modal */}
      {modal && (
        <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4">
          <div className="bg-[#2D2D2D] rounded-xl w-full max-w-md border border-white/10">
            <div className="flex items-center justify-between p-5 border-b border-white/10">
              <h2 className="text-sm font-semibold text-white font-bangla">{editing ? "পণ্য সম্পাদনা" : "নতুন পণ্য"}</h2>
              <button onClick={() => setModal(false)} className="text-white/40 hover:text-white"><X size={18} /></button>
            </div>
            <form onSubmit={handleSubmit} className="p-5 space-y-3">
              <input placeholder="পণ্যের নাম" value={form.name} onChange={(e) => setForm({...form, name: e.target.value})} required className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange font-bangla" />
              <div className="grid grid-cols-2 gap-3">
                <input placeholder="মূল্য" type="number" value={form.price} onChange={(e) => setForm({...form, price: e.target.value})} required className="bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange" />
                <input placeholder="ছাড়ের মূল্য" type="number" value={form.discountPrice} onChange={(e) => setForm({...form, discountPrice: e.target.value})} className="bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange" />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <select value={form.unit} onChange={(e) => setForm({...form, unit: e.target.value})} className="bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange">
                  {["kg", "liter", "piece", "dozen", "pack"].map((u) => <option key={u}>{u}</option>)}
                </select>
                <input placeholder="স্টক" type="number" value={form.stock} onChange={(e) => setForm({...form, stock: e.target.value})} required className="bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange" />
              </div>
              <select value={form.categoryId} onChange={(e) => setForm({...form, categoryId: e.target.value})} required className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange font-bangla">
                <option value="">ক্যাটাগরি বেছে নিন</option>
                {categories.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
              </select>
              <div>
                <label className="block text-xs text-white/40 mb-1.5 font-bangla">পণ্যের ছবি</label>
                <input type="file" accept="image/*" onChange={(e) => setImageFile(e.target.files?.[0] || null)} className="text-sm text-white/60" />
              </div>
              <button type="submit" disabled={loading} className="w-full bg-yaru-orange hover:bg-yaru-orange-light disabled:opacity-50 text-white font-semibold py-2.5 rounded-lg transition-colors font-bangla">
                {loading ? "সংরক্ষণ হচ্ছে..." : editing ? "আপডেট করুন" : "যোগ করুন"}
              </button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
