# frozen_string_literal: false

class UsersController < ApplicationController
  # callbacks
  # before_action :check_auth, only: [:user_by_id]
  after_action :write_res_log, except: %i[create index]
  rescue_from UserError, with: :user_not_found_error
  # - new action - 401, 403

  def index
    @users = User.all
  end

  def create
    @user = User.create(user_params)
    @user.save
    @user.errors { |key, value| puts key, value }
    render status: :created, json: {}
  rescue StandardError => e
    puts "An error of type #{e.class} happened, message is #{e.message}"
    render status: :failed, json: {}
  end

  def add_user_and_tags
    @user_interests = UserInterest.new('TV')
    @user_interests.build_user(name: 'sath')
    @user_interests.save
  end

  def user_by_id
    @user = User.find(params[:id])
    render status: :ok, json: @user
  end

  def update
    @id = params[:id]
    begin
      user = User.find(@id) # find will throw exception, find_by will return nil
      user.update_attributes(user_params)
      render json: { message: "User #{@id} failed" }
    rescue ActiveRecord::RecordNotFound
      # render json: { message: t('user_not_found', user_id: @id) }
      raise UserError.new("User #{@id} failed", @id)
    else
      render status: :internal_server_error, json: { message: t('internal_server_error') }
    end
  end

  def destroy
    @id = params[:id]
    UserWorker.perform_async(@id)
    render json: { message: "User #{@id} has been delete" }
  end

  def set_cookie
    cookies[:server_id] = '123123'
    cookies.signed.permanent[:user_id] = {
      value: 'u-1244',
      secure: true,
      httponly: true,
      expires: 1.hour # Time.utc(anytime)
      # domain & path, we can provide
    }
    # cookies.encrypted --> user can't view the data
    # cookies.signed --> user can't change the value read only
    # cookies.permanent --> rails default 20 uears for now
    render status: :ok, json: {}
  end

  def cutom_sql
    result = ActiveRecord::Base.connection.exec_query
    `'select * from users limt'`
    puts(result)
  end

  def user_not_found_error(exception)
    puts exception.user_id
    puts exception.message
    render json: { message: t('user_not_found', user_id: @id) }
  end
end

private
def user_params
  params.require(:user).permit(:name, :display_name, :email,
                               :phone_number, :role_id,
                               user_interests_attributes: [:name])
end

def write_res_log
  puts 'resposne log writer'
end

# before_action
# around_action
# after_action
#
# except will ignore if we provide if statement
#
