Pod::Spec.new do |spec|
  spec.name         = 'GitHubNetworking'
  spec.version      = '1.0'
  spec.license      = 'MPL 2.0'
  spec.homepage     = 'https://github.com/LoganWright/PodPool'
  spec.authors      = { 'Logan Wright' => 'logan.william.wright@gmail.com' }
  spec.summary      = 'ARC and GCD Compatible Reachability Class for iOS and OS X.'
  spec.source       = { :git => 'https://github.com/LoganWright/PodPool.git', :tag => 'GitHubNetworking-1.0' }
  spec.source_files = 'GitHubNetworking/**/*.{h,m}'
  spec.platform     = :ios
  spec.dependency 'AFNetworking', '2.5.0'
end
