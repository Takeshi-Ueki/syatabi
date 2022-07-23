require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post.valid? }

    let(:user) { create(:user) }
    let(:post) { build(:post, user_id: user.id) }

    context 'bodyカラム' do
      it '空欄でないこと' do
        post.body = ''
        is_expected.to eq false
      end
      it '255文字以下であること: 255文字は○' do
        post.body = Faker::Lorem.characters(number: 255)
        is_expected.to eq true
      end
      it '255文字以下であること: 256文字はx' do
        post.body = Faker::Lorem.characters(number: 256)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end
end
