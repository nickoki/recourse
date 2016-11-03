class Api::PostsController < ApplicationController

  # Protect API from malicious sessions
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  # Set @post DRYness
  before_action :set_post, only: [ :show, :update, :destroy, :add_favorite, :remove_favorite, :vote ]

  # Check JWT for valid user, (maybe add :new and :edit)
  before_action :authenticate_request!, only: [ :create, :update, :destroy, :add_favorite, :remove_favorite, :vote ]



  # GET /posts
  def index
    @posts = Post.all
    render :json => @posts.to_json(:include => [:favorites, :votes, :user])
  end

  # GET /posts/1
  def show
    # @post defined in before_action
    render :json => @post.to_json(:include => [:favorites, :votes, :user])
  end

  # POST /posts
  def create
    @post = Post.create!(post_params.merge(user: current_user))
  end

  # PATCH/PUT /posts/1
  def update
    # @post defined in before_action
    puts "update called"
    if !belongs_to_current_user?(@post)
      puts "if true"
      # flash[:alert] = "You may only edit a post you created."
      # redirect_to root
      return
    else
      puts "if false"
      @post.update(post_params)
    end
    puts "final line"
  end

  # DELETE /posts/1
  def destroy
    # @post defined in before_action
    if !belongs_to_current_user?(@post)
      # flash[:alert] = "You may only delete a post you created."
      # redirect_to root
      return
    else
      @post.destroy
    end
  end



  # FAVORITES!
  # POST /posts/1/favorite
  def add_favorite
    # @post defined in before_action
    @favorite = @post.favorites.new(user: current_user)
    @favorite.save
  end

  # DELETE /posts/1/favorite
  def remove_favorite
    # @post defined in before_action
    @favorite = @post.favorites.find_by(user: current_user)
    @favorite.destroy
  end



  # VOTES
  # POST /posts/1/vote
  def vote
    # @post defined in before_action
    @vote = @post.votes.find_by(user: current_user)
    if !@vote
      @vote = @post.votes.create({
          user: current_user,
          vote_type: vote_params[:vote_type]
        })
    elsif @vote[:vote_type] == vote_params[:vote_type]
      @vote.destroy
    else
      @vote.update(vote_params)
    end
  end



  private

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def belongs_to_current_user?(object)
      puts "belongs_to_current_user is about to return: "
      puts object[:user_id] == current_user[:id]
      return object[:user_id] == current_user[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:id, :title, :link, :level, :desc_what, :desc_why, :desc_who, :user_id, :pub_date, :created_at, :updated_at)
    end

    def vote_params
      params.require(:vote).permit(:vote_type)
    end
end
