import { ReactNode } from "react";

interface SectionHeaderProps {
  title: string;
  count?: number;
  children?: ReactNode;
}

export default function SectionHeader({ title, count, children }: SectionHeaderProps) {
  return (
    <div className="flex items-center justify-between mb-6">
      <h1 className="text-xl font-semibold text-white font-bangla">
        {title}{count !== undefined && ` (${count})`}
      </h1>
      {children && <div className="flex items-center gap-3">{children}</div>}
    </div>
  );
}
