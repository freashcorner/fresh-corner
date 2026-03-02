import { ReactNode } from "react";

interface Column<T> {
  key: string;
  label: string;
  render: (item: T) => ReactNode;
  className?: string;
}

interface DataTableProps<T> {
  columns: Column<T>[];
  data: T[];
  keyField: string;
  emptyText?: string;
  onRowClick?: (item: T) => void;
}

export default function DataTable<T extends Record<string, any>>({ columns, data, keyField, emptyText = "কোনো তথ্য নেই", onRowClick }: DataTableProps<T>) {
  return (
    <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b border-white/10 text-white/40 text-xs">
            {columns.map((col) => (
              <th key={col.key} className={`text-left px-4 py-3 font-bangla ${col.className || ""}`}>{col.label}</th>
            ))}
          </tr>
        </thead>
        <tbody className="divide-y divide-white/5">
          {data.length === 0 && (
            <tr><td colSpan={columns.length} className="text-center py-8 text-white/30 font-bangla">{emptyText}</td></tr>
          )}
          {data.map((item) => (
            <tr key={item[keyField]} className={`hover:bg-white/3 ${onRowClick ? "cursor-pointer" : ""}`} onClick={() => onRowClick?.(item)}>
              {columns.map((col) => (
                <td key={col.key} className={`px-4 py-3 ${col.className || ""}`}>{col.render(item)}</td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
