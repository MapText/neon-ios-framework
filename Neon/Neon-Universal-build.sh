#!/bin/sh

#  Neon-Universal-build.sh
#  Neon
#
#  Created by Lukasz Wroczynski on 03.11.2016.
#  Copyright © 2016 MapText. All rights reserved.


# based on blog entry: https://medium.com/@syshen/create-an-ios-universal-framework-148eb130a46c#.fd1nbis2r
# script: https://gist.github.com/syshen/c24d127e1adc2783e0e7

# added '|| exit -1' to commands executed by the script to make sure the script fails as a whole if anything goes wrong


######################
# Options
######################

REVEAL_ARCHIVE_IN_FINDER=false

FRAMEWORK_NAME="${PROJECT_NAME}"

SIMULATOR_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}.framework"

DEVICE_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework"

UNIVERSAL_LIBRARY_DIR="${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal"

FRAMEWORK="${UNIVERSAL_LIBRARY_DIR}/${FRAMEWORK_NAME}.framework"


######################
# Build Frameworks
######################

xcodebuild -project ${PROJECT_NAME}.xcodeproj -scheme ${PROJECT_NAME} -sdk iphonesimulator -configuration ${CONFIGURATION} clean build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator 2>&1 || exit -1

xcodebuild -project ${PROJECT_NAME}.xcodeproj -scheme ${PROJECT_NAME} -sdk iphoneos -configuration ${CONFIGURATION} clean build CONFIGURATION_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphoneos 2>&1 || exit -1

######################
# Create directory for universal
######################

rm -rf "${UNIVERSAL_LIBRARY_DIR}"

mkdir "${UNIVERSAL_LIBRARY_DIR}"

mkdir "${FRAMEWORK}"


######################
# Copy files Framework
######################

cp -r "${DEVICE_LIBRARY_PATH}/." "${FRAMEWORK}" || exit -1


######################
# Make an universal binary
######################

lipo "${SIMULATOR_LIBRARY_PATH}/${FRAMEWORK_NAME}" "${DEVICE_LIBRARY_PATH}/${FRAMEWORK_NAME}" -create -output "${FRAMEWORK}/${FRAMEWORK_NAME}" || exit -1

# For Swift framework, Swiftmodule needs to be copied in the universal framework
if [ -d "${SIMULATOR_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/" ]; then
cp -f ${SIMULATOR_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/* "${FRAMEWORK}/Modules/${FRAMEWORK_NAME}.swiftmodule/" || exit -1
fi

if [ -d "${DEVICE_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/" ]; then
cp -f ${DEVICE_LIBRARY_PATH}/Modules/${FRAMEWORK_NAME}.swiftmodule/* "${FRAMEWORK}/Modules/${FRAMEWORK_NAME}.swiftmodule/" || exit -1
fi

######################
# On Release, copy the result to release directory
######################
OUTPUT_DIR="${PROJECT_DIR}/Output/${FRAMEWORK_NAME}-${CONFIGURATION}-iphoneuniversal/"

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

cp -r "${FRAMEWORK}" "$OUTPUT_DIR" || exit -1

if [ ${REVEAL_ARCHIVE_IN_FINDER} = true ]; then
open "${OUTPUT_DIR}/"
fi
