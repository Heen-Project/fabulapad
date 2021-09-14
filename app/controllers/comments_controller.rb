class CommentsController < ApplicationController
    before_action :require_user, only: [:create, :destroy]
    before_action :is_owner, only: [:destroy]

    def create
        @comment = Comment.new(comment_params)
        @comment.save
        flash[:notice] = "Comment added."
        redirect_to @comment.story
    end

    def destroy
        @comment = Comment.find(params[:id])
        @comment.destroy
        flash[:notice] = "Comment removed."
        redirect_to @comment.story
    end 

    private
    def comment_params
        params.require(:comment).permit(:user_id, :story_id, :content)
    end

    def is_owner
        if current_user != @user && !current_user.is_admin?
            flash[:alert] = "You only can modify your own comment" 
            redirect_to :back
        end
    end
    
end
