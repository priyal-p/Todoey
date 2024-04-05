
platform :ios, '15.0'
workspace 'Todoey'
project 'Todoey.xcodeproj'

use_frameworks!

target 'Todoey' do
  # Pods for Todoey
pod 'RealmSwift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONE_DEPLOYMENT_TARGET"] = "15.0"
    end
  end
end

