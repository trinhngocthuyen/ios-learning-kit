#
# Be sure to run `pod lib lint NTKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NTKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of NTKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Thuyen Trinh/NTKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Thuyen Trinh' => 'trinhngocthuyen@gmail.com' }
  s.source           = { :git => 'https://github.com/Thuyen Trinh/NTKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'NTKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NTKit' => ['NTKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  # --- Subspecs --- #
  # --- Subspecs - Core --- #
  s.subspec 'NTExtensions' do |ssp|
    ssp.source_files = 'NTKit/NTExtensions/**/*.{h,m,swift}'
  end

  s.subspec 'NTFunctional' do |ssp|
    ssp.source_files = 'NTKit/NTFunctional/**/*.{h,m,swift}'
  end

  s.subspec 'NTReactive' do |ssp|
    ssp.source_files = 'NTKit/NTReactive/**/*.{h,m,swift}'
    ssp.dependency 'ReactiveSwift'
    ssp.dependency 'ReactiveCocoa'
    # TODO: How about RxSwift?
  end

  # --- Subspecs - Higher level --- #
  s.subspec 'NTApiClient' do |ssp|
    ssp.source_files = 'NTKit/NTApiClient/**/*.{h,m,swift}'
    ssp.dependency 'Alamofire'  # TODO: Which version?
  end

  s.subspec 'NTTesting' do |ssp|
    ssp.source_files = 'NTKit/NTTesting/**/*.{h,m,swift}'
  end

end
