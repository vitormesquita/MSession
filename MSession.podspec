Pod::Spec.new do |s|
  s.name             = 'MSession'
  s.version          = '0.1.6'
  s.summary          = 'A simple way to manager session in your application'
  s.homepage         = 'https://github.com/vitormesquita/MSession'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vitor mesquita' => 'vitor.mesquita09@gmail.com' }
  s.source           = { :git => 'https://github.com/vitormesquita/MSession.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Source/*.swift'

end