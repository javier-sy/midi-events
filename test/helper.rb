# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'mocha'

require 'minitest/autorun'
require 'mocha/minitest'

require 'shoulda-context'

require 'midi-events'
