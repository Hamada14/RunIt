# frozen_string_literal: true

module Lambda
  # Output of a code run.
  class ExecutionOutput
    attr_accessor :has_output, :output, :has_exception, :exception

    def initialize
      @has_output = false
      @has_exception = false
    end

    def add_output(output)
      @has_output = true
      @output = output
    end

    def add_exception(exception)
      @has_exception = true
      @exception = exception
    end
  end
end
