platform :ios, '8.0'

source 'https://bitbucket.org/prolificinteractive/pibrary-ios'
source 'https://github.com/CocoaPods/Specs.git'

#Per pod basis warning inhibits? =>  use :inhibit_warnings => true
inhibit_all_warnings!

link_with 'Bellerophon'

use_frameworks!

#Pods list
# Currently using the Swift 2 branches of each pods, need to update to the main branch when Swift 2 is released.
# pod 'Alamofire', '~> 1.3'
# pod 'AlamofireObjectMapper', '~> 0.7'
pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :branch => 'swift-2.0'
pod 'ObjectMapper', :git => 'https://github.com/Hearst-DD/ObjectMapper.git', :branch => 'swift-2.0'
pod 'AlamofireObjectMapper', :git => 'https://github.com/tristanhimmelman/AlamofireObjectMapper.git', :branch => 'swift-2.0'