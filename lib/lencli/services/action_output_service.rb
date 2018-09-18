require "lencli/output/csv_action_output"
require "lencli/output/html_action_output"
require "lencli/services/callable/callable"

module LenCLI
  class ActionOutputService
    attr_reader :errors

    include LenCLI::Callable

    def initialize(action, options)
      @errors = []
      @action = action
      @output_format = options[:output_format]
      @output_path = options[:output_path]
    end

    def call
      begin
        output_file.write(file_contents)
        output_file.close
      rescue Errno::EISDIR => error
        @errors << "Cannot write to #{@output_path} as it's a directory."
      rescue Errno::EACCES => error
        @errors << "Cannot write to #{@output_path} due to permissions."
      end
      self
    end

    private

    def file_contents
      output_klass.new(@action, @output_path).output
    end

    def output_file
      File.open(@output_path, 'w')
    end

    def output_klass
      Object.const_get(output_klass_name)
    end

    def output_klass_name
      "LenCLI::#{@output_format.capitalize}ActionOutput"
    end
  end
end
