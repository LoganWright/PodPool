Pod::Spec.new do |spec|
  spec.name         = 'JSONMapping'
  spec.version      = '1.0'
  spec.license      = 'MPL 2.0'
  spec.homepage     = 'https://github.com/LoganWright/PodPool'
  spec.authors      = { 'Logan Wright' => 'logan.william.wright@gmail.com' }
  spec.summary      = 'A class for mapping JSON to objects'
  spec.source       = { :git => 'https://github.com/LoganWright/PodPool.git', :tag => 'JSONMapping-1.0' }
  spec.source_files = 'JSONMapping/**/*.{h,m}'
end
