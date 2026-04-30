import React, {useState, useMemo, useCallback, useEffect} from 'react';
import {FeaturedFilters} from '@site/src/components/FeaturedFilters';
import {FeaturedCard} from '@site/src/components/FeaturedCard';
import {FeaturedItems} from '@site/src/data/featured';
import type {TagType} from '@site/src/data/featuredTags';
import {Tags} from '@site/src/data/featuredTags';
import type {FeaturedItem} from '@site/src/data/featured';
import Layout from '@theme/Layout';
import Head from '@docusaurus/Head';
import styles from './styles.module.css';

type Operator = 'OR' | 'AND';

function filterItems(
  items: FeaturedItem[],
  selectedTags: TagType[],
  operator: Operator,
  query: string,
): FeaturedItem[] {
  return items.filter((item) => {
    const matchesTags =
      selectedTags.length === 0 ||
      (operator === 'OR'
        ? selectedTags.some((t) => item.tags.includes(t))
        : selectedTags.every((t) => item.tags.includes(t)));

    const matchesQuery =
      query === '' ||
      item.title.toLowerCase().includes(query.toLowerCase()) ||
      item.outlet.toLowerCase().includes(query.toLowerCase()) ||
      item.description.toLowerCase().includes(query.toLowerCase());

    return matchesTags && matchesQuery;
  });
}

function sortItems(items: FeaturedItem[]): FeaturedItem[] {
  return [...items].sort((a, b) => {
    const aFav = a.tags.includes('favorite');
    const bFav = b.tags.includes('favorite');
    if (aFav && !bFav) return -1;
    if (!aFav && bFav) return 1;
    return new Date(b.date).getTime() - new Date(a.date).getTime();
  });
}

function useQueryString<T>(key: string, defaultValue: T): [T, (val: T) => void] {
  const [value, setValue] = useState<T>(() => {
    if (typeof window === 'undefined') return defaultValue;
    const params = new URLSearchParams(window.location.search);
    const raw = params.get(key);
    if (raw === null) return defaultValue;
    try {
      return JSON.parse(raw) as T;
    } catch {
      return defaultValue;
    }
  });

  const setValueWithQS = useCallback(
    (newVal: T) => {
      setValue(newVal);
      const params = new URLSearchParams(window.location.search);
      params.set(key, JSON.stringify(newVal));
      const newUrl = `${window.location.pathname}?${params.toString()}`;
      window.history.pushState({}, '', newUrl);
    },
    [key],
  );

  return [value, setValueWithQS];
}

export default function FeaturedPage(): React.JSX.Element {
  const [selectedTags, setSelectedTags] = useQueryString<TagType[]>('tags', []);
  const [operator, setOperator] = useQueryString<Operator>('operator', 'OR');
  const [searchQuery, setSearchQuery] = useQueryString<string>('q', '');

  const filtered = useMemo(
    () => sortItems(filterItems(FeaturedItems, selectedTags, operator, searchQuery)),
    [selectedTags, operator, searchQuery],
  );

  const updateTags = useCallback((tags: TagType[]) => setSelectedTags(tags), [setSelectedTags]);
  const updateOperator = useCallback((op: Operator) => setOperator(op), [setOperator]);
  const updateQuery = useCallback((q: string) => setSearchQuery(q), [setSearchQuery]);

  return (
    <Layout title="Featured" description="Appearances on other people's platforms.">
      <Head>
        <meta property="og:title" content="Featured" />
        <meta property="og:description" content="Appearances on other people's platforms." />
      </Head>

      <div className="container padding--lg">
        <div className={styles.page}>
          <header className={styles.header}>
            <h1 className={styles.title}>Featured</h1>
            <p className={styles.subtitle}>
              Appearances on podcasts, conferences, interviews, guest posts, and other people's platforms.
            </p>
            <a href="mailto:todo@example.com" className={styles.cta}>
              Suggest an appearance
              <svg
                width="16"
                height="16"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2">
                <path d="M5 12h14M12 5l7 7-7 7" />
              </svg>
            </a>
          </header>

          <FeaturedFilters
            selectedTags={selectedTags}
            operator={operator}
            searchQuery={searchQuery}
            onTagsChange={updateTags}
            onOperatorChange={updateOperator}
            onSearchChange={updateQuery}
          />

          {filtered.length === 0 ? (
            <div className={styles.empty}>
              <p>No featured appearances match your filters.</p>
            </div>
          ) : (
            <div className={styles.grid}>
              {filtered.map((item) => (
                <FeaturedCard key={`${item.title}-${item.date}`} item={item} />
              ))}
            </div>
          )}
        </div>
      </div>
    </Layout>
  );
}