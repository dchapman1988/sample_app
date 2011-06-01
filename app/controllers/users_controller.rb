class UsersController < ApplicationController
  before_filter :authenticate,         :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user,         :only => [:edit, :update]
  before_filter :admin_user,           :only => :destroy
  before_filter :signed_in_user,       :only => [:new, :create]
  #before_filter :avoid_destroy_myself, :only => :destroy

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    unless signed_in?
      @user = User.new
      @title = "Sign up"
    else
      flash[:info] = "You're already logged in, so you cannot create a new account."
      redirect_to root_path
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = nil
      @user.password_confirmation = nil
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user.admin? && current_user?(@user)
      flash[:error] = "You cannot delete yourself!"
      redirect_to users_path
    else
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_path 
    end
  end

  def signed_in_user
    if signed_in?
      flash[:error] = "You're already logged in..."
      redirect_to root_path
    end
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    #def avoid_destroy_myself
    #  @user = User.find(params[:id])
    #  redirect_to users_path, :notice => "You cannot destroy yourself!"
    #end
end
