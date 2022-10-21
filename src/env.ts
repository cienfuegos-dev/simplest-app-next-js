/**
 * Gets an environment variable for an env-agnostic build.
 *
 * Docs say:
 *
 * > Environment variables must be referenced as e.g. process.env.PUBLISHABLE_KEY, not const { PUBLISHABLE_KEY } = process.env.
 *
 * However, in order to achieve an env-agnostic build, we do the opposite, so we never introduce an environment variable
 * into the bundled JS. The only two ways to inject env variables into the code are:
 *  - If the code is running on the server: Via environment variables.
 *  - If the code is running on the browser: Via the env-inject.js file, such file can be modified at deploy time.
 *
 * Important: Never put a sensitive secret in env-inject.js, since anyone with access to the published site can download that file.
 *
 * @param {string} key - Key of the env variable to get.
 * @param {string} $default - Default value if no key is defined.
 */
const getEnv = (key: string, $default = "") => {
  if (typeof window === 'undefined') {
    return process.env[key];
  } else {
    const {envInject} = window as any;
    if (!envInject) throw new Error(`Cannot get property ${key}. Global object 'envInject' is not defined.`);
    if (!envInject.hasOwnProperty(key)) {
      if ($default) {
        return $default;
      }
      throw new Error(`Property '${key}' does not exist in 'envInject' object and no default value was provided.`);
    }
    return envInject[key];
  }
};

export const APP_VERSION = getEnv("APP_VERSION", "local");
export const APP_VERSION_SHA = getEnv("APP_VERSION_SHA", "local");
export const APP_VERSION_BUILD = getEnv("APP_VERSION_BUILD", "local");
export const APP_HOSTNAME = getEnv("APP_HOSTNAME", "local");

export const firebaseConfig = {
  apiKey: getEnv('APP_FIREBASE_API_KEY'),
};

export const exampleApiConfig = {
  apiUrl: getEnv('APP_EXAMPLE_API'),
};
