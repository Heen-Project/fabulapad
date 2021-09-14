class StoriesController < ApplicationController
    before_action :get_story, only: [:show, :edit, :update, :destroy]
    before_action :require_user, except: [:show, :index]
    before_action :is_owner, only: [:edit, :update, :destroy]

    def subscribed
        if params[:search]
            @stories = Story.subscribed(current_user.followings).where("lower(title) LIKE ?", "%#{params[:search].downcase}%").paginate(page: params[:page], per_page: 7).order(created_at: :desc)
        else
            @stories = Story.subscribed(current_user.followings).paginate(page: params[:page], per_page: 7).order(created_at: :desc)
        end
    end

    def show
        @comments = @story.comments.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
        @comment = Comment.new
    end

    def index
        if params[:search]
            @stories = Story.where("lower(title) LIKE ?", "%#{params[:search].downcase}%").paginate(page: params[:page], per_page: 7).order(created_at: :desc)
        else
            @stories = Story.paginate(page: params[:page], per_page: 7).order(created_at: :desc)
        end
    end

    def new
        @story = Story.new
    end

    def edit
    end

    def create
        @story = Story.new(story_params)
        @story.user = current_user
        if @story.save
            flash[:notice] = "Story was saved successfully."
            redirect_to @story
        else
            render 'new'
        end
    end 

    def update
        if @story.update(story_params)
            flash[:notice] = "Story was updated successfully."
            redirect_to @story
        else
            render 'edit'
        end
    end

    def destroy
        @story.destroy
        redirect_to stories_path
    end 

    private 
    def get_story
        @story = Story.find(params[:id])
    end

    def story_params
        params.require(:story).permit(:title, :content, category_ids: [])
    end

    def is_owner
        if current_user != @story.user && !current_user.is_admin?
            flash[:alert] = "Access only accessible by the owner" 
            redirect_to stories_path
        end
    end

end
