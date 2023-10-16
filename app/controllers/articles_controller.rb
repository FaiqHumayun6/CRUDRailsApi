class ArticlesController < ApplicationController
    respond_to :json

    def index
        @articles = current_user.articles.all
        render json: {
        status: { code: 200, message: 'Articles index',data: @articles }
        }
    end


    def show
        @article = current_user.articles.find(params[:id])
        render json: {
        status: { code: 200, message: 'Required article ',data: @article }
        }
    end

    def create
        debugger
        @article = current_user.articles.new(create_attributes)
        if @article.save
            render json: {code: 200, message: 'Article created'}
        else
            render json: {code: 200, message: 'Article not created'}
        end
    end
    
    private

    def create_attributes
        params.require(:article).permit(:name)
    end
end
  