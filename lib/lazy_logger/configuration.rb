require 'pathname'

module LazyLogger
  class Configuration
    attr_accessor :directory

    def initialize
      @directory = Dir.pwd
    end
  end
end

