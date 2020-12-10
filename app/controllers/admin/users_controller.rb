class Admin::UsersController < Admin::FacadeController
  include UsersHelper
  before_action :find_user, only: [:show, :destroy]

  def index
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def show
  end
  
  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, success: "Les informations de cet utilisateur ont été mises à jour"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.js { }
      format.html { redirect_to admin_users_path, success: "Le profil de cet utilisateur a bien été supprimé" }
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :description, :avatar)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
