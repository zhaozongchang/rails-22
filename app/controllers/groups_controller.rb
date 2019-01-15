class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :descroy, :join, :quit]
  before_action :find_group_and_check_permission, only: [:edit, :update, :descroy]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], per_page: 5)
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

  def join
    @group = Group.find(params[:id])
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本讨论群成功"
    else
      flash[:warning] = "你已经是本讨论版成员了"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本讨论群"
    else
      flash[:warning] = "你不是本讨论群成员，怎么退出 傻蛋"
    end

    redirect_to group_path(@group)
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
