# frozen_string_literal: true

require 'active_support/concern'
require 'active_support/core_ext/module'
require 'active_support/tagged_logging'

module LazyLogger
  module BaseLogging
    extend ActiveSupport::Concern

    included do
      delegate :logger, to: "self.class"
    end

    private

    module ClassMethods
      def logger_setup(file: )
        class_eval <<-STR
          class << self
            def logger
              @logger ||= ActiveSupport::TaggedLogging.new(
                Logger.new('#{file}', "weekly")
              )
            end

            delegate :error, :debug, :fatal, :info, :warn, to: :logger
          end
        STR
      end
    end

  end
end
