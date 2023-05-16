# frozen_string_literal: true

class UserWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 1
  def perform(user_id)
    puts "#{user_id} start deleting. "
    user = User.find(user_id)
    user&.destroy
    puts "#{user_id} deleted. "
  end
end
