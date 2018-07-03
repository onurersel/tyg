Pod::Spec.new do |s|
  s.name         = "tyg"
  s.version      = "0.0.1"
  s.summary      = "Collection of personal utilities."

  s.homepage     = "https://github.com/onurersel/tyg"
  s.license      = { :type => "Apache", :file => "LICENSE" }
  s.author             = { "Onur Ersel" => "onurersel@gmail.com" }
  s.social_media_url   = "http://twitter.com/ethestel"
  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/onurersel/tyg.git", :tag => "#{s.version}" }
  s.source_files  = "tyg/**/*.{swift}"
  s.exclude_files = "Pods", "dev", "tygTests"
  s.swift_version = "4.1"

  s.dependency "Bond"
end
