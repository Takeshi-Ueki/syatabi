require 'rails_helper'

RSpec.describe 'Reportモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { report.valid? }

    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let(:report) { build(:report, reporter_id: user.id, reported_id: other_user.id) }

    context 'reasonカラム' do
      it '空欄でないこと' do
        report.reason = ''
        is_expected.to eq false
      end
      it '2文字以上であること: 1文字はx' do
        report.reason = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以上であること: 2文字は○' do
        report.reason = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '255文字以下であること: 255文字は○' do
        report.reason = Faker::Lorem.characters(number: 255)
        is_expected.to eq true
      end
      it '255文字以下であること: 256文字はx' do
        report.reason = Faker::Lorem.characters(number: 256)
        is_expected.to eq false
      end
    end
  end
end