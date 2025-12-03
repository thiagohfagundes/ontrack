# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Perfil atualizado com sucesso."
    else
      flash.now[:alert] = "Não foi possível atualizar o perfil."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    # ajuste conforme campos que quer permitir editar
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :avatar)
  end
end
