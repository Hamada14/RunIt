# frozen_string_literal: true

require 'childprocess'
require 'tempfile'

require 'lambda/execution_output'

module Lambda
  # Class responsible to execute code.
  class CodeRunner
    attr_accessor :sandboxer, :timeout
    TEMP_FILE_NAME = 'sandboxed_temp_file.rb'
    COMPILER = 'ruby'
    DEFAULT_TIMEOUT = 5

    def initialize(sandboxer, timeout = DEFAULT_TIMEOUT)
      @sandboxer = sandboxer
      @timeout = timeout
    end

    def execute_code(code, input = nil) # rubocop:disable MethodLength, AbcSize
      sandboxed_code = sandboxer.sandbox_code(code)
      temp_file = create_tempfile(sandboxed_code)
      read_io, write_io = IO.pipe
      write_io.write(input)
      execution_output = ExecutionOutput.new
      begin
        run_process(temp_file, write_io, input = nil)
      rescue ChildProcess::TimeoutError => e
        execution_output.add_exception(e)
      end
      write_io.close
      execution_output.add_output(read_io.read)
      temp_file.close
      execution_output.output
    end

    private

    # Putting input to the programs isn't yet enabled.
    def run_process(temp_file, write_io, input = nil) # rubocop:disable MethodLength
      ChildProcess.build(COMPILER, temp_file.path).tap do |process|
        process.io.stdout = write_io
        process.io.stderr = write_io
        process.start
        begin
          process.poll_for_exit(@timeout)
        rescue ChildProcess::TimeoutError => e
          process.stop # Tries harsher method
          raise e
        end
      end
    end

    def create_tempfile(sandboxed_code)
      file = Tempfile.new(TEMP_FILE_NAME)
      file.write(sandboxed_code)
      file.rewind
      file
    end
  end
end
