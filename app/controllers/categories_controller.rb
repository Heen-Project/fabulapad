class CategoriesController < ApplicationController
    before_action :get_category, only: [:show, :edit, :update, :destroy]
    before_action :require_admin, except: [:index, :show]

    def index
        if params[:search]
            @category = Category.where("lower(name) LIKE ?", "%#{params[:search].downcase}%").paginate(page: params[:page], per_page: 6).order(created_at: :desc)
        else
            @category = Category.paginate(page: params[:page], per_page: 6).order(created_at: :desc)
        end
    end

    def show
        if params[:search]
            @stories = @category.stories.where("lower(title) LIKE ?", "%#{params[:search].downcase}%").paginate(page: params[:page], per_page: 5).order(created_at: :desc)
        else
            @stories = @category.stories.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
        end
    end
    
    def new
        @category = Category.new
    end

    def edit
    end

    def create
        @category = Category.new(category_params)
        @category.name = @category.name.downcase if @category.valid?
        if @category.save
            flash[:notice] = "New category added successfully"
            redirect_to @category
        else
            render 'new'
        end
    end

    def update
        if @category.update(category_params)
            flash[:notice] = "Category was renamed successfully."
            redirect_to @category
        else
            render 'edit'
        end
    end

    def destroy
        @category.destroy
        redirect_to categories_path
    end 

    private
    def get_category
        @category = Category.find(params[:id])
    end

    def category_params
        params.require(:category).permit(:name)
    end

    def require_admin
        if !(logged_in? && current_user.is_admin?)
            flash[:alert] = "Only admin can perform that action"
            redirect_to categories_path
        end
    end

end