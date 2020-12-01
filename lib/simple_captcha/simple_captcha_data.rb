module SimpleCaptcha
  class SimpleCaptchaData < ::ActiveRecord::Base

    self.table_name = "simple_captcha_data"

    class << self
      def get_data(key)
        data = where(key: key).first || new(key: key)
      end
      
      def remove_data(key)
        # delete_all(["#{connection.quote_column_name(:key)} = ?", key])
        # => wrong (wrong number of arguments (given 1, expected 0))

        where(["#{connection.quote_column_name(:key)} = ?", key]).delete_all
        #=> right

        clear_old_data(1.hour.ago)
      end
      
      def clear_old_data(time = 1.hour.ago)
        return unless Time === time
       # delete_all(["#{connection.quote_column_name(:updated_at)} < ?", time])
       where(["#{connection.quote_column_name(:updated_at)} < ?", time]).delete_all
      end
    end
  end
end
