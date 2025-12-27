# Create Directory Structure
New-Item -ItemType Directory -Force -Path ".github/workflows"
New-Item -ItemType Directory -Force -Path "src"

# Create .gitignore
$gitignore = @'
node_modules
dist
.DS_Store
*.local
.env
'@
$gitignore | Out-File -FilePath ".gitignore" -Encoding utf8

# Create .gitattributes (Crucial for Windows to Linux compatibility)
$gitattributes = @'
* text=auto eol=lf
*.ps1 text eol=crlf
'@
$gitattributes | Out-File -FilePath ".gitattributes" -Encoding utf8

# Create package.json
$packageJson = @'
{
  "name": "cicd-template",
  "private": true,
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "lucide-react": "^0.395.0"
  },
  "devDependencies": {
    "@types/react": "^18.3.3",
    "@types/react-dom": "^18.3.0",
    "@vitejs/plugin-react": "^4.3.1",
    "autoprefixer": "^10.4.19",
    "postcss": "^8.4.38",
    "tailwindcss": "^3.4.4",
    "vite": "^5.3.1"
  }
}
'@
$packageJson | Out-File -FilePath "package.json" -Encoding utf8

# Create tailwind.config.js
$tailwindConfig = @'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
'@
$tailwindConfig | Out-File -FilePath "tailwind.config.js" -Encoding utf8

# Create postcss.config.js
$postcssConfig = @'
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
'@
$postcssConfig | Out-File -FilePath "postcss.config.js" -Encoding utf8

# Create vite.config.js
# FIXED: Using Out-File with utf8 and removed trailing spaces
$viteConfig = @'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: '/cicd-template/',
  build: {
    outDir: 'dist',
    emptyOutDir: true
  }
})
'@
$viteConfig | Out-File -FilePath "vite.config.js" -Encoding utf8

# Create index.html
$indexHtml = @'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CICD Template</title>
  </head>
  <body class="bg-slate-900 text-white">
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
'@
$indexHtml | Out-File -FilePath "index.html" -Encoding utf8

# Create src/index.css
$indexCss = @'
@tailwind base;
@tailwind components;
@tailwind utilities;
'@
$indexCss | Out-File -FilePath "src/index.css" -Encoding utf8

# Create GitHub Action Workflow
# Using double-backticks for the variable to avoid PS interpolation
$deployYml = @'
name: Deploy to GitHub Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: true

jobs:
  build_site:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Install Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - name: Install dependencies
        run: npm install
      - name: Build
        run: npm run build
      - name: Upload Artifacts
        uses: actions/upload-pages-artifact@v3
        with:
          path: "./dist"

  deploy:
    needs: build_site
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
'@
$deployYml | Out-File -FilePath ".github/workflows/deploy.yml" -Encoding utf8

# Create src/main.jsx
$mainJsx = @'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
'@
$mainJsx | Out-File -FilePath "src/main.jsx" -Encoding utf8

# Create src/App.jsx
$appJsx = @'
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
'@
$appJsx | Out-File -FilePath "src/App.jsx" -Encoding utf8

Write-Host "✅ Files updated with UTF-8 encoding and .gitattributes!" -ForegroundColor Green