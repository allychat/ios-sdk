Pod::Spec.new do |s|
  s.name         = "AllychatSDK.framework"
  s.version      = "2.0"
  s.summary      = "The Allychat Framework."
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/allychat/ios-sdk'
  s.author       = { "Alexandr Turyev" => "ekklesiarhia@gmail.com"}
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/allychat/ios-sdk.git", :tag => "2.0" }
  s.framework  = "AllychatSDK"
  s.requires_arc = true
  s.ios.vendored_frameworks = 'AllychatSDK.framework'
  s.dependency "AFNetworking"
  s.dependency "SocketRocket"

end
