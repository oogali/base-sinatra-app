
module AppName
  class Application < Sinatra::Application
    helpers do
      def authenticate!(username, password)
        self.current_user = Db::User.authenticate username, password
      end

      def current_user
        session[:user]
      end

      def current_user=(user)
        session[:user] = user
      end

      def valid_session?
        current_user and current_user.id.to_i > 0
      end

      def partial(page, options = {})
        render :haml, page, options.merge!(:layout => false), { :partial => true }
      end

      def is_partial?
        locals[:partial] == true
      end

      def build_validation_error_msg(obj)
        obj.errors.messages.map do |k,v|
          "#{k.to_s} " + v[0..-2].join(', ') + (v.length > 1 ? ' and ' : '') + v.last
        end.flatten.join("<br/>\n")
      end
    end
  end
end
