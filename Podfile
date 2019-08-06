# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
inhibit_all_warnings!

target 'WeChat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Moya'
  pod 'Starscream', '~> 3.0.2'
  pod 'Kingfisher', '~> 4.8.1'
  pod 'RealmSwift', '~> 3.9.0'
  pod 'ReachabilitySwift', '~> 4.2.1'
  pod 'WoodPeckeriOS', :configurations => ['Debug']
  
  # OC
  pod 'YYText', '~> 1.0.7'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'MJRefresh', '~> 3.1.15.3'

  # Pods for WeChat

  target 'WeChatTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WeChatUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
