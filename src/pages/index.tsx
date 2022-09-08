import type { NextPage } from 'next'
import Head from 'next/head'
import { VERSION } from '../config'
import styles from '../styles/Home.module.css'
import dynamic from 'next/dynamic'

const EnvCard = dynamic(
  () => import('../components/EnvCard').then(({ EnvCard }) => EnvCard),
  {
    ssr: false,
    loading: () => <div>getting env...</div>,
  }
);

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
          Simplest App
        </h1>

        <p className={styles.description}>
          Version:{' '}<code className={styles.code}>{VERSION}</code>
        </p>

        <div className={styles.grid}>
          <div className={styles.card}>
            <EnvCard />
          </div>
        </div>
      </main>
    </div>
  )
}

export default Home
