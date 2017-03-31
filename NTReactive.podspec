Pod::Spec.new do |s|
  s.name             = 'NTReactive'
  s.version          = '0.1.0'
  s.summary          = 'A short description of NTReactive.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Thuyen Trinh/NTKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Thuyen Trinh' => 'trinhngocthuyen@gmail.com' }
  s.source           = { :git => 'https://github.com/Thuyen Trinh/NTKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'NTReactive/Classes/**/*'
  
  # --- Dependencies --- #
  s.dependency 'ReactiveSwift'
  s.dependency 'ReactiveCocoa'
  # TODO: How about RxSwift?
  
end
