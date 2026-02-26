import { useEffect, useState } from "react";
import api from "../lib/api";
import toast from "react-hot-toast";

interface User { id: string; name: string; phone: string; role: string; isActive: boolean; createdAt: any; }

export default function Users() {
  const [users, setUsers] = useState<User[]>([]);

  async function load() {
    const res = await api.get("/api/users");
    setUsers(res.data || []);
  }

  useEffect(() => { load(); }, []);

  async function changeRole(id: string, role: string) {
    try {
      await api.patch(`/api/users/${id}/role`, { role });
      toast.success("রোল পরিবর্তন হয়েছে");
      load();
    } catch {
      toast.error("সমস্যা হয়েছে");
    }
  }

  const ROLE_COLORS: Record<string, string> = {
    admin: "bg-yaru-orange/15 text-yaru-orange",
    customer: "bg-green-500/15 text-green-400",
    rider: "bg-blue-500/15 text-blue-400",
  };

  return (
    <div className="p-6">
      <h1 className="text-xl font-semibold text-white font-bangla mb-6">ব্যবহারকারী ({users.length})</h1>
      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">নাম</th>
              <th className="text-left px-4 py-3 font-bangla">ফোন</th>
              <th className="text-left px-4 py-3 font-bangla">রোল</th>
              <th className="text-left px-4 py-3 font-bangla">পরিবর্তন</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {users.map((u) => (
              <tr key={u.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white font-bangla">{u.name}</td>
                <td className="px-4 py-3 text-white/60">{u.phone}</td>
                <td className="px-4 py-3">
                  <span className={`text-xs px-2 py-1 rounded-full ${ROLE_COLORS[u.role] || "bg-white/10 text-white/60"}`}>{u.role}</span>
                </td>
                <td className="px-4 py-3">
                  <select value={u.role} onChange={(e) => changeRole(u.id, e.target.value)}
                    className="bg-[#3C3C3C] border border-white/10 rounded-lg px-2 py-1 text-xs text-white outline-none">
                    <option value="customer">customer</option>
                    <option value="admin">admin</option>
                    <option value="rider">rider</option>
                  </select>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
