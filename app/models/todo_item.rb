class TodoItem
  include Mongoid::Document
  include Mongoid::Enum
  include ActiveModel::Validations

  enum :status, %i[start finish not_started]
  validates_presence_of :name
  validates_uniqueness_of :name
  field :name, type: String
  field :status, type: Integer, default: 0
  field :is_deleted, type: Boolean, default: false


  has_and_belongs_to_many :tags

end
