Pod::Spec.new do |spec|
    spec.name             = 'MaskInterpreter'
    spec.version          = '1.0.0'
    spec.summary          = 'Interpreter for input masks from custom format to InputMask format.'
    spec.homepage         = 'https://github.com/surfstudio/MaskInterpreter'
    spec.author           = { 'Erik Basargin' => 'basargin.erik@gmail.com' }
    spec.social_media_url = 'https://github.com/surfstudio'
    spec.source           = { :git => 'https://github.com/surfstudio/MaskInterpreter.git', :tag => spec.version }
    spec.swift_version    = '5.0'

    spec.ios.deployment_target = '12.2'

    spec.source_files = 'Sources/**/*.swift'
    spec.framework    = 'Foundation'
end