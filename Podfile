platform :ios, '12.0'

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end
end

def install_common()
  pod 'RxSwift'
  pod 'RxCocoa'
end

target 'VNPAY_Challenge' do
  use_frameworks!
  install_common()
end
