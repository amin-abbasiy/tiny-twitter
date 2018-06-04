class AccontActivationsController < ApplicationController

    def edit
       user = User.find_by(email: params[:email])
       if user && !user.activated? && user.authenticated?(:activation, params[:id]) then
          activate
          log_in(user)
          flash[:success] = "Accont Activated My Friend"
          redirect_to user
       else
          flash[:danger] = "Token Is Invalid Or Expired!"
          redirect_to(root_url)
       end 
    end



end
