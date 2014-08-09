class ApplicationController < ActionController::Base
  protect_from_forgery
  clear_helpers # ヘルパーモジュールはコントローラ名と同じものだけ読み込む

  before_filter :authenticate_user, :reject_unverified_user

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  
  private
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    elsif cookies.signed[:user_id]
      @current_user ||= User.find_by_id_and_auto_login_token(
        cookies.signed[:user_id], cookies.signed[:auto_login_token])
    end
  end
  helper_method :current_user

  def authenticate_user
    redirect_to [ :new, :session ] unless current_user
  end

  def reject_unverified_user
    redirect_to [ :unverified, :account ] unless current_user.verified?
  end

  def render_404(exception)
    raise exception unless Rails.env.production? # 本番環境以外では通常にエラー表示
    render "errors/not_found", :status => 404
  end
end
