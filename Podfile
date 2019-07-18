# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/cocoapods/specs.git'
target 'ExpenseInfo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    pod 'Firebase/Core'
    pod 'Firebase/MLVision'
    pod 'Firebase/MLVisionTextModel'
    pod 'DatePickerDialog'
    pod 'LLSwitch'
    pod 'WSTagsField'
    pod 'pop'
    pod 'RKPieChart'
    pod 'Fabric', '~> 1.9.0'
    pod 'Crashlytics', '~> 3.12.0'
    pod 'SwipeVC'
    

    post_install do |installer|
        installer.pods_project.build_configurations.each do |config|
            config.build_settings.delete('CODE_SIGNING_ALLOWED')
            config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end
    end


  # Pods for ExpenseInfo

  target 'ExpenseInfoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ExpenseInfoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
