import React, {useState, useCallback} from 'react';
import {Tags} from '@site/src/data/featuredTags';
import type {TagType} from '@site/src/data/featuredTags';
import styles from './styles.module.css';

interface FeaturedFiltersProps {
  selectedTags: TagType[];
  operator: 'OR' | 'AND';
  searchQuery: string;
  onTagsChange: (tags: TagType[]) => void;
  onOperatorChange: (op: 'OR' | 'AND') => void;
  onSearchChange: (q: string) => void;
}

export function FeaturedFilters({
  selectedTags,
  operator,
  searchQuery,
  onTagsChange,
  onOperatorChange,
  onSearchChange,
}: FeaturedFiltersProps): React.JSX.Element {
  const toggleTag = useCallback(
    (tag: TagType) => {
      if (selectedTags.includes(tag)) {
        onTagsChange(selectedTags.filter((t) => t !== tag));
      } else {
        onTagsChange([...selectedTags, tag]);
      }
    },
    [selectedTags, onTagsChange],
  );

  const clearAll = useCallback(() => {
    onTagsChange([]);
    onSearchChange('');
  }, [onTagsChange, onSearchChange]);

  return (
    <div className={styles.filters}>
      <div className={styles.searchWrapper}>
        <input
          type="search"
          placeholder="Search featured appearances..."
          value={searchQuery}
          onChange={(e) => onSearchChange(e.target.value)}
          className={styles.searchInput}
        />
      </div>

      <div className={styles.tagSelect}>
        {(Object.keys(Tags) as TagType[]).map((tagKey) => (
          <button
            key={tagKey}
            onClick={() => toggleTag(tagKey)}
            className={`${styles.tagButton} ${
              selectedTags.includes(tagKey) ? styles.tagButtonActive : ''
            }`}>
            {Tags[tagKey].label}
          </button>
        ))}
      </div>

      <div className={styles.operatorToggle}>
        <button
          className={`${styles.operatorButton} ${
            operator === 'OR' ? styles.operatorButtonActive : ''
          }`}
          onClick={() => onOperatorChange('OR')}>
          Any
        </button>
        <button
          className={`${styles.operatorButton} ${
            operator === 'AND' ? styles.operatorButtonActive : ''
          }`}
          onClick={() => onOperatorChange('AND')}>
          All
        </button>
      </div>

      <button onClick={clearAll} className={styles.clearButton}>
        Clear
      </button>
    </div>
  );
}