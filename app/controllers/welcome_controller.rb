class WelcomeController < ApplicationController
  def index
    flash[:notice] = "欢迎来到第九块！"
  end 
end
