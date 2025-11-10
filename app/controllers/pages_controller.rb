class PagesController < ApplicationController
  def cv
  end

  def projects
  end

  def terminal_test
    render layout: "terminal_test"
  end
end
