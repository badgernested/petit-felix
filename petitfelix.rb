#!/usr/bin/env ruby
require "./lib/petit-felix"

### CLI interface for petitfelix

felix = PetitFelix::Felix.new(cl_args: ARGV)
