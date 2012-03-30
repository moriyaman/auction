
#coding: utf-8

class TopController < ApplicationController
  
  before_filter :login_required?
   layout "product_search"

  def index
    @items = Item.paginate(:page => params[:page],
                           :order =>'dead_line ASC',
                           :conditions => ['items.dead_line >= ?', Time.now],
                           :per_page =>10)
  end
    


  def admin
    @admin = Item.find(:all)
  end
  
  def detail
  	@detail = Item.find(params[:id])
  	@comments = @detail.bids.paginate(:page => params[:page],
  	                                  :order =>'created_at DESC',
  	                                  :per_page =>5)
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
 

  
  def get_image
    @picture = Picture.find(params[:id].to_i)
    file = @picture.photo
    name = @picture.file_name
    File.open("public/images/#{name}", 'wb') { |f| f.write(file) }
    image = MiniMagick::Image.from_file("public/images/#{name}")
    image.resize"200x200"
    File.open("public/images/#{name}_big", 'wb') 
    image.write("public/images/#{name}_big")
    @image_path = "public/images/#{name}"
    @image_path2 = "public/images/#{name}_big"
    send_file(@image_path2, :disposition => "inline", :type => "image/jpng")
   
   end
  
  def new
    @bid =Bid.new
  end
  
  def mylist
    @mylist =Item.paginate(:page => params[:page],
                       :order =>'dead_line ASC',
                       :per_page =>5,
                       :conditions => {"bids.user_id" => session[:user][:id]},
                       :include => :bids)
  end
    

    
  	 
  def create 
  	@bid = Bid.new(params[:bid])
     if @bid.save
  	    redirect_to :controller => "top", :action => "detail",:id => @bid.item_id 
  	 else 
  	   @detail=Item.find(:first,:conditions =>{"id" => @bid.item_id})
  	   render :action=>"detail",:id => @detail.id
  	 end
	 end
 
 	
 	
 def search  
  
   if    params[:item][:category] ==""
         @before_product = Item.where('name like ? ',"%" + params[:name] + "%" ).order('dead_line ASC')
         @product = @before_product.paginate(:page => params[:page],
                                             :conditions => ['items.dead_line >= ?', Time.now],
                                             :per_page =>10)
         render :action =>'search'    
   else
        @before_product = Item.where('name like ? AND category = ?',"%" + params[:name] + "%" ,params[:item][:category]).order('dead_line ASC')
        @product = @before_product.paginate(:page => params[:page],
                                            :conditions => ['items.dead_line >= ?', Time.now],
                                            :per_page =>10)
        render :action =>'search' 
   end  
 end

 def side_search   
  @before_product = Item.where('category = ?',params[:id]).order('dead_line ASC')
  @product = @before_product.paginate(:page => params[:page],
                                      :conditions => ['items.dead_line >= ?', Time.now],
                                      :per_page =>10)
      render :action =>'search'
 end  


  def comment_destroy
    @bid = Bid.find(params[:id])
    @detail=Item.find(:first,:conditions =>{"id" => @bid.item_id})
    @bid.destroy
    redirect_to :controller => 'top', :action => 'detail',:id => @detail.id
  end
  
  def newuser
    @user = User.new
  end
  
  def create_user
    @user = User.new(params[:user])
     if @user.save
    redirect_to :controller => "top", :action => "index"
     @mail = NoticeMailer.sendmail_confirm.deliver
     else 
    render :action=>"index",:id => @user.id
  end
  end
end
