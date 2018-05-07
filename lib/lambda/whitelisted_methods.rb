# frozen_string_literal: true

module Lambda
  # Methods to be whitelisted.
  module WhiteListedMethods
    # rubocop:disable SymbolArray
    ALLOWED_CONSTANTS = [
      :ArgumentError, :Array, :BasicObject, :Bignum, :Binding, :Class, :Comparable, :Complex,
      :ConditionVariable, :Continuation, :Data, :Encoding, :EncodingError,
      :Enumerable, :Enumerator, :Errno, :Exception, :FalseClass, :Fixnum, :Float, :FloatDomainError,
      :Hash, :IO, :IOError, :IndexError, :Integer, :Interrupt, :Kernel, :KeyError, :LoadError,
      :LocalJumpError, :Marshal, :MatchData, :Math, :Method, :Module, :Mutex, :NameError, :NilClass,
      :NoMemoryError, :NoMethodError, :NotImplementedError, :Numeric, :Object, :ObjectSpace, :Proc,
      :Queue, :Random, :Range, :RangeError, :RegexpError, :RuntimeError, :RUBY_VERSION,
      :RUBY_RELEASE_DATE, :RUBY_PLATFORM, :RUBY_PATCHLEVEL, :RUBY_REVISION, :RUBY_DESCRIPTION,
      :RUBY_COPYRIGHT, :RUBY_ENGINE, :RUBYGEMS_ACTIVATION_MONITOR, :ScriptError,
      :SecurityError, :SizedQueue, :StandardError, :StopIteration, :String, :Struct, :Symbol,
      :SyntaxError, :SystemCallError, :SystemExit, :SystemStackError, :TimeTracePoint, :TrueClass,
      :TypeError, :UnboundMethod, :ZeroDivisionError, :fatal, :unknown, :FrozenError, :Warning,
      :NIL, :StringIO, :STDIN, :STDOUT, :STDERR, :UncaughtThrowError, :TRUE, :FALSE, :ARGF,
      :Monitor, :Rational, :Gem, :DidYouMean, :Regexp, :TracePoint, :RUBY_ENGINE_VERSION,
      :TOPLEVEL_BINDING, :ClosedQueueError, :Time, :EOFError, :UnicodeNormalize, :RbConfig,
      :SignalException, :Signal
    ].freeze

    KERNEL_SINGLETON_METHODS = [
      :abort, :Array, :at_exit, :binding, :block_given?, :catch, :Complex, :eval, :exit, :exit!,
      :fail, :Float, :format, :gets, :global_variables, :Hash, :Integer, :iterator?, :lambda,
      :local_variables, :loop, :p, :print, :printf, :proc, :putc, :puts, :raise, :rand, :Rational,
      :readline, :readlines, :require, :select, :set_trace_func, :sleep, :sprintf, :srand, :String,
      :throw, :trace_var, :untrace_var, :URI, :warn
    ].freeze
    # rubocop:enable SymbolArray
  end
end
