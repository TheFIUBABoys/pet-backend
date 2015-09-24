describe "Images API" do
  let(:image) { File.new(Rails.root + "spec/fixtures/images" + "image.png") }
  let(:file)  { Rack::Test::UploadedFile.new(image, "image/jpeg") }

  describe "POST /pets/:pet_id/images.json" do

    subject { post pet_images_path(pet, format: :json, user_token: token), { pet_image: pet_image_params } }
    let(:pet) { FactoryGirl.create :pet, :male, :dog, :published }

    context "when logged in" do
      let(:token) { FactoryGirl.create(:user, :email_auth).authentication_token }
      let(:pet_image_params) { { image: file } }

      context "when pet exists" do
        it "responds with 200" do
          subject
          expect(response.status).to eq 200
        end

        %w[thumb medium original].each do |image_size|
          it "returns a #{image_size} url" do
            subject
            expect(json["#{image_size}_url"]).to be_present
          end
        end
      end

      context "when pet doesn't exist" do
        let(:pet) { double(id: Forgery(:basic).number) }

        it "responds with 404" do
          subject
          expect(response.status).to eq 404
        end
      end
    end

    context "when not logged in" do
      let(:pet_image_params) { { } }
      let(:token) { "" }

      it "responds with 401" do
        subject
        expect(response.status).to eq 401
      end
    end

  end

  describe "GET /pets/:pet_id/images/:id.json" do

    subject { get pet_image_path(pet_id: pet_id, id: pet_image_id, format: :json, user_token: token) }
    let(:pet_image) { FactoryGirl.create :pet_image }

    context "when logged in" do
      let(:token) { FactoryGirl.create(:user, :email_auth).authentication_token }

      context "when pet exists" do
        let(:pet_id) { pet_image.pet.id }

        context "when image exists" do
          let(:pet_image_id) { pet_image.id }

          it "responds with 200" do
            subject
            expect(response.status).to eq 200
          end

          %w[thumb medium original].each do |image_size|
            it "returns a #{image_size} url" do
              subject
              expect(json["#{image_size}_url"]).to be_present
            end
          end
        end

        context "when image doesn't exist" do
          let(:pet_image_id) { Forgery(:basic).number }

          it "responds with 404" do
            subject
            expect(response.status).to eq 404
          end
        end
      end

      context "when pet doesn't exist" do
        let(:pet_id) { Forgery(:basic).number }
        let(:pet_image_id) { pet_image.id }

        it "responds with 404" do
          subject
          expect(response.status).to eq 404
        end
      end
    end

    context "when not logged in" do
      let(:pet_id) { pet_image.pet.id }
      let(:pet_image_id) { pet_image.id }
      let(:token) { "" }

      it "responds with 401" do
        subject
        expect(response.status).to eq 401
      end
    end

  end

  describe "DELETE /pets/:pet_id/images/:id.json" do

    subject { delete pet_image_path(pet_id: pet_id, id: pet_image_id, format: :json, user_token: token) }
    let(:pet_image) { FactoryGirl.create :pet_image }

    context "when logged in" do
      let(:token) { FactoryGirl.create(:user, :email_auth).authentication_token }

      context "when pet exists" do
        let(:pet_id) { pet_image.pet.id }

        context "when image exists" do
          let(:pet_image_id) { pet_image.id }

          it "responds with 204" do
            subject
            expect(response.status).to eq 204
          end
        end

        context "when image doesn't exist" do
          let(:pet_image_id) { Forgery(:basic).number }

          it "responds with 404" do
            subject
            expect(response.status).to eq 404
          end
        end
      end

      context "when pet doesn't exist" do
        let(:pet_id) { Forgery(:basic).number }
        let(:pet_image_id) { pet_image.id }

        it "responds with 404" do
          subject
          expect(response.status).to eq 404
        end
      end
    end

    context "when not logged in" do
      let(:pet_id) { pet_image.pet.id }
      let(:pet_image_id) { pet_image.id }
      let(:token) { "" }

      it "responds with 401" do
        subject
        expect(response.status).to eq 401
      end
    end

  end

end
