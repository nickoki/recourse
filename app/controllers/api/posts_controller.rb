class Api::PostsController < ApplicationController

  protect_from_forgery with: :null_session

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_request!, only: [
    # :new, :create,
    #:edit, :update, :destroy
  ]

  # GET /posts
  def index
    @posts = Post.all
    render json: @posts
  end

  # GET /posts/1
  def show
    @post = Post.find(params[:id])
    render json: @post
    # respond_to do |format|
    #   format.html { render :show }
    #   format.json { render json: @post  }
    # end

  end

  # GET /posts/new
  def new
    # relying on Angular Factories to handle all this biznas
    # @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    # @post = Post.create! post_params
    @post.save

    # respond_to do |format|
    #   if @post.save
    #     format.html { redirect_to @post, notice: 'Post was successfully created.' }
    #     format.json { render :show, status: :created, location: @post }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @post.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /posts/1
  def update
    @post = Post.find(post_params[:post])

    @post.update(post_params)
    # respond_to do |format|
    #   if @post.update(post_params)
    #     format.html { redirect_to @post, notice: 'Post was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @post }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @post.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /posts/1
  def destroy
    # @post.destroy
    # respond_to do |format|
    #   format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
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
      params.permit(:id, :level, :desc_what, :desc_why, :desc_who, :created_at, :updated_at, :pub_date)
    end
end
