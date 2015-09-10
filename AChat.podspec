Pod::Spec.new do |s|
  s.name         = "AChat"
  s.version      = "0.1.6"
  s.summary      = "The AChat Framework."
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/allychat/ios-sdk'
  s.author       = { "Alexandr Turyev" => "ekklesiarhia@gmail.com"}
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/allychat/ios-sdk.git", :tag => "0.1.6" }
  #s.source_files  = "AChatDemo/**/*.{h,m}"
  #s.exclude_files = "AChatDemo/Pods/**/*.{h,m}"
  # s.public_header_files = "Classes/**/*.h"
  s.framework  = "AChat"
  s.library   = "icucore"
  s.requires_arc = true
  s.ios.vendored_frameworks = 'AChat.framework'
  #s.dependency 'JSQSystemSoundPlayer', '~> 2.0'
  #s.dependency 'JSQMessagesViewController'

end
