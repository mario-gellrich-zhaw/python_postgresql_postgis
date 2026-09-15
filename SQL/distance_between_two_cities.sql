SELECT ROUND(
    CAST(ST_Distance(
        -- Winterthur (longitude, latitude)
        ST_GeographyFromText('SRID=4326;POINT(8.7233 47.5034)'),
        -- Zürich (longitude, latitude)
        ST_GeographyFromText('SRID=4326;POINT(8.5417 47.3769)')
    ) / 1000 AS NUMERIC), -- Convert meters to kilometers
    1 -- Round to one decimal place
) AS distance_in_kilometers;