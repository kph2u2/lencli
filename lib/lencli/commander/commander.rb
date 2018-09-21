require "lencli/services/file_matcher"
require "lencli/services/action_output_service"
require "lencli/actions/gps_extraction_action"

module LenCLI
  class Commander
    class CommanderError < StandardError; end

    def self.gps_grab(options)
      file_svc = FileMatcher.call(options)
      raise CommanderError, file_svc.errors unless file_svc.successful?

      action =
        GPSExtractionAction.call(file_svc.file_list, options[:filter_missing])

      output_svc = ActionOutputService.call(action, options)
      raise CommanderError, output_svc.errors unless output_svc.successful?
    end
  end
end
