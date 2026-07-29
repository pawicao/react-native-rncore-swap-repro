Pod::Spec.new do |spec|
  spec.name = 'IndependentPod'
  spec.version = '1.0.0'
  spec.summary = 'Minimal pod for the RNCore configuration-swap reproducer'
  spec.homepage = 'https://example.invalid/IndependentPod'
  spec.license = { :type => 'MIT' }
  spec.author = 'Reproducer'
  spec.source = { :path => '.' }
  spec.platform = :ios, '15.1'
  spec.source_files = 'IndependentPod.m'
end
