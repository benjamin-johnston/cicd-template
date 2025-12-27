import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// Configured for https://github.com/benjamin-johnston/cicd-template
export default defineConfig({
  plugins: [react()],
  // MANDATORY: Vite requires the base path to end with a slash for GitHub Pages
  base: '/cicd-template/', 
  build: {
    outDir: 'dist',
  }
})