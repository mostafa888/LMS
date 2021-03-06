class HomeController < ApplicationController
  
  def index
  	if current_user
      @posts= Post.where("user_id IN(?) OR user_id = ?",Follow.select(:followable_id).where(:follower_id => current_user.id), current_user.id).order("created_at DESC")
      render :feed
	  end
  end

  def add_post
    authenticate_user!
    post= Post.new(:content => params[:status])
    current_user.posts << post
    redirect_to(:controller => 'home' ,:action => 'index')
  end

   def delete_post
    authenticate_user!
    post = current_user.posts.find_by(params[:id])
    if post.nil? then
     redirect_to(:controller => 'home' ,:action => 'index')
     return
    end
    post.destroy
    redirect_to(:controller => 'home' ,:action => 'index')
  end


  def update
    params.permit!
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
        format.json { respond_with_bip(@post) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@post) }
      end
    end
  end

  private
  def post_params
    params.require(:post).permit!
  end



  def about
  end

  def us
  end
  def contact
  end
  
end