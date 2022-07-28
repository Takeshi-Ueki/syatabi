require 'rails_helper'

RSpec.describe 'Tagモデルのテスト' do
  describe 'バリデーションのテスト' do
    subject { tag.valid? }

    let(:other_tag) { create(:tag) }
    let(:tag) { build(:tag) }

    it '有効なタグ名の場合は保存されるか' do
      expect(FactoryBot.build(:tag)).to be_valid
    end

    context 'nameカラム' do
      it '空欄でないこと' do
        tag.name = ''
        is_expected.to eq false
      end
      it '150文字以内であること: 150文字は○' do
        tag.name = Faker::Lorem.characters(number: 150)
        is_expected.to eq true
      end
      it '150文字以内であること: 151文字はx' do
        tag.name = Faker::Lorem.characters(number: 151)
        is_expected.to eq false
      end
      it '一意性があること' do
        tag.name = other_tag.name
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it 'N:Nとなっている' do
        expect(Tag.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
  end
end
