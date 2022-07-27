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

    context '複数画像の添付' do
      it '画像が添付されていること' do
        post.images = nil
        is_expected.to eq false
      end
      it '画像が３枚以内であること: 3枚は○' do
        post.images = nil
        post.images.attach(io: File.open('spec/fixtures/test_image.jpg'), filename: 'test_image.jpg', content_type: 'image/jpg')
        post.images.attach(io: File.open('spec/fixtures/test_image2.jpg'), filename: 'test_image.jpg', content_type: 'image/jpg')
        post.images.attach(io: File.open('spec/fixtures/test_image3.jpg'), filename: 'test_image.jpg', content_type: 'image/jpg')
        is_expected.to eq true
      end
      it '画像が３枚以内であること: 4枚はx' do
        post.images = nil
        post.images.attach(io: File.open('spec/fixtures/test_image.jpg'), filename: 'test_image.jpg', content_type: 'image/jpg')
        post.images.attach(io: File.open('spec/fixtures/test_image2.jpg'), filename: 'test_image.jpg', content_type: 'image/jpg')
        post.images.attach(io: File.open('spec/fixtures/test_image3.jpg'), filename: 'test_image.jpg', content_type: 'image/jpg')
        post.images.attach(io: File.open('spec/fixtures/test_image4.jpg'), filename: 'test_image.jpg', content_type: 'image/jpg')
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

    context 'Tagモデルとの関係' do
      it 'N:Nとなっている' do
        expect(Post.reflect_on_association(:tags).macro).to eq :has_many
      end
    end

    context 'Diaryモデルとの関係' do
      it '1:1となっている' do
        expect(Post.reflect_on_association(:diary).macro).to eq :has_one
      end
    end
  end
end
