# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'DesafioStone' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

    # core RxSwift
    pod 'RxSwift', '~> 4.0'
    pod 'RxCocoa', '~> 4.0'
    pod 'RxDataSources', '~> 3.0'

    
    # Realm database
    pod 'RealmSwift', '~> 3.0'
    pod 'RxRealm', '0.7.6'

  target 'DesafioStoneTests' do
    inherit! :search_paths
    pod 'RxTest', '~> 4.0'
    pod 'RxBlocking', '~> 4.0'
  end

  target 'DesafioStoneUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end