class StudentQuestion < ActiveRecord::Base
  belongs_to :student
  belongs_to :question

  has_many :entries
end
