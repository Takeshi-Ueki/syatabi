require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト', type: :system, js: false do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context 'リンクの確認' do
      subject { current_path }

      it 'URLが正しい' do
        is_expected.to eq '/'
      end
      it 'LOGOを押すと、トップ画面へ遷移する' do
        top_link = find_by_id('logo').native.inner_text
        click_link top_link
        is_expected.to eq '/'
      end
      it '新規登録リンクの内容が正しい' do
        sign_up_link = find_by_id('sidebar-sign-up').native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        sign_up_link = find_by_id('sidebar-sign-up').native.inner_text
        click_link sign_up_link, match: :first
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインリンクの内容が正しい' do
        log_in_link = find_by_id('sidebar-log-in').native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        log_in_link = find_by_id('sidebar-log-in').native.inner_text
        click_link log_in_link, match: :first
        is_expected.to eq '/users/sign_in'
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
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後の遷移先が、新規登録できたユーザの詳細画面になっている' do
        click_button '新規登録'
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
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後の遷移先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面に遷移する' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end
end
