Gem::Specification.new do |s|
  s.name = 'botbase'
  s.version = '0.1.7'
  s.summary = 'Provides bot functionality primarily for use by the ' + 
      'sps_bot gem.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/botbase.rb']
  s.add_runtime_dependency('simple-config', '~> 0.6', '>=0.6.3')
  s.signing_key = '../privatekeys/botbase.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/botbase'
end
