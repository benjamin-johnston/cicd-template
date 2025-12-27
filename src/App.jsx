import React from 'react';
import { Mountain, Rocket, CheckCircle } from 'lucide-react';

export default function App() {
  return (
    <div className="min-h-screen flex items-center justify-center p-6 text-center text-slate-100">
      <div className="max-w-md w-full bg-slate-800 border border-slate-700 p-8 rounded-[2.5rem] shadow-2xl">
        <div className="flex justify-center mb-6">
          <div className="p-4 bg-blue-600 rounded-2xl animate-bounce">
            <Mountain size={40} className="text-white" />
          </div>
        </div>
        <h1 className="text-3xl font-black mb-2">Hello World!</h1>
        <p className="text-slate-400 mb-8 leading-relaxed">
          The Windows CI/CD template is active. 
        </p>
        <div className="space-y-3 text-left">
          <StatusItem icon={<CheckCircle size={18} className="text-emerald-500"/>} text="GitHub Actions Ready" />
          <StatusItem icon={<CheckCircle size={18} className="text-emerald-500"/>} text="React & Vite Structure" />
          <StatusItem icon={<Rocket size={18} className="text-blue-500"/>} text="Template for future projects" />
        </div>
      </div>
    </div>
  );
}

function StatusItem({ icon, text }) {
  return (
    <div className="flex items-center gap-3 bg-slate-900/50 p-3 rounded-xl border border-white/5 text-sm font-medium">
      {icon}
      <span>{text}</span>
    </div>
  );
}