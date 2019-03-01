require 'pathname'

module LazyLogger
  class Configuration
    attr_accessor :file_directory

    def initialize
      @file_directory = Pathname.new(Dir.pwd)
    end
  end
end

