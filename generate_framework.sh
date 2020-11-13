#!/bin/bash

REPO_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_PATH="$REPO_PATH/SInject/SInject.xcodeproj"
OUTPUTS_PATH="$REPO_PATH/outputs"
OUTPUTS_DEVICE_PATH="$OUTPUTS_PATH/iphoneos"
OUTPUTS_SIMULATOR_PATH="$OUTPUTS_PATH/iphonesimulator"
FRAMEWORK_NAME="SInject.framework"
XCFRAMEWORK_PATH="$OUTPUTS_PATH/SInject.xcframework"

echo ">>>>> Cleaning outputs directory"
rm -rf $OUTPUTS_PATH

echo ">>>>> Building for devices"
xcodebuild \
    -project $PROJECT_PATH \
    -scheme SInject \
    -configuration Release \
    -sdk iphoneos \
    CONFIGURATION_BUILD_DIR=$OUTPUTS_DEVICE_PATH \
    clean \
    build \
    | xcpretty

echo ">>>>> Building for simulator"
xcodebuild \
    -project SInject/SInject.xcodeproj \
    -scheme SInject \
    -configuration Release \
    -sdk iphonesimulator \
    CONFIGURATION_BUILD_DIR=$OUTPUTS_SIMULATOR_PATH \
    clean \
    build \
    | xcpretty

echo ">>>>> Generating xcframework"
xcodebuild \
    -create-xcframework \
    -framework $OUTPUTS_DEVICE_PATH/$FRAMEWORK_NAME \
    -framework $OUTPUTS_SIMULATOR_PATH/$FRAMEWORK_NAME \
    -output $XCFRAMEWORK_PATH \
    | xcpretty

echo ">>>>> Zipping xcframework"
zip -r "$XCFRAMEWORK_PATH.zip" $XCFRAMEWORK_PATH
