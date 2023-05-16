# frozen_string_literal: true

class User < ActiveRecord::Base
  has_secure_password
  # virtual attributes
  # attr_reader :title # only getter
  # attr_writer :title #only setter

  # attr_accessor :title #only getter & setter

  def title=(perfix)
    self.name = "#{perfix} #{name}" # self needed?
  end

  def title
    name
  end

  # serialized attributes
  serialize :user_preferences, JSON

  belongs_to :role, inverse_of: :user # - ?   it won't query the nested assiosications it will read from memory instead DB
  has_many :user_interests # , root: :user_interests_attributes
  validates :name, presence: true, length: { minimum: 2, maximum: 10 } # min 5 char, max 20
  before_save :validate_role, if: proc { |user| user.role_id? }

  validates_with NameValidator
  default_scope { where.not(name: nil) }
  # run query without default scope
  # scope :find_user_by_role, ->(id=2) {where("role_id=?",id)}
  scope :find_user_by_role, ->(id) { where(role_id: id) } # work - ex? Yes. it work tooo
  scope :find_user_by_role_and_no, ->(id, phone_number) { where(role_id: id, phone_number: phone_number) }
  after_destroy :check_user_record
  # multi argument in scope
  # combining/chaning multiple scopes

  accepts_nested_attributes_for :user_interests

  validates_uniqueness_of :email, scope: :role_id

  attr_protected :email
  # attr_accessible :name

  private

  def validate_role
    if Role.where(id: role_id).empty? # self.role.empty?
      # errors.add(:name, "must be greater than 3")
      errors[:role] << 'must be valid role'
      return false # false
    end

    return if Role.where(id: role_id).present?

    errors[:role] << 'must be valid role'
    false # false
  end

  def check_user_record
    raise 'Atleasy one user should present' if User.count.zero?
  end
end

#  DONE
#
# custom validation
#     Done --> added name validation
# proc in callback
#     Calback used for conditonal wiht proc block
#
# create record with association
#     @user = User.new(name: "sathish")
#     @user.save
#     @user.user_interests.create(name:"tv2")
#
#     #@@@ Do above in single transaction/save
#
#
# build / create
#     @user_interests =  UserInterest.new("TV")
#     @user_interests.build_user(:name => "sath");
#     @user_interests.save
#
# type of updates
#     update --> callback & validation
#     update_all --> Not validation & callback, update all the rows was selected condtions  User.update_all("email = 'sa@sa.com'" ) or User.where("name = 'sahish'").update_all("email = 'sa@sa.com'" )
# delete /destroy
#     Delete won't call any callback like before_delete/destroy or after destroy
#     destroy will call callback and we have revoke delete action based on before_destroy callbacks return false.
#
# @@@ save/update, update_attributes (variation)
#
# @@@ callback hierarchy
#     before_validation
#     after_validation
#     before_save
#     around_save
#     before_create/update/destroy
#     around_create/update/destroy
#     after_create/update/destroy
#     after_save
#     after_commit / after_rollback
#
#     *destroy:  don't have save/validate
#
#
# custom SQL query
#         ActiveRecord::Base.connection.exec_query("select * from users")
# @@@ - avoiding sql injection in custom query
#         ActiveRecord::Base.connection.exec_query("select * from users where id = ? ", params[:userId])  # Active records parse the arugument variable
#
#  # scopes  default/custom
#     default: It applied detaul for all exitcut even we will use custom scope n
#     custom:
#         we can define some short form in the scope.

#
# virtual attributes
# serialized attributes
# migration - column data type change - int to big int
# migration - delete index
#
# strong param, mass assigment
# unique validation - not in DB
# validation - atleast one user should present
