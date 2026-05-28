# ──────────────────────────────────────────
# STAGE 1: builder — construim aplicația React
# ──────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

# ──────────────────────────────────────────
# STAGE 2: runner — servim fișierele cu Nginx
# ──────────────────────────────────────────
FROM nginx:alpine AS runner

# Copiem fișierele construite în folderul Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Copiem configurația Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]