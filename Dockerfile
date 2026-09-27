FROM postgis/postgis

# Update and install dependencies (python3-pip is not needed inside this container)
RUN apt-get update -o Acquire::Retries=5 \
    && apt-get install -y --no-install-recommends osm2pgsql \
    && rm -rf /var/lib/apt/lists/*

# Copy the default.style file needed for osm2pgsql
COPY default.style /usr/bin/

# Download the OpenStreetMap data
ADD https://download.openstreetmap.fr/extracts/europe/switzerland/zurich-latest.osm.pbf /tmp/zurich-latest.osm.pbf
