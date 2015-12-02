Pod::Spec.new do |s|
  s.name         = "NHAlignmentFlowLayout"
  s.version      = "0.1.0-mirego"
  s.summary      = "A UIFlowLayout sublass that allows you to set the alignment instead of being only justified."
  s.description  = <<-DESC
UIFlowLayout defaults to a justified layout with no way to change this behavior. NHAlignmentFLowLayout comes
to fill this need allowing you to set the alignment to left or right (in a vertical scrolling layout) and top or bottom
(in a horizontal scrolling layout).
DESC
  s.homepage     = "http://github.com/nilsou/NHAlignmentFlowLayout"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Nils Hayat" => "nilsou@gmail.com" }
  s.source       = { :git => "https://github.com/mirego/NHAlignmentFlowLayout.git", :tag => "0.1.0-mirego" }
  s.source_files = 'NHAlignmentFlowLayout/*.{h,m}'
  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'
end
