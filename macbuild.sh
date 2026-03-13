#!/bin/sh
set -eu

ARCH="${1:?usage: $0 <amd64|aarch64|armv7|armhf|i386|ppc64le>}"
CURL_VERSION="${2:-}"

case "$ARCH" in
  amd64)   PLATFORM="linux/amd64"    ;;
  i386)    PLATFORM="linux/386"      ;;
  aarch64) PLATFORM="linux/arm64/v8" ;;
  armv7)   PLATFORM="linux/arm/v7"   ;;
  armhf)   PLATFORM="linux/arm/v6"   ;;
  ppc64le) PLATFORM="linux/ppc64le"  ;;
  *) echo "unsupported arch: $ARCH" >&2; exit 1 ;;
esac

exec docker run --rm \
  --platform "$PLATFORM" \
  -v "$PWD:/tmp" \
  -w /tmp \
  -e ARCH="$ARCH" \
  alpine:3.23 \
  /tmp/build.sh ${CURL_VERSION:+$CURL_VERSION}