class PostsController < ApplicationController
  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user
    if @post.save
    redirect_to group_path(@group)
  else
    render :new
   end
  end

  def edit
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    @post.group = @group
  end

  def update
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
    if @post.update(post_params)
    redirect_to account_posts_path,alert: "更新成功"
  else
    render :edit
  end
end

   def destroy
     @group = Group.find(params[:group_id])
     @post = Post.find(params[:id])
     @post.destroy
     redirect_to account_posts_path, alert: "更新成功"
   end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
