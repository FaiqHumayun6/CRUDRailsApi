class ArticlesController < ApplicationController
    respond_to :json

    def index
        @articles = Article.where(creator_id: current_user.id)
        render json: {
        status: { code: 200, message: 'Articles index',data: @articles }
        }
    end


    def show
        @article = Article.find(params[:id])
        render json: {
        status: { code: 200, message: 'Required article ',data: @article }
        }
    end

    def create
        if Article.create(create_attributes)
            render json: {code: 200, message: 'Article created'}
        else
            render json: {code: 200, message: 'Article not created'}
        end
    end
    
    private

    def create_attributes
        params[:article][:creator_id] = current_user.id
        params.require(:article).permit(:name, :creator_id)
    end
end
  