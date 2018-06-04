module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id #Because temporary cookies created using the session method are automatically encrypted,
    end
    def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end
    def current_user
        if (user_id = session[:user_id]) then
          @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.permanent.signed[:user_id])
          user = User.find_by(id: user_id)  
          if user && user.authenticated?(:remember, cookies[:remember_token]) then
             log_in(user)
             @current_user = user
          end
        end
    end
    def logged_in?
        !current_user.nil?
    end
    def logout
       forget(current_user)
       session.delete(:user_id)
       @current_user = nil       
    end
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    def current_user?(user)
        user == current_user
    end

    def redirect_back_or(default)
        redirect_to(session[:forward] || default)
        session.delete(:forward)
    end

    def store_location
        session[:forward] = request.original_url if request.get?
    end
    def is_admin?
        # adminer = User.find_by(:admin)
       if @current_user[:admin] then
          @am_admin = @current_user[:id]
         return true
       else
         return false
       end
    end
end
