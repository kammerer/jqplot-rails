module JQPlot
  module Rails
    module Helpers
      def plot(dom_id, data, options = {})
        data = value_for_javascript(data)
        options = value_for_javascript(options)

        <<-END.strip
          jQuery.jqplot('#{dom_id}', #{data}, #{options})
        END
      end

      def plot_renderer(name)
        lambda { "jQuery.jqplot.#{name.to_s.camelize}Renderer" }
      end
 
      # Works like Rails built-in +options_for_javascript+, but unlike
      # it allows +value+ to be nested hash, contain array values or
      # to be a scalar value. It is also possible to eval snippet of
      # javascript to obtain value for an option like this:
      #
      #   value_for_javascript(:color => lambda { "someJavaScriptFunction()" })
      #
      def value_for_javascript(value)
        if value.is_a?(Hash)
          new_value = {}
          value.each do |k, v|
            new_value[k.to_s.camelize(:lower)] = value_for_javascript(v)
          end
          options_for_javascript(new_value)
        elsif value.is_a?(Array)
          "[#{value.collect { |v| value_for_javascript(v) }.join(',')}]"
        elsif value.is_a?(Numeric)
          value.to_s
        elsif value.is_a?(String)
          array_or_string_for_javascript(value)
        elsif value.is_a?(Proc)
          value.call
        elsif value == false
          "false"
        elsif value == true
          "true"
        elsif value.nil?
          "null"
        else
          raise ArgumentError, "Type #{value.class.name} not supported. Patches welcome."
        end
      end
    end
  end
end
