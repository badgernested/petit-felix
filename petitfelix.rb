#!/usr/bin/env ruby
require "./felix"

### CLI interface for petitfelix

felix = PetitFelix::Felix.new(cl_args: ARGV)
