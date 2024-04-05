# Dockerfile for Screengen

- [OlegKochkin/screengen: Creates the list thumbnails of the video file in console](https://github.com/OlegKochkin/screengen)

## Build

### Build with current latest version.

```shell
$ docker build . -t screengen:latest
```

## Usage

```shell
$ docker run --rm screengen
```

### Examples

```shell
$ docker run --rm \
  -v ./video.mp4:/input/video.mp4 \
  -v ./output:/output \
  screengen /input/video.mp4 --header false --horCount 8
```
