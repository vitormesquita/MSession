Pod::Spec.new do |s|
  s.name             = 'MSession'
  s.version          = '1.0.1'
  s.summary          = 'A simple way to manager session in your application'
  s.homepage         = 'https://github.com/vitormesquita/MSession'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vitor mesquita' => 'vitor.mesquita09@gmail.com' }
  s.source           = { :git => 'https://github.com/vitormesquita/MSession.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files = "Source/**/*"
  end

  s.subspec "Session" do |ss|
    ss.source_files = "Source/Keychain/*", "Source/Session/*"
  end

  s.subspec "Auth" do |ss|
    ss.source_files = "Source/Keychain/*", "Source/Auth/*"
  end
end