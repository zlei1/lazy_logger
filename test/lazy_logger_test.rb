require_relative 'test_helper'

require 'fileutils'

class LazyLoggerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::LazyLogger::VERSION
  end

  def test_log
    LazyLogger.test.info "hello world"
    lines = IO.readlines("test.log")

    assert_equal "hello world", lines.last.strip

    FileUtils.rm_f("test.log")
  end

end
