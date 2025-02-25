// app/page.tsx
import React from 'react';
import styles from './comingsoon.module.css';

const ComingSoonPage = () => {
  return (
    <div className={styles.container}>
      <div className={styles.content}>
        <h1 className={styles.title}>I&apos;am Launching Soon!</h1>
        <p className={styles.description}>
          Our website is under construction. Follow us on LinkedIn and GitHub for updates.
        </p>
        <div className={styles.socialLinks}>
          <a
            href="https://www.linkedin.com/in/mustafa-onur-cay-54246a260/"
            target="_blank"
            rel="noopener noreferrer"
          >
            LinkedIn
          </a>
          <a
            href="https://github.com/your-username"
            target="_blank"
            rel="noopener noreferrer"
          >
            GitHub
          </a>
        </div>
      </div>
    </div>
  );
};

export default ComingSoonPage;
