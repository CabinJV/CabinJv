#!/bin/bash

# Generate checksums for Maven Central publication
# Maven Central requires MD5 and SHA1 checksums for all artifacts

# Set the version
VERSION="26.0.0"
BUILD_DIR="build/libs"
PUB_DIR="build/publications/mavenJava"

echo "Generating checksums for Maven Central publication..."

# Function to generate checksums for a file
generate_checksums() {
    local file=$1
    if [ -f "$file" ]; then
        echo "Generating checksums for: $file"
        # MD5
        md5 -q "$file" > "${file}.md5"
        # SHA1
        shasum -a 1 "$file" | cut -d ' ' -f 1 > "${file}.sha1"
        # SHA256 (optional but recommended)
        shasum -a 256 "$file" | cut -d ' ' -f 1 > "${file}.sha256"
        # SHA512 (optional but recommended)
        shasum -a 512 "$file" | cut -d ' ' -f 1 > "${file}.sha512"
    fi
}

# Generate checksums for JARs
generate_checksums "${BUILD_DIR}/cabinj-${VERSION}.jar"
generate_checksums "${BUILD_DIR}/cabinj-${VERSION}-javadoc.jar"
generate_checksums "${BUILD_DIR}/cabinj-${VERSION}-sources.jar"

# Generate checksums for signatures
generate_checksums "${BUILD_DIR}/cabinj-${VERSION}.jar.asc"
generate_checksums "${BUILD_DIR}/cabinj-${VERSION}-javadoc.jar.asc"
generate_checksums "${BUILD_DIR}/cabinj-${VERSION}-sources.jar.asc"

# Generate checksums for POM
generate_checksums "${PUB_DIR}/pom-default.xml"
if [ -f "${PUB_DIR}/pom-default.xml.asc" ]; then
    generate_checksums "${PUB_DIR}/pom-default.xml.asc"
fi

# Generate checksums for module metadata
generate_checksums "${PUB_DIR}/module.json"
if [ -f "${PUB_DIR}/module.json.asc" ]; then
    generate_checksums "${PUB_DIR}/module.json.asc"
fi

echo ""
echo "Checksums generated successfully!"
echo ""
echo "Files ready for Maven Central:"
ls -lh ${BUILD_DIR}/cabinj-${VERSION}* ${PUB_DIR}/*.xml* ${PUB_DIR}/*.json* 2>/dev/null | grep -v "^d"

