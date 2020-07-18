class Schedule < ApplicationRecord
	validates :_ID, presence: true
  validates :_ID, uniqueness: true
end
