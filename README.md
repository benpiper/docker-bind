- [Introduction](#introduction)
  - [Issues](#issues)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
  - [Persistence](#persistence)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)

# Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image for ARM running the [BIND](https://www.isc.org/downloads/bind/) DNS server.

BIND is open source software that implements the Domain Name System (DNS) protocols for the Internet. It is a reference implementation of those protocols, but it is also production-grade software, suitable for use in high-volume and high-reliability applications.

## Issues

Before reporting your issue please try updating Docker to the latest version and check if it resolves the issue. Refer to the Docker [installation guide](https://docs.docker.com/installation) for instructions.

SELinux users may need to update the security context of the host mountpoint so that it plays nicely with Docker:

```bash
mkdir -p /srv/docker/bind
chcon -Rt svirt_sandbox_file_t /srv/docker/bind
```

If SELinux still gets in the way, you can try disabling it using the command `setenforce 0` to see if it resolves the issue.

If the above recommendations do not help then [report your issue](../../issues/new) along with the following information:

- Output of the `docker version` and `docker info` commands
- The `docker run` command or `docker-compose.yml` used to start the image. Mask out the sensitive bits.
- Please state if you are using [Boot2Docker](http://www.boot2docker.io), [VirtualBox](https://www.virtualbox.org), etc.

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/benpiper/docker-bind) and is the recommended method of installation.

```bash
docker pull benpiper/docker-bind:latest
```

Alternatively you can build the image yourself.

```bash
docker build -t benpiper/docker-bind github.com/benpiper/docker-bind
```

## Quickstart

Start BIND using:

```bash
docker run --name dns1 -d --restart=always \
  --publish 53:53/tcp --publish 53:53/udp \
  benpiper/docker-bind:latest
```

This will load BIND with a sample configuration and zone (siliconharbor.io). If you want to start with a clean slate, see the following [Persistence](#persistence) section.

## Persistence

For BIND to preserve its state across container deletion you can mount a volume at `/data` by adding the following flags to the `docker run` command:
```bash
--volume /srv/docker/bind:/data
```

*Alternatively, you can use the sample [docker-compose.yml](docker-compose.yml) file to start the container using [Docker Compose](https://docs.docker.com/compose/)*

# Maintenance

## Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using Docker version `1.3.0` or higher you can access a running containers shell by starting `bash` using `docker exec`:

```bash
docker exec -it benpiper/docker-bind bash
```
