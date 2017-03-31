Pod::Spec.new do |s|
  s.name             = 'NTTesting'
  s.version          = '0.1.0'
  s.summary          = 'A short description of NTTesting.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Thuyen Trinh/NTKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Thuyen Trinh' => 'trinhngocthuyen@gmail.com' }
  s.source           = { :git => 'https://github.com/Thuyen Trinh/NTKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'NTTesting/Classes/**/*'
  
  # --- Dependencies --- #
  
end
