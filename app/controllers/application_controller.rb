# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  # rescue_from User::NotAuthorized, with: :deny_access

  before_action :set_locale
  before_action :authenticate_request
  after_action :set_csrf_cookie
  attr_reader :current_user
  respond_to :json

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    return nil unless request.env['HTTP_ACCEPT_LANGUAGE']

    parsed_locale = params[:locale] || request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/)[0]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    return if @current_user

    render json: { error: t('not_authorized') }, status: 401
  end

  def set_csrf_cookie
    response.headers['CSRF-TOKEN'] = form_authenticity_token
  end

  def  deny_access
    
  end
end
