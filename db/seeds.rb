# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


records = 1.upto(10).map do |i|
  {
    a: SecureRandom.hex(12),
    b: [true, false].sample,
    c: rand(10_000),
    d: (rand(10_000) / 100.0).round(8),
    e: rand(10_000),
    f: (1.0 / rand(10_000)).round(8),
  }
end

MyTestModel.insert_all(records)
