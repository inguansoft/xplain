class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :ensure_session_for_everyone

  #run this for every access to make sure we get a strong linkage with every visitor or member
  def ensure_session_for_everyone
    if session[:user_id]
      @page_session_user = User.session_member(session[:user_id])
    else
      @page_session_user = nil
    end
  end

end
