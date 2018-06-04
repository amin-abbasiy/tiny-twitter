class PasswordresetsController < ApplicationController
  before_action(:get_user, only: [:edit, :update])
  before_action(:valid_user, only: [:edit, :update])
  before_action(:check_expiration, only: [:edit, :update])
  def new
  end
  
  def create
    # :passwordreset value come from form_for :passwordreset name
     @user = User.find_by(email: params[:passwordreset][:email].downcase)
      if @user then
        @user.create_reset_token
        @user.email_reset_token
        flash[:info] = "Password Resset Email Your Box"
        redirect_to(root_url)
      else
        flash.now[:danger] = "User Not Found!"
        render 'new'
      end
  end

  def edit
  end
  
  def update
      if params[:user][:password].empty? then
         @user.error.add(:password, "cant be blank!")
         render 'edit'
      elsif @user.update_attributes(user_params)
        log_in @user
        @user.update_attributes(:reset_digest, nil)
        flash[:success] = "Password Updated!"
        redirec_to @user
      else
        render 'edit'
      end
  end

  private

  def user_params
      params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
     @user = User.find_by(email: params[:email])
  end
  def valid_user
     unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        redirect_to root_url
     end
  end
  def check_expiration
      if @user.passwrod_rrest_expired? then 
         flash[:danger] = "Token Expired!"
         redirect_to new_passwordreset_path 
      end
  end
  def passwrod_rrest_expired?
     reset_send_at < 2.hours.ago  # Less Than 2 Hour
  end
end
