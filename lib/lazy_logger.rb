require_relative "lazy_logger/version"
require_relative "lazy_logger/base_logging"

require 'active_support/inflector'
require 'pathname'

module LazyLogger
  class << self

    def method_missing(name, *args, &block)
      _klass_name ||= name.to_s.classify
      _file = log_file(name)
      
      class_eval <<-STR
        class #{_klass_name}
          include LazyLogger::BaseLogging

          logger_setup file: '#{_file}'
        end
      STR

      const_get(_klass_name)
    end

    private

    def current_path
      Pathname.new(Dir.pwd)
    end

    def bin_rails?
      File.exist?(File.join(path, 'bin', 'rails'))
    end

    def log_file(name)
      folder = if defined?(Rails) && bin_rails?
        Rails.root.join("log")
      else
        current_path.join("log")
      end

      FileUtils.mkdir_p folder unless folder.exist?

      file_path = "#{folder}/#{name}.log"
      file_path
    end
    
  end
end
