# Build

FROM node:18-alpine AS base

WORKDIR /app

COPY . /app/

RUN npm ci
RUN npm run build

# Production

FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

RUN apk add --no-cache ffmpeg
RUN apk add --no-cache yt-dlp

COPY --from=base /app/package.json /app/package-lock.json /app/
COPY --from=base /app/stream-crawler/dist /app/dist

RUN npm ci

CMD ["npm", "run", "start"]
