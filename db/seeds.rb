# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#테스트 계정 생성(어드민 권한 O)
test1 = User.create( email: 'kbs4674@naver.com', password: '123456' )
user = User.find(1)
user.add_role :admin

#테스트 계정 생성(어드민 권한 X)
test2 = User.create( email: 'test4674@naver.com', password: '123456' )