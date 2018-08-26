require 'time'
require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require 'awesome_print'
# Add simplecov

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Require_relative your lib files here!
#require_relative '../lib/driver'
require_relative '../lib/user'
require_relative '../lib/trip'
require_relative '../lib/trip_dispatcher'
