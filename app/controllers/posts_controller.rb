class PostsController < ApplicationController
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
    @user = current_user
    @tag_list = Tag.all             
    @posts = Post.all                
    @post = current_user.posts.new
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user_id == current_user.id
      render "edit"
    else
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    @book.user_id = current_user.id
    if @book.update(book_params)
      flash[:notice]="You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])  
    @tags = @post.tags
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end
  
  def search
    @tag = Tag.find(params[:tag_id])  #クリックしたタグを取得
    @posts = @tag.posts.all           #クリックしたタグに紐付けられた投稿を全て表示
  end

  private
  def post_params
    params.require(:post).permit(:content, :image)
  end


end
