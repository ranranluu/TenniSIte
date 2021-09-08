require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end

      it 'loginを押すとログイン画面へ' do
        click_link 'Login'
        expect(current_path).to eq user_session_path
      end

      it 'Aboutを押すとアバウト画面へ' do
        click_link 'About'
        expect(current_path).to eq about_path
      end

      it 'Signupを押すと新規登録画面へ' do
        click_link 'Signup'
        expect(current_path).to eq new_user_registration_path
      end

      it 'Aboutリンクが表示される: 左上から2番目のリンクが「About」である' do
        about_link = find_all('a')[2].native.inner_text
        expect(about_link).to match(/About/i)
      end
      it 'Aboutリンクの内容が正しい' do
        expect(page).to have_link 'About', href: about_path
      end

      it 'Log inリンクが表示される: 左上から3番目のリンクが「Login」である' do
        log_in_link = find_all('a')[3].native.inner_text
        expect(log_in_link).to match(/Login/i)
      end
      it 'Log inリンクの内容が正しい' do
        expect(page).to have_link 'Login', href: new_user_session_path
      end

      it 'Sign Upリンクが表示される: 左上から4番目のリンクが「Signup」である' do
        sign_up_link = find_all('a')[4].native.inner_text
        expect(sign_up_link).to match(/Signup/i)
      end
      it 'Sign Upリンクの内容が正しい' do
        expect(page).to have_link 'Signup', href: new_user_registration_path
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'TenniSite'
      end
      it 'Homeリンクが表示される: 左上から1番目のリンクが「TenniSite」である' do
        home_link = find_all('a')[1].native.inner_text
        expect(home_link).to match(/TenniSite/i)
      end
      it 'Aboutリンクが表示される: 左上から2番目のリンクが「About」である' do
        about_link = find_all('a')[2].native.inner_text
        expect(about_link).to match(/about/i)
      end
      it 'loginリンクが表示される: 左上から3番目のリンクが「Login」である' do
        login_link = find_all('a')[3].native.inner_text
        expect(login_link).to match(/Login/i)
      end
      it 'sign upリンクが表示される: 左上から4番目のリンクが「Signup」である' do
        signup_link = find_all('a')[4].native.inner_text
        expect(signup_link).to match(/Signup/i)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'TenniSiteを押すと、トップ画面に遷移する' do
        home_link = find_all('a')[1].native.inner_text
        home_link = home_link.delete(' ')
        home_link.gsub!(/\n/, '')
        click_link home_link
        is_expected.to eq '/'
      end
      it 'Aboutを押すと、アバウト画面に遷移する' do
        about_link = find_all('a')[2].native.inner_text
        about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link about_link
        is_expected.to eq '/about'
      end
      it 'loginを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[3].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link
        is_expected.to eq '/users/sign_in'
      end
      it 'sign upを押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[4].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link
        is_expected.to eq '/users/sign_up'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「Sign up」と表示される' do
        expect(page).to have_content 'Sign up'
      end
      it 'nicknameフォームが表示される' do
        expect(page).to have_field 'user[nickname]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'Sign upボタンが表示される' do
        expect(page).to have_button 'Sign up'
      end
    end
    context '新規登録成功のテスト' do
      before do
        fill_in 'user[nickname]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end
      it '正しく新規登録される' do
        expect { click_button 'Sign up' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button 'Sign up'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
  end
  
  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「Log in」と表示される' do
        expect(page).to have_content 'Log in'
      end
      it 'emailフォームは表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'Log inボタンが表示される' do
        expect(page).to have_button 'Log in'
      end
      it 'nameフォームが表示されない' do
        expect(page).not_to have_field 'user[nickname]'
      end
    end
  end
end