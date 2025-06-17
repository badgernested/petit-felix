# frozen_string_literal: true

require_relative "lib/version"

Gem::Specification.new do |spec|
  spec.name = "petit-felix"
  spec.version = PetitFelix::Felix::VERSION
  spec.authors = ["PunishedFelix"]
  spec.email = ["labadore1844@gmail.com"]

  spec.summary = "Ruby gem that creates document files from markdown, such as on Jekyll blogs."
  spec.description = "Converts markdown files into PDF documents using options passed in a hash."
  spec.homepage = "https://github.com/badgernested/petit-felix"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.files = []
  spec.files.append(Dir['lib/*'].keep_if { |file| File.file?(file) })
  spec.files.append(Dir['lib/felix/*'].keep_if { |file| File.file?(file) })
  spec.files.append(Dir['lib/task/*'].keep_if { |file| File.file?(file) })
  spec.files.append(Dir['lib/worker/*'].keep_if { |file| File.file?(file) })
  spec.files.append(Dir['lib/worker/pdf_writer/*'].keep_if { |file| File.file?(file) })
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "prawn", "~> 2.5", ">= 2.5.0"
  spec.add_runtime_dependency "prawndown-ext", "~> 0.1.12"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
