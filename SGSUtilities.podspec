Pod::Spec.new do |s|
  s.name     = 'SGSUtilities'
  s.version  = '0.3.4'
  s.summary  = '常用工具集合'

  s.homepage = 'https://github.com/CharlsPrince/SGSUtilities'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.author   = { 'CharlsPrince' => '961629701@qq.com' }
  s.source   = { :git => 'https://github.com/CharlsPrince/SGSUtilities.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.requires_arc  = true
  s.source_files  = 'SGSUtilities/Classes/*.*'
  s.public_header_files = 'SGSUtilities/Classes/*.*'
  s.frameworks = 'UIKit', 'Foundation', 'CoreGraphics'

  s.subspec 'AppUtil' do |ss|
    ss.source_files = 'SGSUtilities/Classes/AppUtil/*.{h,m}'
    ss.public_header_files = 'SGSUtilities/Classes/AppUtil/*.h'
    ss.frameworks = 'UIKit', 'Foundation'
  end

  s.subspec 'SystemUtil' do |ss|
    ss.source_files = 'SGSUtilities/Classes/SystemUtil/*.{h,m}'
    ss.public_header_files = 'SGSUtilities/Classes/SystemUtil/*.h'
    ss.frameworks = 'UIKit', 'Foundation'
  end

  s.subspec 'DeviceUtil' do |ss|
    ss.source_files = 'SGSUtilities/Classes/DeviceUtil/*.{h,m}'
    ss.public_header_files = 'SGSUtilities/Classes/DeviceUtil/*.h'
    ss.frameworks = 'UIKit', 'Foundation', 'CoreGraphics', 'CoreTelephony'
  end

  s.subspec 'ImageUtil' do |ss|
    ss.source_files = 'SGSUtilities/Classes/ImageUtil/*.{h,m}'
    ss.public_header_files = 'SGSUtilities/Classes/ImageUtil/*.h'
    ss.frameworks = 'UIKit', 'Foundation'
  end

  s.subspec 'NetworkUtil' do |ss|
    ss.source_files = 'SGSUtilities/Classes/NetworkUtil/*.{h,m}'
    ss.public_header_files = 'SGSUtilities/Classes/NetworkUtil/*.h'
    ss.frameworks = 'UIKit', 'Foundation'
  end

  s.subspec 'CountdownUtil' do |ss|
    ss.source_files = 'SGSUtilities/Classes/CountdownUtil/*.{h,m}'
    ss.public_header_files = 'SGSUtilities/Classes/CountdownUtil/*.h'
    ss.frameworks = 'UIKit', 'Foundation'
  end

  s.subspec 'TableViewUtil' do |ss|
    ss.source_files = 'SGSUtilities/Classes/TableViewUtil/*.{h,m}'
    ss.public_header_files = 'SGSUtilities/Classes/TableViewUtil/*.h'
    ss.frameworks = 'UIKit'
  end

  s.subspec 'BannerView' do |ss|
    ss.source_files = 'SGSUtilities/Classes/BannerView/*.{h,m}'
    ss.public_header_files = 'SGSUtilities/Classes/BannerView/*.h'
    ss.frameworks = 'UIKit'
    ss.dependency 'SGSUtilities/ImageUtil'
  end

  s.subspec 'CityPicker' do |ss|
    ss.source_files = 'SGSUtilities/Classes/CityPicker/*.{h,m}'
    ss.public_header_files = 'SGSUtilities/Classes/CityPicker/SGSCityPickerController.h'
    ss.frameworks = 'UIKit'

    ss.resource_bundles = {
      'SGSCityPicker' => ['SGSUtilities/Assets/CityList.plist']
    }
  end

  s.subspec 'Toast' do |ss|
    ss.source_files = 'SGSUtilities/Classes/Toast/*.{h,m}'
    ss.public_header_files = 'SGSUtilities/Classes/Toast/*.h'
    ss.frameworks = 'UIKit'
  end

end
