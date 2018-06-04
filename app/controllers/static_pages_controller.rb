class StaticPagesController < ApplicationController
   def home
    if logged_in? then
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @user = User.find_by(params[:id])
    end
   end

   def hello
   
   end

   def about
   	
   end
   
end
