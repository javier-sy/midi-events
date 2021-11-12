$:.unshift(File.join('..', 'lib'))

require 'rubygems'
gem 'mocha'
require 'minitest/autorun'
require 'mocha/minitest'
require 'shoulda-context'

require 'midi-events'
