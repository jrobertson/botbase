Gem::Specification.new do |s|
  s.name = 'botbase'
  s.version = '0.2.2'
  s.summary = 'Provides bot functionality primarily for use by the ' + 
      'sps_bot gem.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/botbase.rb']
  s.add_runtime_dependency('mtlite', '~> 0.4', '>=0.4.1')
  s.add_runtime_dependency('simple-config', '~> 0.7', '>=0.7.2')
  s.signing_key = '../privatekeys/botbase.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/botbase'
end
