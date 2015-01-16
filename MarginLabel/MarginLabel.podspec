Pod::Spec.new do |spec|
  spec.name         = 'MarginLabel'
  spec.version      = '1.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/LoganWright/PodPool'
  spec.authors      = { 'Logan Wright' => 'logan.william.wright@gmail.com' }
  spec.summary      = 'ARC and GCD Compatible Reachability Class for iOS and OS X.'
  spec.source       = { :git => 'https://github.com/LoganWright/PodPool.git', :tag => 'MarginLabel-1.0' }
  spec.source_files = 'Files/LGMarginLabel.{h,m}'
  spec.platform     = :ios
end
