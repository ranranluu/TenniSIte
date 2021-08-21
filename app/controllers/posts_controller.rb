class PostsController < ApplicationController
  
  def new
    @post = Post.new
  end


  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:name].split(nil)
    if @post.save
      @post.save_tag(tag_list)
      redirect_to post_path(@post)
    else
      @user = current_user
      @posts = Post.all
      render :index
    end
  end

  def index
    if params[:post].present?
      if params[:post].empty?
        @posts = Post.all
      else
        @posts = Post.where('content LIKE(?)', "%#{params[:post][:keyword]}%")
      end
    else
      @posts = Post.all
    end
    @user = current_user
    @tag_list = Tag.all
    @post = current_user.posts.new
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user_id == current_user.id
      render "edit"
    else
      redirect_to posts_path
    end
    @newpost = current_user.posts.new
  end

  def update
    @post = Post.find(params[:id])
    @post.user_id = current_user.id
    if @post.update(post_params)
      flash[:notice]="You have updated post successfully."
      redirect_to post_path(@post.id)
    else
      render :edit
    end
    @newpost = current_user.posts.new
  end

  def show
    @post = Post.find(params[:id])
    @tags = @post.tags
    @newpost = current_user.posts.new
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def tagsearch
    @tag = Tag.find(params[:tag_id])  #クリックしたタグを取得
    @posts = @tag.posts.all           #クリックしたタグに紐付けられた投稿を全て表示
    @newpost = current_user.posts.new
  end



  private
  def post_params
    params.require(:post).permit(:content, :image)
  end

end
