# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#테스트 계정 생성(어드민 권한 O)
User.create( email: 'kbs4674@naver.com', password: 'a!123456', nickname: '어드민', admin: true )
user = User.find(1)
user.add_role :admin

User.create( email: 'gg@gg.gg', password: 'a!123456', nickname: '공용 계정(root)', admin: true )
user = User.find(2)
user.add_role :admin

#테스트 계정 생성(어드민 권한 X)
test3 = User.create( email: 'test4674@naver.com', password: 'a!123456', nickname: '테스트계정1',  admin: false )
user = User.find(3)
user.add_role :block_yellow
user.add_role :block_red

#추가적으로 계정 생성 원하시는분은 윗 줄 따라 해당주석 아랫줄에 써주세요.

#게시판
voice = Bulletin.create( title: 'VOICELL', content: '보이스 게시판', user_nickname: '어드민', opt_admin_only: 'false', board_mp3_upload_permit: 'true', reply_mp3_upload_permit: 'true', user_id: '1')
for num in 1..10
    Post.create( title: "게시글#{num}", content: '나는 빡빡이다', user_nickname: '어드민', user_id: '1', bulletin_id: '1' )
end
comment = Bulletin.create( title: '댓글 보이스게시판', content: '댓글 보이스게시판', user_nickname: '어드민', opt_admin_only: 'false', board_mp3_upload_permit: 'false', reply_mp3_upload_permit: 'true', user_id: '1')
free = Bulletin.create( title: '자유게시판', content: '자유게시판', user_nickname: '어드민', opt_admin_only: 'false', board_mp3_upload_permit: 'false', reply_mp3_upload_permit: 'false', user_id: '1')