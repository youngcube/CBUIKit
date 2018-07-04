#
# Be sure to run `pod lib lint YCUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YCUIKit'
  s.version          = '0.2.0'
  s.summary          = 'Fake UIKit For macOS.'

  s.description      = <<-DESC
  Fake UIKit For macOS.
                       DESC

  s.homepage         = 'https://github.com/youngcube/YCUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'youngcube' => 'youngcube@hotmail.com' }
  s.source           = { :git => 'https://github.com/youngcube/YCUIKit.git', :tag => s.version.to_s }

  s.osx.deployment_target = '10.10'

  s.source_files = 'YCUIKit/Classes/**/*'
end
