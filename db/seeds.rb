# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Status.destroy_all
Status.create([{:id => 1, name: 'Logged In manually'},
               {:id => 2, name: 'Logged In automatically'},
               {:id => 3, name: 'Logged Out manually'},
               {:id => 4, name: 'Logged Out automatically'},
               {:id => 5, name: 'Session Expired'},
               {:id => 6, name: 'Create Item'},
               {:id => 7, name: 'Increment'},
               {:id => 8, name: 'Decrement'},
               {:id => 9, name: 'Delete Item'}
              ])