Pod::Spec.new do |s|
  s.name = 'OMJoystick'
  s.version = '0.7.0'
  s.swift_versions = '5.0'
  s.license = 'MIT'
  s.summary = 'This is the Joystick UI library for SwiftUI.'
  s.homepage = 'https://github.com/tichise/OMJoystick'
  s.social_media_url = 'http://twitter.com/tichise'
  s.author = "Takuya Ichise"
  s.source = { :git => 'https://github.com/tichise/OMJoystick.git', :tag => s.version }

  s.ios.deployment_target = '13.0'

  s.source_files = 'Sources/*.swift'
  s.requires_arc = true

  s.resource_bundles = {
  }
end
