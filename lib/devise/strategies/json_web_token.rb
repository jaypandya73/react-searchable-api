
module Devise
  module Strategies
    class JsonWebToken < Base
      def valid?
        request.headers["Authorization"].present? &&
        request.headers["Authorization"].split(" ").size == 2 &&
        request.headers["Authorization"].split(" ").first == "Bearer"
      end

      def authenticate!
        if claims && claims['user_email'] && (user = User.find_by_email claims['user_email'])
          success!(user)
        else
          fail!('something went wrong!')
        end
      end

      def store?
        false
      end

      protected

      def claims
        @claims ||= ::JsonWebToken.new.decode(token) rescue nil
      end

      def token
        request.headers["Authorization"].split(" ").second
      end
    end
  end
end
