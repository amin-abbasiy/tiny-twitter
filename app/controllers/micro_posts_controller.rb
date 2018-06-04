class MicroPostsController < ApplicationController
    before_action(:logged_in_user?, only: [:create, :destroy])
    before_action(:corrent_user, only: :destroy)
    def create
        @micropost = current_user.microposts.build(micropost_params)
        if @micropost.save then
           flash["success"] = "MicroPost Created"
           redirect_to(root_url)
        else
            # @feed_items = []
            render('static_pages/home')
        end

    end

    def destroy
        @micropost.destroy
        flash[:success] = "Post Deleted"
        redirect_to request.referrer || root_url
    end

    private

    def micropost_params
       params.require(:micropost).permit(:content, :picture)
    end

    def corrent_user
         if is_admin? then
            @micropost = Micropost.find_by(id: params[:id])
        else
            @micropost = current_user.microposts.find_by(id: params[:id]) 
            redirect_to root_url if @micropost.nil?
        end
    end

end
