# Install dependencies only when needed
FROM node:17.6.0-alpine AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# If using npm with a `package-lock.json` comment out above and use below instead
# COPY package.json package-lock.json ./
# RUN npm ci

# Rebuild the source code only when needed
FROM node:17.6.0-alpine AS builder

WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry during the build.
ENV NEXT_TELEMETRY_DISABLED 1

ENV CI="true"
RUN yarn build

# If using npm comment out above and use below instead
# RUN npm run build

# Production image, copy all the files and run next
FROM node:17.6.0-alpine AS runner
LABEL org.opencontainers.image.source="https://github.com/cienfuegos-dev/simplest-app-next-js"

# Version arguments/variables
ARG VERSION=docker-local
ARG VERSION_SHA=docker-local
ARG VERSION_SHA_BUILD=docker-local
ENV VERSION_INFO__VERSION=${VERSION}
ENV VERSION_INFO__VERSION=${VERSION_SHA_BUILD}

WORKDIR /app

ENV NODE_ENV production
# Uncomment the following line in case you want to disable telemetry during runtime.
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# You only need to copy next.config.js if you are NOT using the default configuration
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

# Add appropriate permissions to env-inject
COPY --from=builder /app/env-inject.js.sh /app/start.sh ./
RUN chown nextjs:nodejs /app/env-inject.js.sh /app/start.sh
RUN chmod 500 /app/env-inject.js.sh /app/start.sh
RUN (mkdir /app/public/env-inject || :)
RUN chown -R nextjs:nodejs /app/public/env-inject

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000

CMD ["sh", "-c", "/app/start.sh"]

# Build and test locally with:
# docker build -t justaquicktest .
# docker run --rm -it -p 3001:3000 justaquicktest
