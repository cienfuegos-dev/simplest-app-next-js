import '../styles/globals.css'
import type { AppProps } from 'next/app'
import Script from 'next/script';

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <>
      <Script src="/env-inject/env-inject.js" strategy="beforeInteractive" />
      <Component {...pageProps} />
    </>
  );
}

export default MyApp
