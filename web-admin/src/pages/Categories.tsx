import { useEffect, useState } from "react";
import api from "../lib/api";
import toast from "react-hot-toast";
import { Plus, Pencil, Trash2, X } from "lucide-react";

interface Category { id: string; name: string; slug: string; icon?: string; imageUrl?: string; imagePublicId?: string; order: number; isActive: boolean; }

export default function Categories() {
  const [cats, setCats] = useState<Category[]>([]);
  const [modal, setModal] = useState(false);
  const [editing, setEditing] = useState<Category | null>(null);
  const [form, setForm] = useState({ name: "", slug: "", icon: "", order: "1" });
  const [imageFile, setImageFile] = useState<File | null>(null);
  const [loading, setLoading] = useState(false);

  async function load() {
    const res = await api.get("/api/categories");
    setCats(res.data || []);
  }

  useEffect(() => { load(); }, []);

  function openCreate() {
    setEditing(null);
    setForm({ name: "", slug: "", icon: "", order: String(cats.length + 1) });
    setImageFile(null);
    setModal(true);
  }

  function openEdit(c: Category) {
    setEditing(c);
    setForm({ name: c.name, slug: c.slug, icon: c.icon || "", order: String(c.order) });
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
        const r = await api.post("/api/upload/category", fd, { headers: { "Content-Type": "multipart/form-data" } });
        imageUrl = r.data.url;
        imagePublicId = r.data.publicId;
      }
      const payload = { ...form, order: Number(form.order), imageUrl, imagePublicId };
      if (editing) {
        await api.put(`/api/categories/${editing.id}`, payload);
        toast.success("আপডেট হয়েছে");
      } else {
        await api.post("/api/categories", payload);
        toast.success("ক্যাটাগরি যোগ হয়েছে");
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
    if (!confirm("মুছে ফেলবেন?")) return;
    await api.delete(`/api/categories/${id}`);
    toast.success("মুছে গেছে");
    load();
  }

  return (
    <div className="p-6">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-xl font-semibold text-white font-bangla">ক্যাটাগরি</h1>
        <button onClick={openCreate} className="flex items-center gap-2 bg-yaru-orange hover:bg-yaru-orange-light text-white text-sm px-4 py-2 rounded-lg font-bangla">
          <Plus size={16} /> নতুন ক্যাটাগরি
        </button>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
        {cats.map((c) => (
          <div key={c.id} className="bg-[#2D2D2D] rounded-xl border border-white/10 p-4 text-center">
            {c.imageUrl ? (
              <img src={c.imageUrl} alt={c.name} className="w-12 h-12 rounded-full object-cover mx-auto mb-2" />
            ) : (
              <div className="w-12 h-12 bg-white/8 rounded-full flex items-center justify-center mx-auto mb-2 text-2xl">{c.icon || "🛒"}</div>
            )}
            <div className="text-sm text-white font-bangla">{c.name}</div>
            <div className="flex gap-2 mt-3">
              <button onClick={() => openEdit(c)} className="flex-1 flex items-center justify-center bg-white/8 hover:bg-white/15 text-white/60 text-xs py-1 rounded-lg">
                <Pencil size={12} />
              </button>
              <button onClick={() => handleDelete(c.id)} className="flex-1 flex items-center justify-center bg-red-500/10 hover:bg-red-500/20 text-red-400 text-xs py-1 rounded-lg">
                <Trash2 size={12} />
              </button>
            </div>
          </div>
        ))}
      </div>

      {modal && (
        <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4">
          <div className="bg-[#2D2D2D] rounded-xl w-full max-w-sm border border-white/10">
            <div className="flex items-center justify-between p-5 border-b border-white/10">
              <h2 className="text-sm font-semibold text-white font-bangla">{editing ? "ক্যাটাগরি সম্পাদনা" : "নতুন ক্যাটাগরি"}</h2>
              <button onClick={() => setModal(false)} className="text-white/40 hover:text-white"><X size={18} /></button>
            </div>
            <form onSubmit={handleSubmit} className="p-5 space-y-3">
              <input placeholder="নাম" value={form.name} onChange={(e) => setForm({...form, name: e.target.value})} required className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange font-bangla" />
              <input placeholder="slug (rice, dal...)" value={form.slug} onChange={(e) => setForm({...form, slug: e.target.value})} required className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange" />
              <input placeholder="আইকন (emoji)" value={form.icon} onChange={(e) => setForm({...form, icon: e.target.value})} className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange" />
              <input placeholder="ক্রম" type="number" value={form.order} onChange={(e) => setForm({...form, order: e.target.value})} className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange" />
              <input type="file" accept="image/*" onChange={(e) => setImageFile(e.target.files?.[0] || null)} className="text-sm text-white/60" />
              <button type="submit" disabled={loading} className="w-full bg-yaru-orange disabled:opacity-50 text-white font-semibold py-2.5 rounded-lg font-bangla">
                {loading ? "সংরক্ষণ..." : "সংরক্ষণ করুন"}
              </button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
