class SessionsController < ApplicationController
 

  def new
  end
  
  def create
    @user = User.authentication(params[:mail_address],params[:password]).first
    if @user.nil?
      redirect_to login_url
    else
      self.current_user=@user
      redirect_to :controller => 'top', :action => 'mylist'
    end
  end

  def destory
   session.clear
   redirect_to :action=>'new'
  end
end
