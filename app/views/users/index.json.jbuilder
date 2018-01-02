json.data @users, partial: 'users/user', as: :user
json.options do
	json.role User.roles.keys.map{|u|{label:u.capitalize, value: u}}.unshift({label:'Pick User Type', value:-1})
end