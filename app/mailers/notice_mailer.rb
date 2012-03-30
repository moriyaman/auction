#coding: utf-8
class NoticeMailer < ActionMailer::Base
  default :from => "mori0206@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.sendmail_confirm.subject
  
  def sendmail_confirm
    
  mail(:to => 'moriyamaf5@yahoo.co.jp',
         :subject => '登録ありがとうございます。') 
  end
end
