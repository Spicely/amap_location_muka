#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint amap_location_muka.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'amap_location_muka'
  s.version          = '0.1.8'
  s.summary          = 'Flutter高德定位插件'
  s.description      = <<-DESC
Flutter高德定位插件
                       DESC
  s.homepage         = 'https://github.com/Spicely/amap_location_muka'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Spicely' => 'Spicely@outlook.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'AMapLocation'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'amap_location_muka_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
