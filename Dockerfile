FROM node:20-bookworm-slim

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV SESSION_DIR=/data/session

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates git \
  && rm -rf /var/lib/apt/lists/*

COPY package.json ./
COPY .npmrc ./

RUN npm install --omit=dev --no-audit --no-fund --legacy-peer-deps

# Falha o BUILD (e nao o start) se alguma dependencia nao carregar.
RUN node -e "require('express'); require('qrcode'); require('pino'); require('@supabase/supabase-js'); require('@whiskeysockets/baileys'); console.log('[build] dependencias ok')"

COPY . .

RUN mkdir -p /data/session

EXPOSE 3000

CMD ["node", "index.cjs"]