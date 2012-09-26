# Tasks for Poseidon

# Random password generation utility
def random_password(size = 8)
    chars1 = (('a'..'z').to_a + ('A'..'Z').to_a) - %w(i o 0 1 l 0 I O)
    chars2 = (('a'..'z').to_a + ('0'..'9').to_a + ['_'] + ('A'..'Z').to_a) - %w(i o 0 1 l 0 I O)

    ((1..1).collect{|a| chars1[rand(chars1.size)]}.to_a + (1..size-1).collect{|b| chars2[rand(chars2.size)]}.to_a).join
end

namespace :poseidon do
  desc "Create administrator user in Poseidon"
  task :create_admin_user => :environment do
    # Expect login=name in ARGV[1] (ARGV[0] has rake task name)
    login = ARGV[1].split("login=")[1] if ARGV[1].present?
    if login.nil?
      puts("Please specify parameter login=xxx")
    else
      password = random_password(8)
      user = User.new(
        :login=>login,
        :password=>password,
        :password_confirmation=>password,
        :access_level=>0)

      user.create_sysdate=DateTime.now
      user.update_sysdate=DateTime.now
      user.save!
      puts "User #{login} created with password: #{password}"
    end
    
  end
end
