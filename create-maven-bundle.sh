#!/bin/bash

# Script to create a proper Maven Central bundle with correct structure
# This ensures you upload the RIGHT files with the RIGHT names

set -e

VERSION="26.0.0"
GROUP_ID="com.cabinj"
ARTIFACT_ID="cabinj"
BUILD_DIR="build"

echo "Creating Maven Central bundle for ${GROUP_ID}:${ARTIFACT_ID}:${VERSION}"
echo "================================================================"

# Clean and build first
echo ""
echo "Step 1: Building project..."
./gradlew clean build sign generateChecksums --warning-mode=none

# Create staging directory with proper Maven structure
STAGING_DIR="maven-bundle"
ARTIFACT_DIR="${STAGING_DIR}/${GROUP_ID//.//}/${ARTIFACT_ID}/${VERSION}"

echo ""
echo "Step 2: Creating staging directory: ${ARTIFACT_DIR}"
rm -rf "${STAGING_DIR}"
mkdir -p "${ARTIFACT_DIR}"

# Copy main JAR and its checksums/signature
echo ""
echo "Step 3: Copying artifacts..."

copy_with_checksums() {
    local src=$1
    local dest=$2

    if [ -f "$src" ]; then
        echo "  - $(basename $dest)"
        cp "$src" "$dest"
        [ -f "${src}.asc" ] && cp "${src}.asc" "${dest}.asc"
        [ -f "${src}.md5" ] && cp "${src}.md5" "${dest}.md5"
        [ -f "${src}.sha1" ] && cp "${src}.sha1" "${dest}.sha1"
        [ -f "${src}.sha256" ] && cp "${src}.sha256" "${dest}.sha256"
        [ -f "${src}.sha512" ] && cp "${src}.sha512" "${dest}.sha512"

        # Also copy signature checksums
        [ -f "${src}.asc.md5" ] && cp "${src}.asc.md5" "${dest}.asc.md5"
        [ -f "${src}.asc.sha1" ] && cp "${src}.asc.sha1" "${dest}.asc.sha1"
        [ -f "${src}.asc.sha256" ] && cp "${src}.asc.sha256" "${dest}.asc.sha256"
        [ -f "${src}.asc.sha512" ] && cp "${src}.asc.sha512" "${dest}.asc.sha512"
    else
        echo "  ERROR: File not found: $src"
        exit 1
    fi
}

# Copy all required artifacts
copy_with_checksums \
    "${BUILD_DIR}/libs/${ARTIFACT_ID}-${VERSION}.jar" \
    "${ARTIFACT_DIR}/${ARTIFACT_ID}-${VERSION}.jar"

copy_with_checksums \
    "${BUILD_DIR}/libs/${ARTIFACT_ID}-${VERSION}-javadoc.jar" \
    "${ARTIFACT_DIR}/${ARTIFACT_ID}-${VERSION}-javadoc.jar"

copy_with_checksums \
    "${BUILD_DIR}/libs/${ARTIFACT_ID}-${VERSION}-sources.jar" \
    "${ARTIFACT_DIR}/${ARTIFACT_ID}-${VERSION}-sources.jar"

# Copy POM
echo "  - ${ARTIFACT_ID}-${VERSION}.pom"
copy_with_checksums \
    "${BUILD_DIR}/publications/mavenJava/pom-default.xml" \
    "${ARTIFACT_DIR}/${ARTIFACT_ID}-${VERSION}.pom"

# Copy module metadata (Gradle metadata)
echo "  - ${ARTIFACT_ID}-${VERSION}.module"
copy_with_checksums \
    "${BUILD_DIR}/publications/mavenJava/module.json" \
    "${ARTIFACT_DIR}/${ARTIFACT_ID}-${VERSION}.module"

# Create the bundle ZIP
echo ""
echo "Step 4: Creating bundle archive..."
BUNDLE_FILE="${ARTIFACT_ID}-${VERSION}-bundle.zip"
cd "${STAGING_DIR}"
zip -r "../${BUNDLE_FILE}" .
cd ..

echo ""
echo "================================================================"
echo "✅ SUCCESS! Bundle created: ${BUNDLE_FILE}"
echo ""
echo "File count in bundle:"
find "${STAGING_DIR}" -type f | wc -l | xargs echo "  Total files:"
echo ""
echo "Bundle structure:"
unzip -l "${BUNDLE_FILE}" | head -30
echo ""
echo "================================================================"
echo "Upload this file to Maven Central:"
echo "  📦 ${BUNDLE_FILE}"
echo ""
echo "Upload URL: https://central.sonatype.com/publishing"
echo "================================================================"
echo ""
echo "NOTE: The files are named '${ARTIFACT_ID}-26.0.0.jar', NOT 'express-26.0.0.jar'"
echo "This is correct! Your groupId is: ${GROUP_ID}"
echo "================================================================"

