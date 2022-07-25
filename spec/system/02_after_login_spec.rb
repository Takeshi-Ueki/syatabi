require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト', type: :system, js: false do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:other_post) { create(:post, user: other_user)}


  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト' do
    context 'リンクの内容を確認: ※ログアウトは[ログアウトのテストで確認済]' do
      subject { current_path }

      it 'HOMEを押すと、投稿一覧画面へ遷移' do
        home_link = find_by_id('sidebar-home').native.inner_text
        click_link home_link
        is_expected.to eq '/posts'
      end
      it 'マイページを押すと、マイページへ遷移' do
        mypage_link = find_by_id('sidebar-mypage').native.inner_text
        click_link mypage_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it '通知を押すと、通知画面へ遷移する' do
        notification_link = find_by_id('sidebar-notification').native.inner_text
        click_link notification_link
        is_expected.to eq '/notifications'
      end
      it 'リストを押すと、通知画面へ遷移する' do
        list_link = find_by_id('sidebar-list').native.inner_text
        click_link list_link
        is_expected.to eq '/users/' + user.id.to_s + '/lists'
      end
      it '新規投稿を押すと、新規投稿画面へ遷移する' do
        new_post_link = find_by_id('sidebar-new-post').native.inner_text
        click_link new_post_link
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
      it '自分と他人の画像のリンク先が正しい' do
        byebug
        post_link = find_by_id("post-link-#{post.id}")
        expect(page).to have_link post_link, href: post_path(post)
      end
    end
  end
end