class User < ActiveRecord::Base
 has_secure_password 
 end
#we told Ruby to add an authenticate method to our class (invisibly!) when the program runs.