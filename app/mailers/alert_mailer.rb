class AlertMailer < ActionMailer::Base

  def critical_count(user, item)
    @item = item
    mail(:to => user.email, :subject => "Critical count", :from => "innv.demoapp@gmail.com")
  end
end
