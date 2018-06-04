class UsersController < ApplicationController
  before_action(:logged_in_user?, only: [:index, :edit, :update, :show, :destroy, :following, :followers])
  before_action(:corrent_user?, only: [:edit, :update])
  before_action(:admin_user, only: :destroy)
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def show
       @user = User.find(params[:id])
       @microposts = @user.microposts.paginate(page: params[:page])
       redirect_to root_url and return unless true    
  end

  def new
    @user = User.new
  end
  def create
    @user = User.new(user_parameters)
    if @user.save
        @user.send_activation_email
        redirect_to root_url
        flash[:info] = "Hey My Dear Friend #{@user.name} You Created Accont Succesfully Active It By Email."
    elsif
        render new_user_path
    end
  end
  def edit
    @user = User.find(params[:id])   
  end
  def update
    @user = User.find(params[:id])
    if(@user.update_attributes(user_parameters)) then
        flash[:success] = "Profile Updated"
        redirect_to @user
    else
       render('edit')
    end
  end

  def destroy
      User.find(params[:id]).destroy
      flash[:danger] = "User Deleted!"
      redirect_to users_url
  end

  def admin_user
     redirect_to(root_url) unless current_user.admin?
  end
  def following
     @title = "Following"
     @user = User.find(params[:id])
     @users = @user.following.paginate(page: params[:page])
     render 'show_follow'
  end
  def followers
     @title = "Followers"
     @user = User.find(params[:id])
     @users = @user.followers.paginate(page: params[:page])
     render 'show_follow'
  end
  private
  def user_parameters
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def corrent_user?
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
