import { collection, getDocs } from "firebase/firestore";
import { db } from "@/lib/firebase";
import ProductClient from "./product-client";

export const dynamicParams = true;

export async function generateStaticParams() {
  try {
    const querySnapshot = await getDocs(collection(db, "products"));
    const params = querySnapshot.docs.map((doc) => ({
      id: doc.id,
    }));
    return params;
  } catch (error) {
    console.error("Error generating static params:", error);
    // Return empty array to allow ISR - pages will be generated on first request
    return [];
  }
}

export default function ProductPage({ params }: { params: { id: string } }) {
  return <ProductClient productId={params.id} />;
}
