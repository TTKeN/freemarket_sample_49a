class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production? #本番環境でのみBasic認証を行う
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller? 
  before_action :set_category, :set_brand

  def configure_permitted_parameters
    added_attrs = [:nickname, :mail_address, :password, :password_confirm, :last_name, :first_name, :last_name_kana, :first_name_kana, :birth_year, :birth_month, :birth_day, :phone_number]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_updata, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end

  def set_category
    @categorys = Category.where(parent_id: nil)
  end

  def set_brand
    @brands = Brand.order("created_at DESC").where.not(id: 1)
  end

  private

  def production?
    Rails.env.production?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
  end
  end
end
