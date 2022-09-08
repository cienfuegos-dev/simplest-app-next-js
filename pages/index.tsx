import type { NextPage } from 'next'
import Head from 'next/head'
import { BUILD, VERSION } from '../src/config'
import styles from '../styles/Home.module.css'

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
          <br />
          Build:{' '}<code className={styles.code}>{BUILD}</code>
        </p>
      </main>
    </div>
  )
}

export default Home
