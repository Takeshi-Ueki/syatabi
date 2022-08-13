require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let(:user) { build(:user) }

    it "有効な投稿内容の場合は保存されるか" do
      expect(FactoryBot.build(:user)).to be_valid
    end

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '2文字以上であること: 1文字はx' do
        user.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以上であること: 2文字以上は○' do
        user.name = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '50文字以下であること: 50文字は○' do
        user.name = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end
      it '50文字以下であること: 51文字はx' do
        user.name = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end

      context 'profileカラム'
      it '255文字以内であること: 255は○' do
        user.profile = Faker::Lorem.characters(number: 255)
        is_expected.to eq true
      end
      it '255文字以内であること: 256はx' do
        user.profile = Faker::Lorem.characters(number: 256)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end

    context 'Diaryモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:diaries).macro).to eq :has_many
      end
    end
  end
end
