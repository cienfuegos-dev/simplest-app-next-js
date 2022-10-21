# - Generates the env-inject.js using the system env vars
# - Then sets read-only permissions to env-inject.js
# - Starts the server

: \
  && APP_HOSTNAME=$(hostname -f) \
  && (chmod -f 600 /app/public/env-inject/env-inject.js || :) \
  && /app/deploy/env-inject.js.sh > /app/public/env-inject/env-inject.js \
  && echo File env-inject.js generated. \
  && chmod 400 /app/public/env-inject/env-inject.js \
  && node server.js
