class PagesController < ApplicationController

  def home
    redirect_to recipes_path if logged_in?
  end

  def about
    @no_footer = true
  end

  def help
  end

  def testimonials
    @no_footer = true
  end
end
