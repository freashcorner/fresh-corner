"use client";
import { useEffect, useState } from "react";
import { collection, getDocs, query, where, orderBy, limit } from "firebase/firestore";
import { db } from "@/lib/firebase";

export interface Product {
  id: string;
  name: string;
  price: number;
  discountPrice?: number;
  unit: string;
  stock: number;
  categoryId: string;
  imageUrl?: string;
  isActive: boolean;
  isFeatured?: boolean;
  description?: string;
}

export interface Category {
  id: string;
  name: string;
  icon?: string;
  slug: string;
  order: number;
  isActive: boolean;
}

export function useProducts(categoryId?: string) {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetch() {
      try {
        const q = categoryId
          ? query(collection(db, "products"), where("isActive", "==", true), where("categoryId", "==", categoryId))
          : query(collection(db, "products"), where("isActive", "==", true));
        const snap = await getDocs(q);
        setProducts(snap.docs.map((d) => ({ id: d.id, ...d.data() }) as Product));
      } catch (e) {
        console.error(e);
      } finally {
        setLoading(false);
      }
    }
    fetch();
  }, [categoryId]);

  return { products, loading };
}

export function useCategories() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getDocs(query(collection(db, "categories"), where("isActive", "==", true), orderBy("order")))
      .then((snap) => setCategories(snap.docs.map((d) => ({ id: d.id, ...d.data() }) as Category)))
      .finally(() => setLoading(false));
  }, []);

  return { categories, loading };
}

export function useFeaturedProducts(max = 8) {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getDocs(query(collection(db, "products"), where("isActive", "==", true), where("isFeatured", "==", true), limit(max)))
      .then((snap) => setProducts(snap.docs.map((d) => ({ id: d.id, ...d.data() }) as Product)))
      .finally(() => setLoading(false));
  }, [max]);

  return { products, loading };
}
