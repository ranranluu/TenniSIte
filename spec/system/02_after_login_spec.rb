require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }


  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'TenniSiteを押すと、ホーム画面に遷移する' do
        home_link = find_all('a')[1].native.inner_text
        home_link = home_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link home_link
        is_expected.to eq '/'
      end
      it 'Mypageを押すと、マイページ画面に遷移する' do
        mypage_link = find_all('a')[2].native.inner_text
        mypage_link = mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link mypage_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it 'Usersを押すと、ユーザー一覧画面に遷移する' do
        users_link = find_all('a')[3].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/users'
      end
      it 'Postsを押すと、投稿一覧画面に遷移する' do
        posts_link = find_all('a')[4].native.inner_text
        posts_link = posts_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link posts_link
        is_expected.to eq '/posts'
      end
      it 'Newpostを押すと、新規投稿画面に遷移する' do
        newpost_link = find_all('a')[5].native.inner_text
        newpost_link = newpost_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link newpost_link
        is_expected.to eq '/posts/new'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
    end

    context 'サイドバーの確認' do
      it '自分の情報が表示される' do
        expect(page).to have_content user.nickname
        expect(page).to have_content user.introduction
        expect(page).to have_content user.playstyle
        expect(page).to have_content user.like_player
        expect(page).to have_content user.like_brand
      end
    end

    context '投稿成功のテスト' do
      before do
        visit new_post_path
        fill_in 'post[content]', with: 'content'
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button 'Create post' }.to change(user.posts, :count).by(1)
      end
      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button 'Create post'
        expect(current_path).to eq '/posts/' + Post.last.id.to_s
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it '「Post Detail」と表示される' do
        expect(page).to have_content 'Post Detail'
      end
      it 'ユーザ画像・名前のリンク先が正しい' do
        expect(page).to have_link post.user.nickname, href: user_path(post.user)
      end
      it '投稿のcontentが表示される' do
        expect(page).to have_content post.content
      end

      it '投稿の編集リンクが表示される' do
        expect(page).to have_link 'Edit', href: edit_post_path(post)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link 'Destroy', href: post_path(post)
      end
    end

    context 'サイドバーの確認' do
      it '自分の情報が表示される' do
        expect(page).to have_content user.nickname
        expect(page).to have_content user.introduction
        expect(page).to have_content user.playstyle
        expect(page).to have_content user.like_player
        expect(page).to have_content user.like_brand
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link 'Edit'
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link 'Destroy'
      end

      it '正しく削除される' do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/posts'
      end
    end
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
      it '「Editing post」と表示される' do
        expect(page).to have_content 'Update Post'
      end
      it 'content編集フォームが表示される' do
        expect(page).to have_field 'post[content]', with: post.content
      end
      it 'Update postボタンが表示される' do
        expect(page).to have_button 'Update Post'
      end
    end
    
    context 'サイドバーの確認' do
      it '自分の情報が表示される' do
        expect(page).to have_content user.nickname
        expect(page).to have_content user.introduction
        expect(page).to have_content user.playstyle
        expect(page).to have_content user.like_player
        expect(page).to have_content user.like_brand
      end
    end

    context '編集成功のテスト' do
      before do
        @post_old_content = post.content
        fill_in 'post[content]', with: Faker::Lorem.characters(number: 4)
        click_button 'Update Post'
      end

      it 'contentが正しく更新される' do
        expect(post.reload.content).not_to eq @post_old_content
      end

      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq '/posts/' + post.id.to_s
        expect(page).to have_content 'Post Detail'
      end
    end
  end

  describe 'ユーザ一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      it '自分のニックネームが表示される' do
        expect(page).to have_content user.nickname
      end
      it '自分のshowリンクが表示される' do
        expect(page).to have_link '', href: user_path(user)
      end
    end
  end
  
  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
  
  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[nickname]', with: user.nickname
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it 'Update Userボタンが表示される' do
        expect(page).to have_button 'Update User'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_nickname = user.nickname
        @user_old_introduction = user.introduction
        fill_in 'user[nickname]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
        click_button 'Update User'
      end

      it 'nameが正しく更新される' do
        expect(user.reload.nickname).not_to eq @user_old_nickname
      end
      it 'introductionが正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_intrpduction
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end