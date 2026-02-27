import { collection, getDocs } from "firebase/firestore";
import { db } from "@/lib/firebase";
import ProductClient from "./product-client";

export const dynamicParams = false;

// Revalidate every 1 hour
export const revalidate = 3600;

export async function generateStaticParams() {
  try {
    const querySnapshot = await getDocs(collection(db, "products"));
    const params = querySnapshot.docs.map((doc) => ({
      id: doc.id,
    }));
    return params.length > 0 ? params : [{ id: "default" }];
  } catch (error) {
    console.error("Error generating static params:", error);
    // Return fallback param for static export to work
    return [{ id: "default" }];
  }
}

export default function ProductPage({ params }: { params: { id: string } }) {
  return <ProductClient productId={params.id} />;
}
