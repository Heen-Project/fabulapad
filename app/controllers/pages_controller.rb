class PagesController < ApplicationController

    def home
        redirect_to stories_path if logged_in?
    end

end
