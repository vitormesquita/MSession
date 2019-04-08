Pod::Spec.new do |s|
  s.name             = 'MSession'
  s.version          = '0.1.6'
  s.summary          = 'A simple way to manager session in your application'
  s.homepage         = 'https://github.com/vitormesquita/MSession'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vitor mesquita' => 'vitor.mesquita09@gmail.com' }
  s.source           = { :git => 'https://github.com/vitormesquita/MSession.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.default_subspec = "All"

  s.subspec "All" do |ss|
    ss.source_files  = "Source/**/*"
  end

  s.subspec "UIKit" do |ss|
    ss.source_files  = "Source/UIKit+Extensions/*.swift"
    ss.framework = "UIKit"
  end

  s.subspec "Foundation" do |ss|
    ss.source_files  = "Source/Foundation+Extensions/*.swift"
    ss.framework = "Foundation"
  end

end