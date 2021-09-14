class UsersController < ApplicationController
    before_action :get_user, only: [:show, :edit, :update, :destroy, :follow, :unfollow, :follower, :following]
    before_action :require_user, only: [:edit, :update, :destroy, :follow, :unfollow]
    before_action :is_owner, only: [:edit, :update, :destroy, :follower, :following]

    def follow
        current_user.followings << @user
        redirect_to @user
    end
    
    def unfollow
        current_user.followed_users.find_by(following_id: @user.id).destroy
        redirect_to @user
    end

    def follower
        @users = @user.followers.paginate(page: params[:page], per_page: 6).order(created_at: :desc)
    end

    def following
        @users = @user.followings.paginate(page: params[:page], per_page: 6).order(created_at: :desc)
    end

    def index
        if params[:search]
            @users = User.where("lower(username) LIKE ?", "%#{params[:search]}%").paginate(page: params[:page], per_page: 6).order(created_at: :desc)
        else
            @users = User.paginate(page: params[:page], per_page: 6).order(created_at: :desc)
        end
    end

    def show
        if params[:search]
            @stories = @user.stories.where("lower(title) LIKE ?", "%#{params[:search]}%").paginate(page: params[:page], per_page: 5).order(created_at: :desc)
        else
            @stories = @user.stories.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
        end
    end

    def new
        @user = User.new
    end

    def edit
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "Welcome #{@user.username}, you have successfully signup."
            redirect_to @user
        else
            render 'new'
        end
    end

    def update 
        if @user.update(user_params)
            flash[:notice] = "Account information was updated successfully."
            redirect_to @user
        else
            render 'edit'
        end
    end

    def destroy 
        @user.destroy
        session[:user_id] = nil if current_user == @user
        flash[:notice] = "The account and associated story deleted successfully"
        redirect_to root_path
    end

    private
    def get_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

    def is_owner
        if current_user != @user && !current_user.is_admin?
            flash[:alert] = "You only can modify your own account" 
            redirect_to @user
        end
    end

end