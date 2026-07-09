#!/usr/bin/env bash
set -euo pipefail

IA_ITEM="${1:?Usage: ./scripts/make_release.sh <internet_archive_item> <version>}"
VERSION="${2:?Usage: ./scripts/make_release.sh <internet_archive_item> <version>}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist"
PACKAGE_DIR="${DIST_DIR}/capoeirawiki-${VERSION}"

rm -rf "${DIST_DIR}"
mkdir -p "${PACKAGE_DIR}/raw"

echo "Downloading Internet Archive item: ${IA_ITEM}"
ia download "${IA_ITEM}" --destdir "${PACKAGE_DIR}/raw"

cp "${ROOT_DIR}/README.md" "${PACKAGE_DIR}/README.md"
cp "${ROOT_DIR}/LICENSE" "${PACKAGE_DIR}/LICENSE"
cp "${ROOT_DIR}/CITATION.cff" "${PACKAGE_DIR}/CITATION.cff"

cat > "${PACKAGE_DIR}/metadata.txt" << EOF
Title: CapoeiraWiki dataset
Version: ${VERSION}
Website: https://capoeirawiki.org/
Source: https://archive.org/details/${IA_ITEM}
Generated: $(date -u +"%Y-%m-%d")
EOF

cd "${DIST_DIR}"
zip -r "capoeirawiki-${VERSION}.zip" "capoeirawiki-${VERSION}"

echo "Created: ${DIST_DIR}/capoeirawiki-${VERSION}.zip"
