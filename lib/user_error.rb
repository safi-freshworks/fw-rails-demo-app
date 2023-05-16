# frozen_string_literal: true

class UserError < StandardError
  attr_reader :user_id
  def initialize(msg = 'Default Error message in UserError', user_id)
    super(msg)
    @user_id = user_id
  end
end
