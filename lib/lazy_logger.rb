require_relative "lazy_logger/version"
require_relative "lazy_logger/base_logging"
require_relative "lazy_logger/configuration"

require 'active_support/inflector'

module LazyLogger
  class << self

    def configure
      configuration ||= Configuration.new
      yield(configuration) if block_given?
      configuration
    end

    def method_missing(name, *args, &block)
      _klass_name ||= name.to_s.classify
      file = log_file(name)
      
      class_eval <<-STR
        class #{_klass_name}
          include LazyLogger::BaseLogging

          logger_setup file: '#{file}'
        end
      STR

      const_get(_klass_name)
    end

    private

    def log_file(name)
      "#{configure.file_directory}/#{name}.log"
    end
    
  end
end
