-- After a night out: fast food joints within 300 m of a bar/pub, closest first.
SELECT
    b.osm_id AS bar_osm_id,
    b.name AS bar_name,
    b.amenity AS bar_type,
    f.osm_id AS fastfood_osm_id,
    f.name AS fastfood_name,
    ST_Distance(
        ST_Transform(b.way, 4326)::geography,
        ST_Transform(f.way, 4326)::geography
    ) AS distance_meters,
    ST_Transform(b.way, 4326) AS bar_geom,
    ST_Transform(f.way, 4326) AS fastfood_geom
FROM
    public.planet_osm_point AS b
JOIN
    public.planet_osm_point AS f
    ON ST_DWithin(
        ST_Transform(b.way, 4326)::geography,
        ST_Transform(f.way, 4326)::geography,
        300
    )
WHERE
    b.amenity IN ('bar', 'pub')
    AND f.amenity = 'fast_food'
ORDER BY
    b.name, distance_meters;
