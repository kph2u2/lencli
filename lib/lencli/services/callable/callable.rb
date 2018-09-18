module LenCLI
  module Callable
    module ClassMethods
      def call(*args)
        self.new(*args).call
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    def successful?
      !@errors&.any?
    end
  end
end
