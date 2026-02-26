import { useState } from "react";
import { signInWithEmailAndPassword } from "firebase/auth";
import { auth } from "../lib/firebase";
import { useNavigate } from "react-router-dom";
import toast from "react-hot-toast";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    try {
      const cred = await signInWithEmailAndPassword(auth, email, password);
      const token = await cred.user.getIdTokenResult();
      if (token.claims.role !== "admin") {
        await auth.signOut();
        toast.error("Admin access only");
        return;
      }
      navigate("/");
    } catch {
      toast.error("ইমেইল বা পাসওয়ার্ড ভুল");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="min-h-screen bg-[#1C1C1C] flex items-center justify-center">
      <div className="w-full max-w-sm">
        <div className="bg-[#2D2D2D] rounded-xl p-8 border border-white/10">
          <div className="text-center mb-8">
            <div className="w-14 h-14 bg-yaru-orange rounded-xl flex items-center justify-center mx-auto mb-4 text-white font-bold text-xl">FC</div>
            <h1 className="text-xl font-semibold text-white font-bangla">ফ্রেশ কর্নার</h1>
            <p className="text-white/40 text-sm mt-1">Admin Panel</p>
          </div>

          <form onSubmit={handleLogin} className="space-y-4">
            <div>
              <label className="block text-xs text-white/50 mb-1.5">ইমেইল</label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2.5 text-sm text-white outline-none focus:border-yaru-orange transition-colors"
                placeholder="admin@freshcorner.com"
                required
              />
            </div>
            <div>
              <label className="block text-xs text-white/50 mb-1.5">পাসওয়ার্ড</label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2.5 text-sm text-white outline-none focus:border-yaru-orange transition-colors"
                placeholder="••••••••"
                required
              />
            </div>
            <button
              type="submit"
              disabled={loading}
              className="w-full bg-yaru-orange hover:bg-yaru-orange-light disabled:opacity-50 text-white font-semibold py-2.5 rounded-lg transition-colors font-bangla"
            >
              {loading ? "লগইন হচ্ছে..." : "লগইন"}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
