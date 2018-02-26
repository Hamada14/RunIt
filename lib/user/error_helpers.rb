require 'sinatra/base'

module User
  module Registration
    # Helpers used for displaying errors in the HTML pages.
    module ErrorHelpers
      def print_error(errors, parameter)
        return if errors.nil? || errors[parameter].nil?
        "<div class=\"alert alert-danger\" role=\"alert\">
          #{errors[parameter]}
        </div>"
      end

      Sinatra.helpers User::Registration::ErrorHelpers
    end
  end
end
