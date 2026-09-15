-- Pizza places and their 1000 m "delivery zone" buffer.
SELECT
    p.osm_id,
    p.name,
    p.amenity,
    ST_TRANSFORM(p.way, 4326) AS geom,
    ST_TRANSFORM(ST_Buffer(p.way::geometry, 1000, 'quad_segs=8'), 4326) AS delivery_zone
FROM
    public.planet_osm_point AS p
WHERE
    p.amenity IN ('restaurant', 'fast_food')
    AND p.name ILIKE '%pizza%';
