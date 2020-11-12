# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
u = User.create(
    username: 'admin',
    password: BCrypt::Password.create('12345'),
    first_name: 'SRH',
    last_name: 'Admin',
    middle_name: 'Moses',
    email: 'srhadmin@gmail.com',
    gender: 1,
    designation: 'Software Developer'
)

r = Role.create(
    name: 'Administrator', description: 'Superuser of SRH Dashboard'
)

Role.create(
    name: 'Change Agent', description: 'Organisation Unit SRH users'
)

UserRole.create(
    user_id: u.id, role_id: r.id
)

