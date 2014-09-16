
-- This is trigrams and it could be used for functionality similar to Google's 'Did you mean....'
create extension pg_trgm;

CREATE TABLE words AS
SELECT * 
FROM ts_stat('SELECT ts FROM books WHERE isbn not like ''zz%'' ');

CREATE INDEX words_idx ON words USING gin(word gin_trgm_ops);

SELECT w.*, similarity(w.word, 'hitcch') as sml
FROM words w
WHERE w.word % 'hitcch'
ORDER BY sml DESC, word
limit 10

