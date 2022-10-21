import type {GetServerSideProps, NextPage} from 'next'
import Head from 'next/head'
import {APP_HOSTNAME, APP_VERSION_SHA} from '../env'
import styles from '../styles/Home.module.css'
import {EnvCard} from '../components/EnvCard'

// The run-time-injected variables won't work on pre-backed pages because of the 'Automatic Static Optimization' (see https://nextjs.org/docs/advanced-features/automatic-static-optimization).
// In order to disable that behavior and be able to consume and render run-time-injected vars, we need to disable Automatic Static Optimization just by exporting the function getServerSideProps.
export const getServerSideProps: GetServerSideProps = async () => ({ props: {} });

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
      <Head>
        <title>Create Next App</title>
        <meta name="description" content="Simplest app env-agnistic-built app." />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Simplest <a href="#">App</a>
        </h1>

        <p className={styles.description}>
          Version:{' '}<code className={styles.code}>{APP_VERSION_SHA}</code>
        </p>

        <div className={styles.grid}>
          <div className={styles.card}>
            <EnvCard />
          </div>
        </div>
        <code>Hostname: {APP_HOSTNAME}</code>
      </main>
    </div>
  )
}

export default Home
