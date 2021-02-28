#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint amap_location.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'amap_location_muka'
  s.version          = '0.0.1'
  s.summary          = 'Flutter高德定位插件'
  s.description      = <<-DESC
Flutter高德定位插件
                       DESC
  s.homepage         = 'https://github.com/Spicely/amap_location_muka'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Spicely' => 'Spicely@outlook.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  s.dependency 'Flutter'
  s.dependency 'AMapLocation-NO-IDFA', '2.6.5'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
