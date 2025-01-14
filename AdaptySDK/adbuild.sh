
xcodebuild -project "AdaptySDK.xcodeproj" archive \
  -scheme "AdaptySDK" \ OTHER_SWIFT_FLAGS="-no-verify-emitted-module-interface" \
  -configuration Debug \
  -archivePath "build/AdaptySDK-Sim.xcarchive" \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath "build" \
  ENABLE_BITCODE=NO \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild -project "AdaptySDK.xcodeproj" archive \
  -scheme "AdaptySDK" \ OTHER_SWIFT_FLAGS="-no-verify-emitted-module-interface" \
  -configuration Release \
  -archivePath "build/AdaptySDK.xcarchive" \
  -destination "generic/platform=iOS" \
  -derivedDataPath "build" \
  ENABLE_BITCODE=NO \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

