# frozen_string_literal: true

require_relative File.join('.', 'lib', 'oh_snap', 'version')

Gem::Specification.new do |spec|
  spec.name          = 'oh_snap'
  spec.version       = OhSnap::VERSION
  spec.author        = 'migl'
  spec.email         = 'hello@migl.dev'
  spec.files         = Dir['lib/oh_snap/**/*', 'README.md', 'LICENSE.txt'] + [File.join('lib', 'oh_snap.rb')]
  spec.summary       = 'Snapshots for Ruby tests'

  spec.description   = 'OhSnap is a Ruby library that provides snapshot testing capabilities for Ruby applications, '\
                       'allowing developers to easily capture and compare snapshots of serializable structures.'
  spec.homepage      = 'https://github.com/migl/oh_snap'
  spec.license       = 'MIT'
  spec.metadata      = {
    'github_repo' => 'ssh://github.com/migl/oh_snap',
    'source_code_uri' => 'https://github.com/migl/oh_snap'
  }

  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 3.0.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
end
