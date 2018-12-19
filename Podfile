source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10'
use_frameworks!

target 'FRC Advanced Scouting Touchstone' do
pod 'Alamofire'
pod 'NYTPhotoViewer'
pod "GMStepper"
pod 'SSBouncyButton', '~> 1.0'
pod 'UICircularProgressRing'
pod 'VTAcknowledgementsViewController'
pod 'RealmSwift'
pod 'TORoundedTableView'
pod 'AWSCore', '~> 2.7.0'
pod 'AWSMobileClient'
pod 'AWSUserPoolsSignIn'
pod 'AWSAuthUI'
pod 'AWSAppSync', '~> 2.6.24'
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('/Users/aaron/Documents/Xcode Projects/FRC Advanced Scouting Telemetrics/Pods/Target Support Files/Pods-FRC Advanced Scouting Touchstone/Pods-FRC Advanced Scouting Touchstone-acknowledgements.plist', '/Users/aaron/Documents/Xcode Projects/FRC Advanced Scouting Telemetrics/FRC Advanced Scouting Telemetrics/Pods-acknowledgments.plist', :remove_destination => true)
end