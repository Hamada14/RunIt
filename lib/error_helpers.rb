# frozen_string_literal: true

require 'sinatra/base'

# Helpers used for displaying errors in the HTML pages.
module ErrorHelpers
  def print_error(errors, parameter)
    parameter = parameter.to_sym
    return if errors.nil? || errors[parameter].nil?
    <<~HEREDOC
      <div class=\'alert alert-danger' role='alert'>
        #{errors[parameter]}
      </div>
    HEREDOC
  end

  Sinatra.helpers ErrorHelpers
end
