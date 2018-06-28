Pod::Spec.new do |s|
  s.name             = "AKTheme"
  s.version          = "2.0.0"
  s.summary          = "Assembly Kit Theme Utilities"
  s.description      = <<-DESC
                       Theme uses plist files containing images, fonts and colors to provide an easy way for theming an iOS application
                       DESC
  s.homepage         = "http://ibm.com"
  s.documentation_url = "http://www.ibm.com/mobilefirst"
  s.screenshots      = [ "./Documentation/screen_1.png" ]
  s.license          = { :type => "IBM License", :file => "LICENSE" }
  s.author           = 'IBM'
  s.source           = { :git => "git@INMBZP4112.in.dst.ibm.com:apple-coc-frameworks-private/aktheme.git", :tag => "RELEASE-#{s.version}", :submodules => true }

  s.requires_arc = false
  s.ios.deployment_target = '8.0'

  s.public_header_files = 'AKTheme/Sources/**/*.h'
  s.source_files = 'AKTheme/Sources/**/*.{h,m,swift}'
  s.exclude_files = 'AKTheme/Resources/Supporting Files/Info.plist'

  s.ios.frameworks = 'UIKit'

end
