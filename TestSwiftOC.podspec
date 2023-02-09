#
# Be sure to run `pod lib lint TestSwiftOC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TestSwiftOC'
  s.version          = '0.5.9'
  s.summary          = 'A short description of TestSwiftOC.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/lin333/TestSwiftOC'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'linbingjie' => 'linbingjie@itiger.com' }
  s.source           = { :git => 'https://github.com/lin333/TestSwiftOC.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.static_framework = true
  s.pod_target_xcconfig = { "DEFINES_MODULE" => "YES" }
  s.swift_version = "5.0"
  
  s.source_files = 'TestSwiftOC/Classes/**/*'
  
  s.dependency 'RJImageLoader'
  # s.dependency 'lottie-ios'

#  s.dependency 'MJRefresh'
  # s.dependency 'Moya'
#  s.prefix_header_contents = '
#    #if __has_include(<TestSwiftOC/TestSwiftOC-Swift.h>)
#    #import <TestSwiftOC/TestSwiftOC-Swift.h>
#    #else
#    #import "TestSwiftOC-Swift.h"
#    #endif
#  '
  
#  s.public_header_files = 'TestSwiftOC/**/*.{h,swift}'

  
end
 
