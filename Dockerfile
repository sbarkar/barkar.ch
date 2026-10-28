# Multi-stage build: build the static export with Node + Yarn, serve it with nginx
# Stage 1: Dependencies
FROM node:20-alpine AS deps

WORKDIR /app

# Yarn 1.22 ships with the official Node images (matches "packageManager" in package.json)
COPY package.json yarn.lock ./

# Install dependencies with frozen lockfile
RUN yarn install --frozen-lockfile --production=false

# Stage 2: Builder
FROM node:20-alpine AS builder

WORKDIR /app

# Copy node_modules from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build the static export (next.config.js sets output: "export" -> ./out)
RUN yarn build

# Stage 3: Runner — static file server
FROM nginx:1.27-alpine AS runner

COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/out /usr/share/nginx/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q --spider http://127.0.0.1/ || exit 1
