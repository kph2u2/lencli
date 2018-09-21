module LenCLI
  module Callable
    module ClassMethods
      def call(*args)
        self.new(*args).call
      end
    end

    attr_reader :errors

    def self.included(base)
      base.extend(ClassMethods)
    end

    def successful?
      @errors ||= []
      !@errors&.any?
    end

    def add_error(error)
      @errors ||= []
      @errors << error
    end
  end
end
