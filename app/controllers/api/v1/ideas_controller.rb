module Api::V1
  class IdeasController < Api::BaseApiController

    # below is method that i've created the same way as implemented in Devise.
    # before_action :authenticate_user_from_token
    #before_action :authenticate_user!

    def index
      if params[:page].present? && params[:per].present?
        ideas = Idea.page(params[:page]).per(params[:per])
      else
        ideas = Idea.order(id: :desc)
      end
      render json: ideas
    end

    def search
      ideas = Idea.all if params[:search].nil?
      ideas = Idea.where('title LIKE :search OR body LIKE :search', search: "%#{params[:search]}%")
      render json: {ideas: ideas}
    end

    def image_upload
      idea = Idea.find_by(title: 'Ruby')
      idea.update_attributes(image: params[:image])
    end

    def create
      idea = Idea.new(idea_params)
      if idea.save
        render json: idea
      else
        render json: idea.errors, status: :unprocessable_entity
      end
    end

    def show
      idea = Idea.find(params[:id])
      render json: idea
    end

    def update
      idea = Idea.find(params[:id])
      idea.update_attributes(idea_params)
      render json: idea
    end

    def destroy
      idea = Idea.find(params[:id])
      if idea.destroy
        head :no_content, status: :ok
      else
        render json: idea.errors, status: :unprocessable_entity
      end
    end

    private

    def idea_params
      params.require(:idea).permit(:title, :body)
    end

  end
end
