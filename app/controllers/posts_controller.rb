class PostsController < ApplicationController
  def index
    @posts = Post.all
  rescue Errno::ENOENT
    # If the blog directory doesn't exist, show an empty array
    @posts = []
  end

  def show
    @post = Post.find(params[:id])
  rescue Errno::ENOENT
    # If the blog directory or file doesn't exist, redirect to index
    redirect_to posts_path, alert: "Post not found"
  end
end 