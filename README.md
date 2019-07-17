# ExpenseInfo

This is a great ios app that helps the user to take a picture of the receipt and automatically pulls out the charges at the time of payment. And if the user loses a receipt then there is an option that allows to input charges directly from credit cards. Thus this will save user’s time tracking down and manually recording spending history.


# Requirements
Xcode 10.2
Swift 5.0
For Xcode 10.1 and below, use RxSwift 4.5.

# Installation

These are currently the supported options:

# Manual
Open ExpenseInfo.xcworkspace, choose ExpenseInfo and hit run. This method will build everything and run the sample app

CocoaPods
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
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
end

Replace YOUR_TARGET_NAME and then, in the Podfile directory, type:

$ pod install
