require_relative "lazy_logger/version"
require_relative "lazy_logger/base"
require_relative "lazy_logger/configuration"

module LazyLogger
  class << self
    attr_accessor :configuration

    def configure
      configuration ||= Configuration.new
      yield(configuration) if block_given?

      configuration
    end

    def method_missing(name, *args, &block)
      _klass_name ||= name.to_s.split(/\_/).map(&:capitalize).join
      file = "#{configure.directory}/#{name}.log"
      
      class_eval <<-STR
        class #{_klass_name}
          include LazyLogger::Base

          register file: '#{file}'
        end
      STR

      const_get(_klass_name)
    end
  end
end
