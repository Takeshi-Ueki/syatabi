# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :user_state, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: "ゲストユーザーでログインしました"
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  # ユーザーが退会済みでないか判定
  def user_state
    # 入力されたemailからアカウントを取得
    @user = User.find_by(email: params[:user][:email])
    # アカウントが取得できなければメソッド終了
    return if !@user
    # 取得したアカウントのパスワードと入力されたパスワードが一致しているか
    # 取得したアカウントが退会済みであれば新規登録画面へ遷移
    if @user.valid_password?(params[:user][:password]) && !@user.active?
      redirect_to new_user_registration_path, alert: "退会済みユーザーです、新しいアカウントを作り直してください"
    end
  end
end
