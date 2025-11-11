#!/bin/bash
set -e

# Import options from devcontainer-feature.json
VERSION="${VERSION:-"latest"}"
APIURL="${APIURL:-"https://nurburg.dev"}"

echo "======================================"
echo "Installing Nurburg Platform CTL"
echo "======================================"
echo "Version: ${VERSION}"
echo "API URL: ${APIURL}"
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

# Set up environment variables
echo "Configuring environment..."
cat >> /etc/bash.bashrc <<EOF

# Nurburg Platform CTL configuration
export NURBURG_API_URL="${APIURL}"
EOF

# Also set for zsh if it exists
if [ -f /etc/zsh/zshrc ]; then
    cat >> /etc/zsh/zshrc <<EOF

# Nurburg Platform CTL configuration
export NURBURG_API_URL="${APIURL}"
EOF
fi

echo ""
echo "======================================"
echo "✓ nurburgdev-ctl installed successfully"
echo "======================================"
echo ""
nurburgdev-ctl --help
echo ""
echo "Default API URL: ${APIURL}"
