# Create Directory Structure
New-Item -ItemType Directory -Force -Path ".github/workflows"
New-Item -ItemType Directory -Force -Path "src"

# Helper to write clean UTF-8 without BOM (prevents Linux/Vite parsing errors)
function Write-CleanUtf8 {
    param($path, $content)
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $fullPath = Join-Path (Get-Location) $path
    [System.IO.File]::WriteAllText($fullPath, $content, $utf8NoBom)
}

# Create .gitignore
$gitignore = @'
node_modules
dist
.DS_Store
*.local
.env
'@
Write-CleanUtf8 ".gitignore" $gitignore

# Create .gitattributes (Crucial for Windows to Linux compatibility)
$gitattributes = @'
* text=auto eol=lf
*.ps1 text eol=crlf
'@
Write-CleanUtf8 ".gitattributes" $gitattributes

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
Write-CleanUtf8 "package.json" $packageJson

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
Write-CleanUtf8 "tailwind.config.js" $tailwindConfig

# Create postcss.config.js
$postcssConfig = @'
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
'@
Write-CleanUtf8 "postcss.config.js" $postcssConfig

# Create vite.config.js
# FIXED: Using clean UTF8 write to ensure no invisible carriage returns break the path
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
Write-CleanUtf8 "vite.config.js" $viteConfig

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
Write-CleanUtf8 "index.html" $indexHtml

# Create src/index.css
$indexCss = @'
@tailwind base;
@tailwind components;
@tailwind utilities;
'@
Write-CleanUtf8 "src/index.css" $indexCss

# Create GitHub Action Workflow
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
Write-CleanUtf8 ".github/workflows/deploy.yml" $deployYml

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
Write-CleanUtf8 "src/main.jsx" $mainJsx

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
Write-CleanUtf8 "src/App.jsx" $appJsx

Write-Host "`n✅ Files successfully written using Clean UTF-8 (No BOM)!" -ForegroundColor Green

# New Step: Automatically generate package-lock.json
if (Get-Command npm -ErrorAction SilentlyContinue) {
    Write-Host "`n📦 Running 'npm install' to generate package-lock.json..." -ForegroundColor Cyan
    npm install
    Write-Host "`n✅ package-lock.json has been generated." -ForegroundColor Green
} else {
    Write-Host "`n⚠️ 'npm' command not found. Please install Node.js and run 'npm install' manually to generate the lockfile." -ForegroundColor Yellow
}

Write-Host "`nTo ensure GitHub sees these changes and the new lockfile, run the following:" -ForegroundColor White
Write-Host "1. git add ."
Write-Host "2. git commit -m 'fix: add package-lock.json and resolve encoding issues'"
Write-Host "3. git push origin main" -ForegroundColor White