Pod::Spec.new do |s|
  s.name             = "SBTActionController"
  s.version          = "0.0.1"
  s.summary          = "SBTActionController acts as a Façade for UIActionSheet and UIAlertController"
  s.description      = <<-DESC
                       SBTActionController acts as a Façade for UIActionSheet and UIAlertController avoiding presentation related issues when using the deprecated UIActionSheet class to support pre iOS 8 versions.
                       DESC
  s.homepage         = "https://github.com/Subito-it/SBTActionController"
  s.license          = 'Apache License, Version 2.0'
  s.authors           = { "Mouhcine El Amine" => "mouhcine.elamine@subito.it",
                          "Luigi Parpinel" => "luigi.parpinel@subito.it"}
  s.source           = { :git => "https://github.com/Subito-it/SBTActionController.git", :tag => s.version.to_s }

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
