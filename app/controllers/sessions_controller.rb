class SessionsController < ApplicationController
  def new
    
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) then
      # flash.now[:success] = "login Successfully"
      if user.activated?
        log_in(user)
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or(user)
      else
        flash[:warning] = "Accont Not Activated, Check Your Email To Active It!"
        redirect_to(root_url)
      end
    else
      flash.now[:danger] = "Invalid Email Or Wrong Password"
      render('new')
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
  def require_params
     params.require(:session).permit(:details)
  end
end
