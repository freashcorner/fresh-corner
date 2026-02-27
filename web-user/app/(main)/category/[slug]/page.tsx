import { collection, getDocs, query, where } from "firebase/firestore";
import { db } from "@/lib/firebase";
import ProductCard from "@/components/product/ProductCard";
import { ArrowLeft } from "lucide-react";
import Link from "next/link";

async function getCategoryData(slug: string) {
  const catsSnap = await getDocs(query(collection(db, "categories"), where("slug", "==", slug)));
  const cat = catsSnap.docs[0];
  if (!cat) return { category: null, products: [] };

  const productsSnap = await getDocs(
    query(collection(db, "products"), where("categoryId", "==", cat.id), where("isActive", "==", true))
  );
  return {
    category: { id: cat.id, ...cat.data() } as any,
    products: productsSnap.docs.map((d) => ({ id: d.id, ...d.data() })) as any[],
  };
}

export async function generateStaticParams() {
  try {
    const querySnapshot = await getDocs(collection(db, "categories"));
    const params = querySnapshot.docs.map((doc) => ({
      slug: doc.data().slug,
    }));
    return params;
  } catch (error) {
    console.error("Error generating static params:", error);
    return [];
  }
}

export default async function CategoryPage({ params }: { params: { slug: string } }) {
  const { category, products } = await getCategoryData(params.slug);

  if (!category) return <div className="text-center py-16 text-gray-400 font-bangla">ক্যাটাগরি পাওয়া যায়নি</div>;

  return (
    <div className="px-4 py-4">
      <div className="flex items-center gap-3 mb-4">
        <Link href="/" className="w-9 h-9 bg-white rounded-xl shadow flex items-center justify-center">
          <ArrowLeft size={18} className="text-gray-600" />
        </Link>
        <h1 className="text-lg font-bold text-gray-800 font-bangla">{category.name}</h1>
        <span className="text-gray-400 text-sm font-bangla">({products.length}টি পণ্য)</span>
      </div>

      {products.length === 0 ? (
        <div className="text-center py-16 text-gray-400 font-bangla">এই ক্যাটাগরিতে কোনো পণ্য নেই</div>
      ) : (
        <div className="grid grid-cols-2 gap-3">
          {products.map((p: any) => <ProductCard key={p.id} {...p} />)}
        </div>
      )}
    </div>
  );
}
