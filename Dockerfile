# ============================
# 1. BUILD STAGE
# ============================
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json package-lock.json* yarn.lock* ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy seluruh file project
COPY . .

# Build Next.js (output mode: standalone)
RUN npm run build


# ============================
# 2. RUNNER STAGE
# ============================
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# Copy hasil build dari stage sebelumnya
COPY --from=builder /app/package.json ./
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

# Expose port
EXPOSE 3000

# Jalankan Next.js
CMD ["node", "server.js"]