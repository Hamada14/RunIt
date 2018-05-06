# frozen_string_literal: true

module Lambda
  # Methods to be whitelisted.
  module WhiteListedMethods # rubocop:disable ModuleLength
    # rubocop:disable PercentSymbolArray
    ALLOWED_CONSTANTS = %i[
      :ArgumentError :Array :BasicObject :Bignum :Binding :Class :Comparable :Complex
      :Complex::compatible :ConditionVariable :Continuation :Data :Encoding
      :Encoding::CompatibilityError :Encoding::Converter :Encoding::ConverterNotFoundError
      :Encoding::InvalidByteSequenceError :Encoding::UndefinedConversionError :EncodingError
      :Enumerable :Enumerator :Enumerator::Generator :Enumerator::Lazy :Enumerator::Yielder
      :Errno :Exception :FalseClass :Fixnum :Float :FloatDomainError :Hash :IO
      :IO::EAGAINWaitReadable :IO::EAGAINWaitWritable :IO::EINPROGRESSWaitReadable
      :IO::EINPROGRESSWaitWritable :IO::EWOULDBLOCKWaitReadable :IO::EWOULDBLOCKWaitWritable
      :IO::WaitReadable :IO::WaitWritable :IOError :IndexError :Integer :Interrupt :Kernel
      :KeyError :LoadError :LocalJumpError :Marshal :MatchData :Math :Math::DomainError
      :Method :Module :Mutex :NameError :NilClass :NoMemoryError :NoMethodError
      :NotImplementedError :Numeric :Object :ObjectSpace :ObjectSpace::WeakMap :Proc
      :Queue :Random :Range :RangeError :Rational :Rational::compatible :Regexp :RegexpError
      :RuntimeError :ScriptError :SecurityError :SizedQueue :StandardError :StopIteration
      :String :Struct :Symbol :SyntaxError :SystemCallError :SystemExit :SystemStackError
      :TimeTracePoint :TrueClass :TypeError :UnboundMethod :ZeroDivisionError :fatal :unknown
    ].freeze
    # rubocop:enable PercentSymbolArray

    KERNEL_SINGLETON_METHODS = %w[
      Array
      binding
      block_given?
      catch
      chomp
      chomp!
      chop
      chop!
      eval
      fail
      Float
      format
      global_variables
      gsub
      gsub!
      Integer
      iterator?
      lambda
      local_variables
      loop
      method_missing
      proc
      raise
      scan
      split
      sprintf
      String
      sub
      sub!
      throw
    ].freeze

    KERNEL_METHODS = %w[
      ==
      binding
      block_given?
      catch
      chomp
      chomp!
      chop
      chop!
      clone
      dup
      eql?
      equal?
      eval
      fail
      format
      freeze
      frozen?
      global_variables
      gsub
      gsub!
      hash
      id
      initialize_copy
      inspect
      instance_eval
      instance_of?
      instance_variables
      instance_variable_get
      instance_variable_set
      instance_variable_defined?
      Integer
      is_a?
      iterator?
      kind_of?
      lambda
      local_variables
      loop
      methods
      method_missing
      nil?
      private_methods
      print
      proc
      protected_methods
      public_methods
      raise
      remove_instance_variable
      respond_to?
      respond_to_missing?
      scan
      send
      split
      sprintf
      String
      sub
      sub!
      taint
      tainted?
      throw
      to_a
      to_s
      type
    ].freeze
  end
end
