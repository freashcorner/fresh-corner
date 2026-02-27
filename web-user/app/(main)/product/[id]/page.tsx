import { collection, getDocs } from "firebase/firestore";
import { db } from "@/lib/firebase";
import ProductClient from "./product-client";

export async function generateStaticParams() {
  try {
    const querySnapshot = await getDocs(collection(db, "products"));
    const params = querySnapshot.docs.map((doc) => ({
      id: doc.id,
    }));
    return params;
  } catch (error) {
    console.error("Error generating static params:", error);
    return [];
  }
}

export default function ProductPage({ params }: { params: { id: string } }) {
  return <ProductClient productId={params.id} />;
}
