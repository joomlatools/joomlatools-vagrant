module Puppet
  module Util

    class SettingValue

      def initialize(setting_value, subsetting_separator = ' ', default_quote_char = nil)
        @setting_value = setting_value
        @subsetting_separator = subsetting_separator

        default_quote_char ||= ''

        if @setting_value
          unquoted, @quote_char = unquote_setting_value(setting_value)
          @subsetting_items = unquoted.scan(Regexp.new("(?:(?:[^\\#{@subsetting_separator}]|\\.)+)"))  # an item can contain escaped separator
          @subsetting_items.map! { |item| item.strip }
          @quote_char = default_quote_char if @quote_char.empty?
        else
          @subsetting_items = []
          @quote_char = default_quote_char
        end
      end

      def unquote_setting_value(setting_value)
        quote_char = ""
        if (setting_value.start_with?('"') and setting_value.end_with?('"'))
          quote_char = '"'
        elsif (setting_value.start_with?("'") and setting_value.end_with?("'"))
          quote_char = "'"
        end

        unquoted = setting_value

        if (quote_char != "")
          unquoted = setting_value[1, setting_value.length - 2]
        end

        [unquoted, quote_char]
      end

      def get_value

        result = ""
        first = true

        @subsetting_items.each { |item|
          result << @subsetting_separator unless first
          result << item
          first = false
        }

        @quote_char + result + @quote_char
      end

      def get_subsetting_value(subsetting, use_exact_match=:false)

        value = nil

        @subsetting_items.each { |item|
          if(use_exact_match == :false and item.start_with?(subsetting))
            value = item[subsetting.length, item.length - subsetting.length]
            break
          elsif(use_exact_match == :true and item.eql?(subsetting))
            return true
          end
        }

        value
      end

      def add_subsetting(subsetting, subsetting_value, use_exact_match=:false)

        new_item = subsetting + (subsetting_value || '')
        found = false

        @subsetting_items.map! { |item|
          if use_exact_match == :false and item.start_with?(subsetting)
            value = new_item
            found = true
          elsif use_exact_match == :true and item.eql?(subsetting)
            value = new_item
            found = true
          else
            value = item
          end

          value
        }

        unless found
          @subsetting_items.push(new_item)
        end
      end

      def remove_subsetting(subsetting, use_exact_match=:false)
        if use_exact_match == :false
          @subsetting_items = @subsetting_items.map { |item| item.start_with?(subsetting) ? nil : item }.compact
        else
          @subsetting_items = @subsetting_items.map { |item| item.eql?(subsetting) ? nil : item }.compact
        end
      end
    end
  end
end
