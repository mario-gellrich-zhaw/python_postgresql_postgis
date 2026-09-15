-- Shops selling pet articles (food, accessories, etc.).
SELECT
    p.osm_id,
    p.name,
    p.shop,
    p."addr:street",
    p."addr:housenumber",
    p."addr:city",
    p."addr:postcode",
    ST_TRANSFORM(p.way, 4326) AS geom
FROM
    public.planet_osm_point AS p
WHERE
    p.shop = 'pet';
