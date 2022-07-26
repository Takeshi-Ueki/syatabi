require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト', type: :system, js: false do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user)}


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
      it '自分と他人の投稿内容が表示される' do
        expect(page).to have_content post.body
        expect(page).to have_content other_post.body
      end
      it '自分と他人の投稿のリンク先が正しい' do
        expect(page).to have_link post.body, href: post_path(post)
        expect(page).to have_link other_post.body, href: post_path(other_post)
      end
    end
  end

  describe '新規投稿画面のテスト' do
    before do
      visit new_post_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/new'
      end
      it 'imagesフォームが表示される' do
        expect(page).to have_field 'post[images][]'
      end
      it '本文フォームが表示される' do
        expect(page).to have_field 'post[body]'
      end
      it 'タグフォームが表示される' do
        expect(page).to have_field 'post[tag_name]'
      end
      it '投稿ボタンが表示される' do
        expect(page).to have_button
      end
    end

    context '新規投稿成功のテスト' do
      before do
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
        fill_in 'post[tag_name]', with: '空 夜景, 夕日　花'
        attach_file 'post[images][]', 'spec/fixtures/test_image.jpg'
      end

      it '投稿が正しく新規登録される' do
        expect { click_button '投稿する' }.to change(Post.all, :count).by(1)
      end
      it 'タグが正しく新規登録される' do
        expect { click_button '投稿する' }.to change(Tag.all, :count).by(4)
      end
      it '新規投稿後の遷移先が、新規投稿した投稿の詳細画面になっている' do
        click_button '投稿する'
        expect(current_path).to eq '/posts'
      end
      it '新規投稿した投稿が、遷移先の投稿一覧画面に表示されている' do
        click_button '投稿する'
        expect(page).to have_content Post.last.body
      end
      it '新規投稿した投稿のリンク先が正しい' do
        click_button '投稿する'
        expect(page).to have_link Post.last.body, href: post_path(Post.last.id)
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
      it 'ユーザー画像のリンクが正しい' do
        profile_img = find_by_id('post-profile-img').native.inner_text
        expect(page).to have_link profile_img, href: user_path(post.user)
      end
      it '投稿のbodyが表示される' do
        expect(page).to have_content post.body
      end
      it '投稿の編集リンクが表示される'do
        expect(page).to have_link '編集', href: edit_post_path(post)
      end
      it '投稿の削除リンクが表示される'do
        expect(page).to have_link '削除', href: post_path(post)
      end
      it 'Diaryの新規作成へのリンクが表示される' do
        expect(page).to have_link 'Diary', href: new_post_diary_path(post)
      end
      it 'コメントフォームが表示される' do
        expect(page).to have_field 'post_comment[comment]'
      end
      it 'コメントフォームの送信ボタンが表示される' do
        expect(page).to have_button '送信する'
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link '編集'
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
    end

    context 'コメントの投稿のテスト', js: true do
      before do
        fill_in 'post_comment[comment]', with: Faker::Lorem.characters(number: 10)
      end

      it 'コメントが正しく新規登録される' do
        expect { click_button '送信する'
                find_by_id('logo') # 処理待ち
               }.to change(PostComment.all, :count).by(1)
      end
      it 'コメント送信後に送信したコメントが表示されている' do
        click_button '送信する'
        find_by_id('logo') #処理待ち
        expect(page).to have_content PostComment.last.comment
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '削除'
      end

      it '正しく削除される' do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先が投稿一覧画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end