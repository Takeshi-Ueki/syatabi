require 'rails_helper'

RSpec.describe 'Diaryモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { diary.valid? }

    let(:user) { create(:user) }
    let(:post) { create(:post, user_id: user.id) }
    let(:diary) { build(:diary, user_id: user.id, post_id: post.id) }

    it '有効な投稿内容の場合は保存されるか' do
      expect(FactoryBot.build(:diary)).to be_valid
    end

    context 'titleカラム' do
      it '空欄でないこと' do
        diary.title = ''
        is_expected.to eq false
      end
      it '2文字以上であること: 1文字はx' do
        diary.title = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以上であること: 2文字は○' do
        diary.title = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '100文字以内であること: 100文字は○' do
        diary.title = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it '100文字以内であること: 101文字はx' do
        diary.title = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end

    context 'bodyカラム' do
      it '空欄でないこと' do
        diary.body = ''
        is_expected.to eq false
      end
      it '30000文字以内であること: 30000文字は○' do
        diary.body = Faker::Lorem.characters(number: 30000)
        is_expected.to eq true
      end
      it '30000文字以内であること: 30001文字はx' do
        diary.body = Faker::Lorem.characters(number: 30001)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Diary.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Postモデルとの関係' do
      it '1:1となっている' do
        expect(Diary.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
  end
end
