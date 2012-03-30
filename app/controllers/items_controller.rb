#coding: utf-8

class ItemsController < ApplicationController

  require 'kconv'
  require 'date'
  require 'mini_magick'
  layout "product_search"

     def admin
    @admin = Item.paginate(:page => params[:page],
                           :order =>'dead_line ASC',
                           :conditions => {"user_id" => session[:user][:id] },
                           :per_page =>10)
  end
  
  def finish
    @detail = Item.find(params[:id])
    @comments = @detail.bids.reverse
    @pictures = @detail.pictures
    @photo = []
     @pictures.each do |picture|
      file = picture.photo
      name = picture.file_name
      File.open("public/images/#{name}", 'wb') { |f| f.write(file) }
      image = MiniMagick::Image.from_file("public/images/#{name}")
      image.resize"200x200"
      File.open("public/images/sm_#{name}", 'wb') 
      image.write("public/images/sm_#{name}")
      @photo << {:small=>"/images/sm_#{name}",:large => "/images/#{name}"}
    end
  end 

  def new
    @item = Item.new
    @picture = Picture.new
  end

  def  create
    @item = Item.new(params[:item])
    if @item.save
      redirect_to :controller => "items", :action => "show", :id => @item.id
    else
      render :action => "new" #ここがredirect_toだと、入力した内容が消えてしまう
    end
    end
      
      
  def picture_create
    @pictures = params[:photos]
    begin
   Picture.transaction do
     @pictures.each do |picture|
      @picture = Picture.new(params[:picture])
      id = params[:picture][:item_id]
      name = picture.original_filename
      @picture.content_type = picture.content_type
      @picture.item_id = id
      @picture.valid_filename?
      name = name.kconv(Kconv::SJIS, Kconv::UTF8) #ここで文字コードを変更している。
      File.open("public/docs/#{id}", 'wb') { |f| f.write(picture.read) }
      image = MiniMagick::Image.open("public/docs/#{id}")
      image.resize "400x400"
      @picture.photo = image.to_blob 
      @picture.item_id = id
      @picture.file_name = name
      @picture.save!
     end
   end
   render :action =>"ok"
   rescue
    render :action =>"error"
   end
   end


    

  def show
    @item = Item.find(params[:id])
  end
  
  def editshow
    @item = Item.find(params[:id])
  end


  def edit
    @item = Item.find(params[:id])
    @picture = @item.pictures
    @a = @picture.count
  end

  def update
    
      @item = Item.find(params[:id])
      @pictures = params[:photos]
  begin
   Picture.transaction do
    if @pictures != nil
     @pictures.each do |picture|
        @picture = Picture.new(params[:picture])
        id = @item.id
        name = picture.original_filename
        @picture.content_type = picture.content_type
        @picture.valid_filename?
        name = name.kconv(Kconv::SJIS, Kconv::UTF8) #ここで文字コードを変更している。
        File.open("public/docs/#{id}", 'wb') { |f| f.write(picture.read) }
        image = MiniMagick::Image.open("public/docs/#{id}")
        image.resize "400x400"
        @picture.photo = image.to_blob 
        @picture.item_id = id
        @picture.file_name = name
        @picture.save
      end
     end
    end
    if @item.update_attributes(params[:item])
      redirect_to :controller => "items",:action => "editshow", :id => @item.id
    else
       redirect_to :controller => "items",:action => "editshow", :id => @item.id
   end
    rescue
        redirect_to :controller => "items",:action => "error",
       end

   end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to :controller => 'items', :action => 'admin'
  end

    

end
