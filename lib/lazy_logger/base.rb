# frozen_string_literal: true

module LazyLogger
  module Base
    def self.included base
      base.include InstanceMethods
      base.extend ClassMethods

      base.class_eval do
      end
    end

    module ClassMethods
      def register(file: )
        class_eval <<-STR
          class << self
            def logger
              @logger ||= Logger.new('#{file}')
            end

            %w(error debug fatal info warn).each do |level|
              define_method(level) do |*args|
                logger.send(level, *args)
              end
            end
          end
        STR
      end
    end

    module InstanceMethods
    end
  end
end
