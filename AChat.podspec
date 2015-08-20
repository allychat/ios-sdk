Pod::Spec.new do |s|
  s.name         = "AChat"
  s.version      = "0.0.4"
  s.summary      = "The AChat Framework."
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/allychat/ios-sdk'
  s.author       = { "Alexandr Turyev" => "ekklesiarhia@gmail.com"}
  s.platform     = :ios, "7.1"
  s.source       = { :git => "https://github.com/allychat/ios-sdk.git", :tag => "0.0.4" }
  s.framework  = "AChat"
  s.library   = "icucore"
  s.requires_arc = true
  s.ios.vendored_frameworks = 'AChat.framework'
end
