# Install dependencies only when needed
FROM node:18-alpine3.16 AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# If using npm with a `package-lock.json` comment out above and use below instead
# COPY package.json package-lock.json ./
# RUN npm ci

####################################################################################################

# Rebuild the source code only when needed
FROM node:18-alpine3.16 AS builder
ENV NODE_ENV production

WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY ./public ./public
COPY ./src ./src
COPY .eslintrc.json next-env.d.ts next.config.js package.json tsconfig.json yarn.lock ./

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry during the build.
ENV NEXT_TELEMETRY_DISABLED 1

ENV CI="true"
RUN yarn build

# If using npm comment out above and use below instead
# RUN npm run build

####################################################################################################

# Production image, copy all the files and run next
FROM node:18-alpine3.16 AS runner
ENV NODE_ENV production
LABEL org.opencontainers.image.source="https://github.com/cienfuegos-dev/simplest-app-next-js"

# Version arguments/variables
ARG VERSION=docker-local
ARG VERSION_SHA_BUILD=docker-local

# Env vars
ENV VERSION_INFO__VERSION=${VERSION}
ENV VERSION_INFO__BUILD=${VERSION_SHA_BUILD}
ENV FIREBASE_API_KEY=${FIREBASE_API_KEY}
ENV FIREBASE_AUTH_DOMAIN=${FIREBASE_AUTH_DOMAIN}
ENV FIREBASE_PROJECT_ID=${FIREBASE_PROJECT_ID}
ENV FIREBASE_APPID=${FIREBASE_APPID}
ENV FIREBASE_MEASUREMENT_ID=${FIREBASE_MEASUREMENT_ID}
ENV EXAMPLE_API=${EXAMPLE_API}
ENV APP_HOSTNAME=${APP_HOSTNAME}

WORKDIR /app

# Uncomment the following line in case you want to disable telemetry during runtime.
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# You only need to copy next.config.js if you are NOT using the default configuration
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

# Add appropriate permissions to env-inject
COPY --chown=nextjs:nodejs deploy/env-inject.js.sh deploy/start.sh ./deploy/
RUN chmod 500 /app/deploy/env-inject.js.sh /app/deploy/start.sh

# Create folder where to put env-inject generated javascript
RUN (mkdir /app/public/env-inject || :)
RUN chown -R nextjs:nodejs /app/public/env-inject

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000

CMD ["sh", "-c", "/app/deploy/start.sh"]

# Build and test locally with:
# docker build -t justaquicktest .
# docker run --rm -it -p 3000:3000 justaquicktest
