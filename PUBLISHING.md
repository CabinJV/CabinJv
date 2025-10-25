# Publishing to Maven Central Guide

## Overview

Your project is now configured to publish to Maven Central with the verified namespace `com.cabinj`.

## Prerequisites

### 1. GPG Key Setup

Ensure you have a GPG key configured and uploaded to key servers:

```bash
# List your GPG keys
gpg --list-keys

# Get your key ID (the 8-character hex string)
gpg --list-secret-keys --keyid-format=short

# Upload your public key to key servers (required by Maven Central)
gpg --keyserver keyserver.ubuntu.com --send-keys YOUR_KEY_ID
gpg --keyserver keys.openpgp.org --send-keys YOUR_KEY_ID
gpg --keyserver pgp.mit.edu --send-keys YOUR_KEY_ID
```

### 2. Gradle Properties

Create or update `~/.gradle/gradle.properties` with your OSSRH credentials and GPG key information:

```properties
# OSSRH Credentials
ossrhUsername=YOUR_SONATYPE_USERNAME
ossrhPassword=YOUR_SONATYPE_PASSWORD

# GPG Signing
signing.keyId=YOUR_8_CHAR_KEY_ID
signing.password=YOUR_GPG_PASSPHRASE
signing.secretKeyRingFile=/Users/YOUR_USERNAME/.gnupg/secring.gpg
```

If you're using GPG 2.1+, you may need to export your secret key:

```bash
gpg --export-secret-keys YOUR_KEY_ID > ~/.gnupg/secring.gpg
```

## Publishing Steps

### Option 1: Publish to Maven Central Staging Repository

This is the recommended approach for automated deployment:

```bash
# Clean, build, sign, generate checksums, and publish
./gradlew clean build sign generateChecksums publish
```

This will:
1. Build all JARs (main, javadoc, sources)
2. Sign all artifacts with GPG
3. Generate MD5, SHA1, SHA256, and SHA512 checksums
4. Publish to OSSRH staging repository

After publishing, you need to:
1. Log in to https://s01.oss.sonatype.org/
2. Go to "Staging Repositories"
3. Find your repository (usually named `comcabinj-XXXX`)
4. Click "Close" to validate the artifacts
5. If validation passes, click "Release" to publish to Maven Central

### Option 2: Manual Upload via Maven Central UI

If you prefer to upload manually:

```bash
# Build and sign all artifacts
./gradlew clean build sign generateChecksums
```

Then create a bundle for upload:

```bash
# Create a staging directory
mkdir -p staging/com/cabinj/cabinj/26.0.0

# Copy all required files
cp build/libs/cabinj-26.0.0.jar* staging/com/cabinj/cabinj/26.0.0/
cp build/libs/cabinj-26.0.0-javadoc.jar* staging/com/cabinj/cabinj/26.0.0/
cp build/libs/cabinj-26.0.0-sources.jar* staging/com/cabinj/cabinj/26.0.0/
cp build/publications/mavenJava/pom-default.xml staging/com/cabinj/cabinj/26.0.0/cabinj-26.0.0.pom
cp build/publications/mavenJava/pom-default.xml.asc staging/com/cabinj/cabinj/26.0.0/cabinj-26.0.0.pom.asc
cp build/publications/mavenJava/pom-default.xml.md5 staging/com/cabinj/cabinj/26.0.0/cabinj-26.0.0.pom.md5
cp build/publications/mavenJava/pom-default.xml.sha1 staging/com/cabinj/cabinj/26.0.0/cabinj-26.0.0.pom.sha1
cp build/publications/mavenJava/module.json staging/com/cabinj/cabinj/26.0.0/cabinj-26.0.0.module
cp build/publications/mavenJava/module.json.asc staging/com/cabinj/cabinj/26.0.0/cabinj-26.0.0.module.asc
cp build/publications/mavenJava/module.json.md5 staging/com/cabinj/cabinj/26.0.0/cabinj-26.0.0.module.md5
cp build/publications/mavenJava/module.json.sha1 staging/com/cabinj/cabinj/26.0.0/cabinj-26.0.0.module.sha1

# Create a ZIP bundle
cd staging
zip -r ../cabinj-26.0.0-bundle.zip .
cd ..
```

Upload the bundle to https://central.sonatype.com/publishing

## Verification

After building, verify that all required files are present:

```bash
# Check JARs and checksums
ls -la build/libs/cabinj-26.0.0*

# Check POM and module files
ls -la build/publications/mavenJava/
```

Required files for Maven Central:
- ✅ cabinj-26.0.0.jar + .asc + .md5 + .sha1
- ✅ cabinj-26.0.0-javadoc.jar + .asc + .md5 + .sha1
- ✅ cabinj-26.0.0-sources.jar + .asc + .md5 + .sha1
- ✅ cabinj-26.0.0.pom + .asc + .md5 + .sha1
- ✅ cabinj-26.0.0.module + .asc + .md5 + .sha1

## Configuration Summary

Your build.gradle is configured with:

- **Group ID**: `com.cabinj`
- **Artifact ID**: `cabinj`
- **Version**: `26.0.0`
- **Repository**: `https://s01.oss.sonatype.org/service/local/staging/deploy/maven2/`

The correct Maven path will be: `com/cabinj/cabinj/26.0.0/`

## Troubleshooting

### Issue: Missing checksums

**Solution**: Make sure to run `./gradlew generateChecksums` after signing, or use the combined command:
```bash
./gradlew clean build sign generateChecksums
```

### Issue: Invalid signature - Could not find public key

**Solution**: Upload your public key to key servers:
```bash
gpg --keyserver keyserver.ubuntu.com --send-keys YOUR_KEY_ID
gpg --keyserver keys.openpgp.org --send-keys YOUR_KEY_ID
```

Wait 10-15 minutes for propagation, then retry.

### Issue: File path 'express/26.0.0' is not valid

**Solution**: This was fixed by updating the `groupId` to `com.cabinj` in build.gradle. The path should now be `com/cabinj/cabinj/26.0.0/`.

### Issue: Publishing task fails

**Solution**: Ensure your `~/.gradle/gradle.properties` has the correct OSSRH credentials:
```properties
ossrhUsername=YOUR_USERNAME
ossrhPassword=YOUR_PASSWORD
```

## After Publication

Once published to Maven Central, your library will be available at:

```xml
<dependency>
    <groupId>com.cabinj</groupId>
    <artifactId>cabinj</artifactId>
    <version>26.0.0</version>
</dependency>
```

Or in Gradle:

```groovy
implementation 'com.cabinj:cabinj:26.0.0'
```

Maven Central sync can take 15 minutes to 2 hours after release.

## Build Fat JAR (Optional)

If you need a fat JAR with all dependencies included:

```bash
./gradlew fatJar
```

This will create `build/libs/cabinj-26.0.0-all.jar` (not published to Maven Central).

