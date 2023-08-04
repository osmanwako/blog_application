class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = User.includes(:posts, :comments, :likes).find_by(id:params[:user_id])
    @posts = @user.posts.includes(:comments, :likes)
  end

  def show
    @user = User.includes(:posts, :comments, :likes).find(id:params[:user_id])
    @post = @user.posts.find_by(params[:id])
    @comment = Comment.new
  end

  def new
    @user = current_user
    @post = Post.new
  end

  def create
    post = post_params
    @post = Post.create(author: current_user, title: post[:title], text: post[:text])
    @post.save
    @post.update_posts_counters
    redirect_to user_post_path(current_user, @post)
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
