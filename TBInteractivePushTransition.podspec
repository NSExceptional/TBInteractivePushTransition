
Pod::Spec.new do |s|
  s.name             = 'TBInteractivePushTransition'
  s.version          = '1.0.0'
  s.summary          = 'The interactive push transition iOS was missing.'

  s.description      = <<-DESC
TBInteractivePushTransition is an interactive push transition triggered by a screen edge swipe from right to left.
                       DESC

  s.homepage         = 'https://github.com/NSExceptional/TBInteractivePushTransition'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NSExceptional' => 'tannerbennett@me.com' }
  s.source           = { :git => 'https://github.com/NSExceptional/TBInteractivePushTransition.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'TBInteractivePushTransition/Classes/*'
end
