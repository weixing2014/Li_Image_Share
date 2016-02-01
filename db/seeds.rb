# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
urls = %w(
  https://i.chzbgr.com/full/8477892864/h50B3AFC3/
  https://media.giphy.com/media/3o7ZeEqF00F2pI0moU/giphy.gif
  https://media.giphy.com/media/Mnw7GYKVJjX20/giphy.gif
  https://media.giphy.com/media/ldD9copTuuNNe/giphy.gif
  https://media.giphy.com/media/lJav8npz16Ocg/giphy.gif
  https://media.giphy.com/media/1395cV7aUaBhlK/giphy.gif
  https://media.giphy.com/media/TF5jiKi9uGibu/giphy.gif
  https://media.giphy.com/media/l39JrKv9ZZX2g/giphy.gif
  https://media.giphy.com/media/xIJLgO6rizUJi/giphy.gif
  https://media.giphy.com/media/26hlRUmCJ0qWQHeaQ/giphy.gif
  https://media.giphy.com/media/BB67sSfKNEnfO/giphy.gif
  https://media.giphy.com/media/DhnSIHPkuXgFa/giphy.gif
  https://media.giphy.com/media/sn9HA6bwiyB2w/giphy.gif
  https://media.giphy.com/media/26tnndHUXftq2IFpe/giphy.gif
  https://media.giphy.com/media/Ay8BzrcBh85pK/giphy.gif
  https://media.giphy.com/media/e07y5SEwFMDm0/giphy.gif
  https://media.giphy.com/media/MF4XbEUxTXKfK/giphy.gif
  https://media.giphy.com/media/PHkIfAw1FUUms/giphy.gif
  https://media.giphy.com/media/Yy7BiuPbeaGXu/giphy.gif
  https://media.giphy.com/media/13uaMxgBhGP9ba/giphy.gif
)

urls.each { |url| Image.create!(url: url) }
