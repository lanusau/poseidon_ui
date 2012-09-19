Target.all.each do |t|
t.monitor_password = t.monitor_password
t.save!
end
