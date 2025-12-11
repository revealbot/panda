# frozen_string_literal: true

$LOAD_PATH.unshift(::File.join(::File.dirname(__FILE__), 'lib'))

require 'panda/version'

Gem::Specification.new do |s|
  s.name = 'panda-tiktok'
  s.version = Panda::VERSION
  s.required_ruby_version = '>= 3.0.0'
  s.summary = 'Ruby client for TikTok Marketing API'
  s.author = 'Revealbot'
  s.email = 'dev@revealbot.com'
  s.license = 'MIT'

  ignored = Regexp.union(
    /\A\.editorconfig/,
    /\A\.git/,
    /\A\.rubocop/,
    /\A\.travis.yml/,
    /\A\.vscode/,
    /\Atest/
  )
  s.files = `git ls-files`.split("\n").reject { |f| ignored.match(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'faraday', '~> 2.12.2'
end
