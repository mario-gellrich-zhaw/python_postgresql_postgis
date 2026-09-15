-- Pub crawl pairs as one set of features: bar points + a connecting line per pair,
-- tagged with 'feature_type' so a GIS client can symbolize points and routes differently.
WITH pairs AS (
    SELECT
        ROW_NUMBER() OVER () AS pair_id,
        a.name AS bar_name_1,
        a.way AS way_1,
        b.name AS bar_name_2,
        b.way AS way_2,
        ST_Distance(
            ST_Transform(a.way, 4326)::geography,
            ST_Transform(b.way, 4326)::geography
        ) AS distance_meters
    FROM
        public.planet_osm_point AS a
    JOIN
        public.planet_osm_point AS b
        ON a.osm_id < b.osm_id
        AND ST_DWithin(
            ST_Transform(a.way, 4326)::geography,
            ST_Transform(b.way, 4326)::geography,
            300
        )
    WHERE
        a.amenity IN ('bar', 'pub')
        AND b.amenity IN ('bar', 'pub')
)
SELECT pair_id, 'bar' AS feature_type, bar_name_1 AS label, distance_meters,
       ST_Transform(way_1, 4326) AS geom
FROM pairs
UNION ALL
SELECT pair_id, 'bar' AS feature_type, bar_name_2 AS label, distance_meters,
       ST_Transform(way_2, 4326) AS geom
FROM pairs
UNION ALL
SELECT pair_id, 'route' AS feature_type, bar_name_1 || ' -> ' || bar_name_2 AS label, distance_meters,
       ST_Transform(ST_MakeLine(way_1, way_2), 4326) AS geom
FROM pairs
ORDER BY
    pair_id, feature_type;
