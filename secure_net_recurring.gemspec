# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "secure_net_recurring/version"

Gem::Specification.new do |s|
  s.name        = "secure_net_recurring"
  s.version     = SecureNetRecurring::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["wenbo"]
  s.email       = ["yiyun6674@hotmail.com"]
  s.homepage    = "http://rubygems.org/gems/secure_net_recurring"
  s.summary     = "Standing on the shoulder of gem activemerchant,this gem implements SecureNet's AutoBill feature"
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "activemerchant",  "~>1.32.1"
end
