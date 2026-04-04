# ═══════════════════════════════════════════════════════════════════
# Stage 1 — Build
# Uses Node LTS (Alpine) to keep the builder image small.
# Only production-necessary files are copied into stage 2.
# ═══════════════════════════════════════════════════════════════════
FROM node:20-alpine AS builder

# Install dependencies first (separate layer — cached unless package.json changes)
WORKDIR /app
COPY frontend/package*.json ./
RUN npm ci --prefer-offline

# Copy source and build
COPY frontend/ .
RUN npm run build
# Output → /app/dist

# ═══════════════════════════════════════════════════════════════════
# Stage 2 — Serve
# Nginx Alpine image is ~25 MB. Only the compiled dist/ is copied.
# ═══════════════════════════════════════════════════════════════════
FROM nginx:1.27-alpine AS runner

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy our SPA-aware nginx config
COPY nginx.conf /etc/nginx/conf.d/app.conf

# Copy compiled React app from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx runs on port 80 inside the container
EXPOSE 80

# Nginx in foreground (required for Docker)
CMD ["nginx", "-g", "daemon off;"]
