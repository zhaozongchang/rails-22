class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :descroy]
  before_action :find_group_and_check_permission, only: [:edit, :update, :descroy]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
    redirect_to groups_path
  else
    render :new
   end
  end

  def edit
  end

  def update

    if @group.update(group_params)
    redirect_to groups_path, alert: "更新成功"
  else
    render :edit
   end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, alert: "删除成功"
  end

  private

  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "滚蛋，你不是群组建立者"
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
