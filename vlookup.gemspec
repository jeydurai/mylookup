# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vlookup/version"

Gem::Specification.new do |spec|
  spec.name          = "vlookup"
  spec.version       = Vlookup::VERSION
  spec.authors       = ["jeyaraj"]
  spec.email         = ["jeyaraj.durairaj@gmail.com"]

  spec.summary       = %q{Simulates Excel's Vlookup function}
  spec.description   = %q{Does vlookup on Excel file or MongoDB collections}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  #if spec.respond_to?(:metadata)
    #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  #else
    #raise "RubyGems 2.0 or newer is required to protect against " \
      #"public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.files << "lib/vlookup.rb"
  spec.files << "lib/vlookup/validator.rb"
  spec.files << "lib/vlookup/processor.rb"
  #spec.files << "lib/vlookup/reader.rb"
  #spec.files << "lib/vlookup/writer.rb"

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.executables << 'vlookup'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rubyXL", "~> 3.3", ">= 3.3.26"
  spec.add_development_dependency "mongo", "~> 2.4", ">= 2.4.1"
end
