require "lencli/output/csv_action_output"
require "lencli/output/html_action_output"
require "lencli/services/callable/callable"

module LenCLI
  class ActionOutputService
    include LenCLI::Callable

    def initialize(action, options)
      @action = action
      @output_format = options[:output_format]
      @output_path = options[:output_path]
    end

    def call
      begin
        output_file.write(file_contents)
        output_file.close
      rescue Errno::EISDIR => error
        add_error("Cannot write to #{@output_path} as it's a directory.")
      rescue Errno::EACCES => error
        add_error("Cannot write to #{@output_path} due to permissions.")
      end
      self
    end

    private

    def file_contents
      @file_contents ||= output_klass.new(@action, @output_path).output
    end

    def output_file
      @file ||= File.open(@output_path, 'w')
    end

    def output_klass
      @klass ||= Object.const_get(output_klass_name)
    end

    def output_klass_name
      @klass_name ||= "LenCLI::#{@output_format.capitalize}ActionOutput"
    end
  end
end
