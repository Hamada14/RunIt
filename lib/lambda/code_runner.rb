# frozen_string_literal: true

require 'tempfile'

module Lambda
  # Class responsible to execute code.
  class CodeRunner
    attr_accessor :sandboxer, :timeout
    TEMP_FILE_NAME = 'sandboxed_temp_file.rb'
    COMPILER = 'ruby'

    def initialize(sandboxer, timeout = 5)
      @sandboxer = sandboxer
      @timeout = timeout
    end

    def execute_code(code, input) # rubocop:disable MethodLength
      sandboxed_code = sandboxer.sandbox_code(code)
      temp_file = create_tempfile(sandboxed_code)
      read_io, write_io = IO.pipe
      write_io.write(input)
      execution_output = ExecutionOutput.new
      begin
        run_process(temp_file, read_io, write_io)
      rescue ChildProcess::TimeoutError => e
        execution_output.add_exception(e)
      end
      temp_file.close
      execution_output.add_output(read_io.read)
      execution_output
    end

    private

    def run_process(temp_file, write_io, read_io)
      ChildProcess.build(COMPILER, temp_file.path).tap do |process|
        process.io.stdout = write_io
        process.io.stderr = write_io
        process.io.stdin = read_io
        process.start
        begin
          process.poll_for_exit(@timeout)
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
