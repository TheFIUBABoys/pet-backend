describe "Pets API" do

  describe "GET /pets.json" do

    let(:options) { {} }
    subject { get pets_path(options.merge(format: :json, user_token: token)) }

    context "when logged in" do
      let(:token) { FactoryGirl.create(:user).authentication_token }

      it "responds with 200" do
        subject
        expect(response.status).to eq 200
      end

      context "when there are published pets" do
        context "without filters" do
          it "returns all the pets" do
            pet = FactoryGirl.create :pet, :dog, :male, :published

            subject

            pets = JSON.parse(response.body)
            expect(pets.first["id"]).to eql(pet.id)
          end
        end

        context "with filters" do
          let(:pet) { FactoryGirl.create :pet, :dog, :male, :published }

          %i[type gender vaccinated name].each do |attribute|
            context "when pets match the filter" do
              let(:options) { { :"#{attribute}" => pet.send(attribute) } }

              it "returns the matching pets" do
                subject

                pets = JSON.parse(response.body)
                expect(pets.first["id"]).to eql(pet.id)
              end
            end

            context "when pets do not match the filter" do
              let(:options) { { :"#{attribute}" => !pet.send(attribute) } }

              it "returns the matching pets" do
                subject

                pets = JSON.parse(response.body)
                expect(pets).to be_empty
              end
            end
          end
        end
      end

      context "when there are no published pets" do
        it "returns an empty array" do
          subject

          pets = JSON.parse(response.body)
          expect(pets).to be_empty
        end
      end

      context "when there are no pets" do
        it "returns an empty array" do
          FactoryGirl.create :pet, :dog, :male, :unpublished

          subject

          pets = JSON.parse(response.body)
          expect(pets).to be_empty
        end
      end
    end

    context "when not logged in" do
      let(:token) { "" }

      it "responds with 401" do
        subject
        expect(response.status).to eq 401
      end
    end

  end

  describe "POST /pets.json" do

    subject { post pets_path(format: :json, user_token: token), { pet: pet_params } }

    context "when logged in" do
      let(:token) { FactoryGirl.create(:user).authentication_token }
      let(:valid_pet_params) { { type: Cat.name, gender: Pet::GENDER_MALE } }

      context "when specifying all required parameters" do
        let(:pet_params) { valid_pet_params }

        it "responds with 201" do
          subject
          expect(response.status).to eq 201
        end
      end

      %i[gender type].each do |attribute|
        context "when not specifying #{attribute}" do
          let(:pet_params) { valid_pet_params.except(attribute) }

          it "responds with 422" do
            subject
            expect(response.status).to eq 422
          end
        end
      end
    end

    context "when not logged in" do
      let(:token) { "" }
      let(:pet_params) { {} }

      it "responds with 401" do
        subject
        expect(response.status).to eq 401
      end
    end

  end

end
