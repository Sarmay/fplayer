#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint fplayer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sarmay_fplayer'
  s.version          = '1.1.15'
  s.summary          = 'Flutter video player plugin based on fplayer-core.'
  s.description      = <<-DESC
Flutter video player plugin based on fplayer-core for Android and iOS.
                       DESC
  s.homepage         = 'https://github.com/Sarmay/fplayer'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Sarmay' => '282387881@qq.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  s.static_framework = true

  # s.preserve_paths = 'Frameworks/*.framework'
  # s.vendored_framework = 'Framework/IJKMediaPlayer.framework'
  # s.xcconfig = { 'LD_RUNPATH_SEARCH_PATHS' => '"$(PODS_ROOT)/Frameworks/"' }

  s.libraries = "bz2", "z", "stdc++"

  s.dependency 'fplayer-core', '1.0.4'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
