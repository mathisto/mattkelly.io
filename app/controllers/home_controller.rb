class HomeController < ApplicationController
  def index
    @featured_projects = Project.first(3)
    @recent_posts = Post.all.first(3)
  end
end
