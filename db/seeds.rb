# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.where(email:'dealer1@example.com').first_or_create!(email:'dealer1@example.com', username: 'dealer1', password: '1234asdfasfa432!')
User.where(email:'client1@example.com').first_or_create!(email:'client1@example.com', username: 'client1', password: '1234asdfasfa432!')

Category.where("size=? AND unit = ?", 5, Category.units[:marla]).first_or_create!(unit: :marla, size:5, name: '5Marla', pod_days: 60 )

%w[lahore karachi faislabad rawalpindi].each do |city|
	Region.where('title in (?)', [city,city.pluralize, city.capitalize, city.upcase]).first_or_create(title: city)
end

Category.where("size=? AND unit = ?", 5, Category.units[:marla]).first_or_create!(unit: :marla, size:5, name: '5Marla', pod_days: 60, base_amount: 100000 )
Category.where("size=? AND unit = ?", 10, Category.units[:marla]).first_or_create!(unit: :marla, size:10, name: '10Marla', pod_days: 60,base_amount: 200000 )
Category.where("size=? AND unit = ?", 1, Category.units[:kanal]).first_or_create!(unit: :kanal, size:1, name: '1Kanal', pod_days: 60,base_amount: 300000 )
Category.where("unit = ?", Category.units[:cash]).first_or_create!(unit: :cash, name: 'Cash',base_amount: 30000 )
