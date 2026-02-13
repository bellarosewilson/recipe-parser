class PagesController < ApplicationController
 skip_before_action :authenticate_user!, only: [:home], raise: false
 
  def home
    if user_signed_in?
      redirect_to "/recipes"
    end 
  end
end
