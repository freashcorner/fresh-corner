import { collection, getDocs, query, where, orderBy, limit } from "firebase/firestore";
import { db } from "@/lib/firebase";
import ProductCard from "@/components/product/ProductCard";
import Link from "next/link";

async function getHomeData() {
  const [catsSnap, featuredSnap, productsSnap] = await Promise.all([
    getDocs(query(collection(db, "categories"), where("isActive", "==", true), orderBy("order"), limit(10))),
    getDocs(query(collection(db, "products"), where("isActive", "==", true), where("isFeatured", "==", true), limit(6))),
    getDocs(query(collection(db, "products"), where("isActive", "==", true), orderBy("createdAt", "desc"), limit(12))),
  ]);
  return {
    categories: catsSnap.docs.map((d) => ({ id: d.id, ...d.data() })) as any[],
    featured: featuredSnap.docs.map((d) => ({ id: d.id, ...d.data() })) as any[],
    products: productsSnap.docs.map((d) => ({ id: d.id, ...d.data() })) as any[],
  };
}

export default async function HomePage() {
  const { categories, featured, products } = await getHomeData();

  return (
    <div>
      {/* Hero Banner */}
      <div className="bg-gradient-to-br from-[#1A4731] via-[#27AE60] to-[#2ECC71] px-4 pt-4 pb-8">
        <div className="text-white/70 text-xs font-bangla mb-1">স্বাগতম</div>
        <h1 className="text-2xl font-bold text-white font-tiro mb-1">তাজা বাজার</h1>
        <p className="text-white/70 text-sm font-bangla">তাজা শাকসবজি, ফল ও মুদিখানা</p>
        {/* Search */}
        <div className="mt-4 bg-white rounded-xl px-4 py-2.5 flex items-center gap-2 shadow-lg">
          <span className="text-gray-400 text-sm">🔍</span>
          <span className="text-gray-400 text-sm font-bangla">পণ্য খুঁজুন...</span>
        </div>
      </div>

      <div className="px-4 -mt-4">
        {/* Categories */}
        <div className="bg-white rounded-2xl p-4 shadow-sm mb-4">
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-sm font-bold text-gray-800 font-bangla">ক্যাটাগরি</h2>
            <Link href="/categories" className="text-[#2ECC71] text-xs font-bangla">সব দেখুন</Link>
          </div>
          <div className="grid grid-cols-4 gap-3">
            {categories.slice(0, 8).map((c: any) => (
              <Link key={c.id} href={`/category/${c.slug}`} className="flex flex-col items-center gap-1.5">
                <div className="w-14 h-14 bg-[#D5F5E3] rounded-xl flex items-center justify-center text-2xl">
                  {c.icon || "🛒"}
                </div>
                <span className="text-[10px] font-semibold text-gray-600 font-bangla text-center">{c.name}</span>
              </Link>
            ))}
          </div>
        </div>

        {/* Featured */}
        {featured.length > 0 && (
          <div className="mb-4">
            <h2 className="text-sm font-bold text-gray-800 font-bangla mb-3">বিশেষ অফার</h2>
            <div className="grid grid-cols-2 gap-3">
              {featured.map((p: any) => (
                <ProductCard key={p.id} {...p} />
              ))}
            </div>
          </div>
        )}

        {/* All Products */}
        <div className="mb-4">
          <h2 className="text-sm font-bold text-gray-800 font-bangla mb-3">সব পণ্য</h2>
          <div className="grid grid-cols-2 gap-3">
            {products.map((p: any) => (
              <ProductCard key={p.id} {...p} />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
