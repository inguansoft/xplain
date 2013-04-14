class LandingController < ApplicationController

  def index
    @page_suffix_title = " - miningful collaboration"
  end


  def login
    @page_session_user = User.authenticate(params[:user_name], params[:password])
    if @page_session_user
      session[:user_id] = @page_session_user.id
    else
      flash[:notice] = "Invalid member/password combination, please, try again"
    end
    redirect_to :action => :index
  end

  def logout
    if @page_session_user
      @page_session_user.last_logout_at = Time.now
      Status.get('logout').set @page_session_user, @page_session_user
      @page_session_user.save
      @page_session_user = nil
      session[:user_id] = nil
      redirect_to :action => :index
    else

    end
  end

  def signup
    @page_session_user = User.signup(params)
    if @page_session_user
      session[:user_id] = @page_session_user.id
    else
      flash[:notice] = "User might be already in use, please try a different user name"
    end
    redirect_to :action => :index
  end

end
