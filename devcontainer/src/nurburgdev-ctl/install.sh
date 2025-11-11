#!/bin/bash
set -e

VERSION="${VERSION:-"0.3.7"}"

echo "======================================"
echo "Installing Nurburg Platform CTL"
echo "======================================"
echo "Version: ${VERSION}"
echo ""

# Detect architecture
ARCH=$(uname -m)
case ${ARCH} in
    x86_64)  ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
    armv7l)  ARCH="armv7" ;;
    *)       echo "Unsupported architecture: ${ARCH}"; exit 1 ;;
esac

# Detect OS
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# GitHub repository
REPO="nurburg-platform/nurburg-platform"
BINARY_NAME="nurburgdev-ctl-${OS}-${ARCH}"

echo "Detected: ${OS}/${ARCH}"

# Determine download URL
if [ "${VERSION}" = "latest" ]; then
    DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/${BINARY_NAME}"
    echo "Downloading latest version..."
else
    DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${BINARY_NAME}"
    echo "Downloading version ${VERSION}..."
fi

# Download binary
echo "URL: ${DOWNLOAD_URL}"
curl -fsSL "${DOWNLOAD_URL}" -o /tmp/nurburgdev-ctl

# Install binary
echo "Installing to /usr/local/bin..."
install -m 755 /tmp/nurburgdev-ctl /usr/local/bin/nurburgdev-ctl
rm /tmp/nurburgdev-ctl