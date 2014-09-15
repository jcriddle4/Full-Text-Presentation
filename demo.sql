
-- This is the demo SQL

------------------------------------------------

SELECT *
FROM books
LIMIT 100;

SELECT *
FROM reviews
  WHERE isbn not like 'zz%'
LIMIT 10;

------------------------------------------------

SELECT *
FROM books
WHERE document ILIKE '%zoo%';

SELECT *
FROM books
WHERE ts @@ to_tsquery('zoo:*');

------------------------------------------------

SELECT *
FROM books
WHERE document ILIKE '% and %';

SELECT *
FROM books
WHERE ts @@ to_tsquery('and:*');

------------------------------------------------

SELECT *
FROM books
WHERE ts @@ to_tsquery('123');

------------------------------------------------

DROP INDEX idx_reviews_full_text;
DROP INDEX idx_reviews_isbn;

--This is a regular index
CREATE INDEX idx_reviews_isbn ON reviews (isbn);

--This is a GIN index
CREATE INDEX idx_reviews_full_text ON reviews     USING GIN(ts);

------------------------------------------------

 SELECT TS_RANK_CD(ts, query) as rank
 , bk.*
 FROM books bk
 , TO_TSQUERY('adams &  hitch:*') query
 WHERE query @@ ts
 ORDER BY rank DESC;

------------------------------------------------

/* NOTE PERFORMANCE: If we use LIMIT and TS_RANK
 * we may end up making expensive calls to
 * TS_HEADLINE() for rows that are not returned.
 * If this is the case then use a subquery first.  */
 SELECT TS_RANK_CD(ts, query) as rank
 , TS_HEADLINE(document,query) as headline
 , bk.*
 FROM books bk
 , TO_TSQUERY('adams & hitch:*') query
 WHERE query @@ ts
 ORDER BY rank DESC;

------------------------------------------------


