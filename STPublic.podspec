#
# Be sure to run `pod lib lint STPublic.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'STPublic'
  s.version          = '0.1.1'
  s.summary          = '公共组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '公共组件化'

  s.homepage         = 'https://github.com/SummerAfter/STPublic'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SummerAfter' => '130220604@qq.com' }
  s.source           = { :git => 'https://github.com/SummerAfter/STPublic.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.dependency 'YYImage'
  s.dependency 'YYModel'
  s.dependency 'YYText'
  s.dependency 'SDWebImage' ,'5.8.4'
  s.dependency 'AFNetworking'
  s.dependency 'CocoaLumberjack'
  s.dependency 'YYCache'

  s.subspec 'STCategory' do |a|
      a.source_files = 'STPublic/Classes/STCategory/**/*.{h,m}'
  end
  
  s.subspec 'STNetworking' do |b|
      b.source_files = 'STPublic/Classes/STNetworking/**/*.{h,m}'
  end
  
  s.subspec 'STUtils' do |c|
      c.source_files = 'STPublic/Classes/STUtils/**/*.{h,m}'
  end

  # s.resource_bundles = {
  #   'STPublic' => ['STPublic/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
