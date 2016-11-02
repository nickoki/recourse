class Api::PostsController < ApplicationController

  # Protect API from malicious sessions
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  # Set @post DRYness
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # Check JWT for valid user, (maybe add :new and :edit)
  before_action :authenticate_request!, only: [ :create, :update, :destroy ]



  # GET /posts
  def index
    @posts = Post.all
    render :json => @posts.to_json(:include => [:favorites])
  end

  # GET /posts/1
  def show
    # @post defined in before_action
    render :json => @post.to_json(:include => [:favorites])
  end

  # POST /posts
  def create
    @post = Post.create!(post_params.merge(user: current_user))
  end

  # PATCH/PUT /posts/1
  def update
    # @post defined in before_action
    @post.update(post_params)
  end

  # DELETE /posts/1
  def destroy
    # @post defined in before_action
    @post.destroy
  end

  # FAVORITES!
  def add_favorite
    @post = Post.find(post_params[:id])
    @favorite = @post.favorites.new(user_id: 1)
    @favorite.save
  end

  def remove_favorite
    @post = Post.find(post_params[:id])
    @favorite = @post.favorites.find_by(user_id: 1)
    @favorite.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      # params.require(:post).permit(:title, :link)
      # .require(:post) causing errors with API requests
      params.permit(:id, :title, :link, :level, :desc_what, :desc_why, :desc_who, :user_id, :pub_date, :created_at, :updated_at)
    end
end
