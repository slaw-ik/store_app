# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Statuses.create([{ name: 'Logged In manually' },
                 { name: 'Logged In automatically' },
                 { name: 'Logged Out manually' },
                 { name: 'Logged Out automatically' },
                 { name: 'Session Expired' }
                ])