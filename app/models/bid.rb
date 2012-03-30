#coding: utf-8
class Bid < ActiveRecord::Base
	belongs_to  :user
	belongs_to  :item
	#validates_presence_of :comment
  validates :comment,
	:presence => true
   #:uniqueness => true
end
