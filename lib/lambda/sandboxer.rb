# frozen_string_literal: true

# require 'lambda/whitelisted_methods'
require_relative 'whitelisted_methods'
module Lambda
  # Sandboxes the ruby code by removing defined methods.
  class Sandboxer
    def initialize; end

    def sandbox_code(code)
      <<-STRING
        #{SAND_BOXER}
        #{code}
      STRING
    end

    SAND_BOXER =
      <<~HEREDOC
        def whitelist_singleton_methods(klass, whitelisted_methods_sym)
          klass = Object.const_get(klass)
          undef_methods = (klass.singleton_methods(false) - whitelisted_methods_sym)

          undef_methods.each do |method|
            klass.singleton_class.send(:undef_method, method)
          end
        end

        def whitelist_constants
          (Object.constants - #{WhiteListedMethods::ALLOWED_CONSTANTS}).each do |const|
            Object.send(:remove_const, const) if defined?(const)
          end
        end

        whitelist_singleton_methods(:Kernel, #{WhiteListedMethods::KERNEL_SINGLETON_METHODS})
        whitelist_constants()

        Kernel.class_eval do
         def `(*args)
           raise NoMethodError, "Execution is unavailable"
         end

         def system(*args)
           raise NoMethodError, "System calls can't be used"
         end
        end

      HEREDOC
  end
end
