#coding: utf-8


class Item < ActiveRecord::Base
  require 'date'
  
	belongs_to :user
	has_many :bids
  has_many :pictures

  validates :name, 
    :presence => true
  validates :category,
    :presence => true
  validates :price,
    :presence => true,
    :numericality =>{:only_integer => true}
  validates :condition,
    :presence => true
  validate :date_validate?

    
    def date_validate?
       date1 = Date.valid_date?(self.dead_line.year,self.dead_line.month,self.dead_line.day)
       debugger
      if date1.blank?
       errors.add('日付が間違っています。ご確認下さい。')
      end
    end
   
  CATEGORIES=[["Antique",1],["Art", 2],["Baby",3],["Business & Industrial",4],["Cameras & Photo",5],["Cars,Boats,Vehicle & Parts",6],["Cell Phones & PDAs",7],["Clothing Shoes & Accessories",8],["Coins & Paper Money",9],["Collectibles",10],["Computers & Networking",11],["Consumer Electronics",12],["Crafts",13],["Dolls & Bears",14],["DVDs & Moneys",15],["Entertainment Memorabilia",16],["Gift Cards & Coupons",17],["Health Beauty",18],["Home & Garden",19],["Jewelry & Watches",20],["Music",21],["Pet Supplies",22],["Pottery & Glass",23],["Real Estate",24],["Sporting Goods",25],["Stamps & Tickets",26],["Toys & Hobbies",27],["Travel",28],["Video Games",29],["Everything Else",30]]
end
