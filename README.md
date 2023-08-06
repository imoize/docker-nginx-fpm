# Nginx-FPM Docker Image

NGINX is a web server that can be also used as a reverse proxy, load balancer, and HTTP cache. Recommended for high-demanding sites due to its ability to provide faster content.

This image based on Alpine Linux with s6-overlay.

[![Github Build Status](https://img.shields.io/github/actions/workflow/status/imoize/docker-nginx-fpm/build.yml?color=458837&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=build&logo=github)](https://github.com/imoize/docker-nginx-fpm/actions?workflow=build)
[![GitHub](https://img.shields.io/static/v1.svg?color=3C79F5&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=imoize&message=GitHub&logo=github)](https://github.com/imoize/docker-nginx-fpm)
[![GitHub Package Repository](https://img.shields.io/static/v1.svg?color=3C79F5&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=imoize&message=GitHub%20Package&logo=github)](https://github.com/imoize/docker-nginx-fpm/pkgs/container/nginx-fpm)
[![Docker Pulls](https://img.shields.io/docker/pulls/imoize/nginx-fpm.svg?color=3C79F5&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/imoize/nginx-fpm)

## Supported Architectures

Multi-platform available trough docker manifest. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list).

Simply pulling using `latest` tag should retrieve the correct image for your arch.

The architectures supported by this image:

| Architecture | Available |
| :----: | :----: |
| x86-64 | ✅ |
| arm64 | ✅ |

## Application Setup

This Nginx-FPM image exposes a volume at `/config` add your web files to `/config/www` for hosting. Content mounted here is served by the default catch-all server block.
  
Modify the nginx, and site config files under `/config` folder as needed . 

## Usage

Here are some example to help you get started creating a container, easiest way to setup is using docker-compose or use docker cli.
- **docker-compose (recommended)**

```yaml
version: "3.9"

services:
  nginx:
    image: imoize/nginx-fpm:latest
    container_name: nginx_fpm
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=Asia/Jakarta
    volumes:
      - /path/to/app/data:/config
    ports:
      - 8080:80
      - 9443:443
    restart: always
```

- **docker cli**

```bash
docker run -d \
  --name=nginx_fpm \
  -e PUID=1001 \
  -e PGID=1001 \
  -e TZ=Asia/Jakarta \
  -p 8080:80 \
  -p 9443:443 \
  -v /path/to/app/data:/config \
  --restart always \
  imoize/nginx-fpm:latest
```

Access your web server in the browser by navigating to http://ip-address:8080 or https://ip-address:9443
## Configuration

### Environment variables

When you start the Nginx image, you can adjust the configuration of the instance by passing one or more environment variables either on the `docker-compose` file or on the `docker run` command line. Please note that some variables are only considered when the container is started for the first time. If you want to add a new environment variable:

- **for `docker-compose` add the variable name and value:**

```yaml
nginx:
...
environment:
- PUID=1001
...
```

- **for manual execution add a `-e` option with each variable and value:**

```bash
docker run -d \
-e PUID=1001 \
imoize/nginx-fpm:latest
```

### Available environment variables:

- `PUID=...` for UserID.
- `PGID=...` for GroupID.
- `TZ=...` specify a timezone see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List). Default: **UTC**
- `S6_VERBOSITY=...` controls the verbosity of s6-rc. Default: **1**
    * 0 will only print errors.
    * 1 will only print warnings and errors.
    * 2 is normally verbose: it will list the service start and stop operations.

### PHP configuration

You can change/override `php.ini `and `www.conf`, by edit or add config to `php-local.ini` and `www2.conf` in `/config/php` folder.
## Volume

### Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the data and config will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should map directory inside container in `/config` path to host directory as data volumes. Application state will persist as long as directory on the host are not removed.

**e.g:** `/path/to/app/data:/config`

`/config` folder contains www content and all relevant configuration files.

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, to avoid this issue you should specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will be solved.

For example: `PUID=1001` and `PGID=1001`, to find yours user `id` and `gid` type `id <your_username>` in terminal.
```bash
  $ id your_username
    uid=1001(user) gid=1001(group) groups=1001(group)
```

## Tips / Info

* Shell access whilst the container is running:
```console
docker exec -it nginx_fpm /bin/bash
```
* To monitor the logs of the container in realtime:
```console
docker logs -f nginx_fpm
```
* Container version number:
```console
docker inspect -f '{{ index .Config.Labels "build_version" }}' nginx_fpm
```
* Image version number:
```console
docker inspect -f '{{ index .Config.Labels "build_version" }}' imoize/nginx-fpm:latest
```
NOTE: `nginx_fpm` is name of the container.
## Upgrade this image

We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull imoize/nginx-fpm:latest
```

or if you're using Docker Compose, update the value of the image property to
`imoize/nginx-fpm:latest`.

#### Step 2: Stop currently running container

Stop the currently running container using this command.

```console
docker stop nginx_fpm
```

or using Docker Compose:

```console
docker-compose stop nginx_fpm
```

#### Step 3: Remove currently running container

Remove the currently running container using this command.

```console
docker rm -v nginx_fpm
```

or using Docker Compose:

```console
docker-compose rm -v nginx_fpm
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
docker run --name nginx_fpm imoize/nginx-fpm:latest
```

or using Docker Compose:

```console
docker-compose up -d nginx_fpm
```

#### Step 5: Remove the old dangling images

You can also remove the old dangling images.

```console
docker image prune
```
NOTE: if volume mapped correctly to a host folder, your `/config` folder and settings will be preserved.

## Contributing
We'd love for you to contribute to this container. You can submitting a [pull request](https://github.com/imoize/docker-nginx-fpm/pulls) with your contribution.

## Issues
If you encountered a problem running this container, you can create an [issue](https://github.com/imoize/docker-nginx-fpm/issues). 