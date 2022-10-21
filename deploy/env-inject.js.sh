# Environment JS template
cat  << EOF
window.envInject = {
    APP_VERSION: "${APP_VERSION?}",
    APP_VERSION_SHA: "${APP_VERSION_SHA?}",
    APP_VERSION_BUILD: "${APP_VERSION_BUILD?}",
    APP_HOSTNAME: "${APP_HOSTNAME?}",
    FIREBASE_API_KEY: "${FIREBASE_API_KEY?}",
    EXAMPLE_API: "${EXAMPLE_API?}",
};
EOF
