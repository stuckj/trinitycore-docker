# trinitycore-docker
Docker build configuration for trinitycore

# Usage

You should refer to the trinity core installation guide if you get stuck using this image. It explains in detail how to
setup a trinitycore server:
https://trinitycore.atlassian.net/wiki/spaces/tc/pages/2130077/Installation%2BGuide

This container image is automating the build process and helps with data extraction and DB setup. But, you still need
to do some work. :)

This image is configured to run `worldserver` by default. However, the auth server binary is also in this image so both
may be run by running two instances of this image and changing the command for the auth server instance. See the
example docker-compose.yml below for how you could do this with docker compose.

In addition, there are several pieces of information you must map into the container.
  - worldserver data (see Data Extraction below)
  - `authserver.conf` and `worldserver.conf` configurations. You can see examples of these inside the `/etc` directory
    in the image. Use `run-shell.sh` from this repository to see the example config files in the image.
  - The latest SQL initialization script from the trinitycore source (you can get that here: https://github.com/TrinityCore/TrinityCore/releases). You need to extract it and map in the sql file.

# Data Extraction

The image does not contain the data from the client. You must extract this from a client (not provided). Place the
files from a client in a `WorldofWarcraft-3.3.5a` directory under the location this repository is cloned. Make an
empty `data` directory as well. Then, run `extract-data.sh`. This will extract the data from the client and place it in
the `data` directory which you can then map into the `worldserver` container when you run it.

# Docker Compose

Below is an example `docker-compose.yml` you can use to run the auth server, world server, and a mariadb DB.

You should change the `MYSQL_ROOT_PASSWORD` to something secret. You shouldn't need to use this at all, but it protects
your DB to have it not be something predictable.

Also, you must have created a `authserver.conf` and `worldserver.conf` file in a `/etc` sub-directory of where ever
you're running your docker-compose.

And, you must download the latest DB script from here: https://github.com/TrinityCore/TrinityCore/releases

The TDB SQL file should be extracted to the current directory and you need to change the volume mapping on the last
line of the example `docker-compose.yml` to map that file in instead of the `TDB_full_world_335.20051_2020_05_15.sql`
shown in the example.


```
version: '2'
services:
  database:
    image: mariadb:latest
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=SOME-RANDOM-ROOT-PW
    volumes:
      - ./db:/var/lib/mysql
      - ./db-init:/docker-entrypoint-initdb.d
  authserver:
    image: trinitycore:latest
    restart: unless-stopped
    depends_on:
      - database
    ports:
      - "3724:3724"
    volumes:
      - ./data:/home/trinitycore/data
      - ./etc/authserver.conf:/home/trinitycore/etc/authserver.conf
    command: [ "/home/trinitycore/bin/authserver" ]
  worldserver:
    image: trinitycore:latest
    restart: unless-stopped
    stdin_open: true
    tty: true
    depends_on:
      - database
      - authserver
    ports:
      - "8085:8085"
    volumes:
      - ./data:/home/trinitycore/data
      - ./etc/worldserver.conf:/home/trinitycore/etc/worldserver.conf
      - ./TDB_full_world_335.20051_2020_05_15.sql:/home/trinitycore/TDB_full_world_335.20051_2020_05_15.sql
```

