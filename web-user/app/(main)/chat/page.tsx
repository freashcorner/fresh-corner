"use client";
import { useState } from "react";
import { Send } from "lucide-react";

type Message = { id: number; type: "bot" | "user"; text: string };

const INITIAL_MESSAGES: Message[] = [
  { id: 1, type: "bot", text: "আসসালামু আলাইকুম! 👋 ফ্রেশ কর্নার সাপোর্টে স্বাগতম। আমি কীভাবে সাহায্য করতে পারি?" },
];

export default function ChatPage() {
  const [messages, setMessages] = useState<Message[]>(INITIAL_MESSAGES);
  const [input, setInput] = useState("");

  function handleSend() {
    if (!input.trim()) return;

    const userMsg: Message = { id: Date.now(), type: "user", text: input };
    setMessages((prev) => [...prev, userMsg]);
    setInput("");

    // Simulate bot response
    setTimeout(() => {
      const botMsg: Message = {
        id: Date.now() + 1,
        type: "bot",
        text: "ধন্যবাদ আপনার মেসেজের জন্য! আমাদের একজন প্রতিনিধি শীঘ্রই আপনার সাথে যোগাযোগ করবেন। ইতিমধ্যে, আপনি আমাদের FAQ পেজ দেখতে পারেন।",
      };
      setMessages((prev) => [...prev, botMsg]);
    }, 1000);
  }

  return (
    <div className="chat-container" style={{ paddingTop: '64px' }}>
      <div className="chat-messages">
        {messages.map((msg) => (
          <div key={msg.id} className={`chat-bubble ${msg.type} font-bangla`}>
            {msg.text}
          </div>
        ))}
      </div>

      <div className="chat-input-area">
        <input
          type="text"
          placeholder="মেসেজ লিখুন..."
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={(e) => e.key === "Enter" && handleSend()}
          className="font-bangla"
        />
        <button onClick={handleSend}>
          <Send size={20} />
        </button>
      </div>
    </div>
  );
}
