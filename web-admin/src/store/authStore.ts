import { create } from "zustand";
import { User as FirebaseUser } from "firebase/auth";

interface AuthState {
  user: FirebaseUser | null;
  role: string | null;
  loading: boolean;
  setUser: (user: FirebaseUser | null, role?: string) => void;
  setLoading: (loading: boolean) => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  role: null,
  loading: true,
  setUser: (user, role) => set({ user, role: role || null }),
  setLoading: (loading) => set({ loading }),
}));
