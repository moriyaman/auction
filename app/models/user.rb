class User < ActiveRecord::Base

  scope :mail_is,lambda{|mail| where("mail_address = ?", mail) }
  scope :pass_is,lambda{|pass| where("password = ?", pass) }
  scope :authentication, lambda{|mail, pass| mail_is(mail).pass_is(pass) }
  has_many :items
  has_many :bids
end
