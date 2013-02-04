ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "innv-demoapp.herokuapp.com",
    :user_name            => "innv.demoapp",
    :password             => "demoapp1234",
    :authentication       => "plain",
    :enable_starttls_auto => true
}