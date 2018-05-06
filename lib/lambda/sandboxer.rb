# frozen_string_literal: true

module Lambda
  # Sandboxes the ruby code by removing defined methods.
  class Sandboxer
    def initialize; end

    def sandbox_code(_code)
      <<-STRING
        #{SAND_BOXER}
        eval(%q(#{@code}))
      STRING
    end

    SAND_BOXER =
      <<~HEREDOC
        def whitelist_singleton_methods(klass, whitelisted_methods)
          klass = Object.const_get(klass)
          whitelisted_methods_sym = whitelisted_methods.map(&:to_sym)
          undef_methods = (klass.singleton_methods - whitelisted_methods_sym)

          undef_methods.each do |method|
            klass.singleton_class.send(:undef_method, method)
          end

        end

        def whitelist_methods(klass, whitelisted_methods)
          klass = Object.const_get(klass)
          whitelisted_methods_sym = whitelisted_methods.map(&:to_sym)
          undef_methods = (klass.methods(false) - whitelisted_methods_sym)
          undef_methods.each do |method|
            klass.send(:undef_method, method)
          end
        end

        def whitelist_constants
          (Object.constants - #{ALLOWED_CONSTANTS}).each do |const|
            Object.send(:remove_const, const) if defined?(const)
          end
        end

        whitelist_singleton_methods(:Kernel, #{KERNEL_SINGLETON_METHODS})
        whitelist_methods(:Kernel, #{KERNEL_METHODS})

        Kernel.class_eval do
         def `(*args)
           raise NoMethodError, "Execution is unavailable"
         end

         def system(*args)
           raise NoMethodError, "System calls can't be used"
         end
        end

        clean_constants
      HEREDOC
  end
end
