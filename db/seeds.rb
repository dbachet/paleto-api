# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.where(email: 'test@test.com').first_or_create!(password: '12345678', password_confirmation: '12345678')
admin = User.where(email: 'admin@test.com').first_or_create!(password: '12345678', password_confirmation: '12345678', admin: true)

pallet = Pallet.find_or_create_by!(title: 'foo', description: 'bar', latitude: 1.111111, longitude: 1.111111, user: user)

comment = Comment.find_or_create_by!(content: 'foofoo barbar', user: user, pallet: pallet)
