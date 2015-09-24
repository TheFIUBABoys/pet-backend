describe "Pets API" do

  describe "GET /pets.json" do

    let(:options) { {} }
    subject { get pets_path(options.merge(format: :json, user_token: token)) }

    context "when logged in" do
      let(:token) { FactoryGirl.create(:user, :email_auth).authentication_token }

      it "responds with 200" do
        subject
        expect(response.status).to eq 200
      end

      context "when there are published pets" do
        context "without filters" do
          it "returns all the pets" do
            pet = FactoryGirl.create :pet, :dog, :male, :published

            subject

            expect(json.first["id"]).to eql(pet.id)
          end
        end

        context "with filters" do
          let(:pet) { FactoryGirl.create :pet, :dog, :male, :published }

          %w[type gender vaccinated name].each do |attribute|
            context "when pets match the filter" do
              let(:options) { { :"#{attribute}" => pet.send(attribute.to_sym) } }

              it "returns the matching pets" do
                subject

                expect(json.first["id"]).to eql(pet.id)
              end
            end

            context "when pets do not match the filter" do
              let(:options) { { :"#{attribute}" => !pet.send(attribute.to_sym) } }

              it "returns the matching pets" do
                subject

                expect(json).to be_empty
              end
            end
          end
        end
      end

      context "when there are no published pets" do
        it "returns an empty array" do
          subject

          expect(json).to be_empty
        end
      end

      context "when there are no pets" do
        it "returns an empty array" do
          FactoryGirl.create :pet, :dog, :male, :unpublished

          subject

          expect(json).to be_empty
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
      let(:token) { FactoryGirl.create(:user, :email_auth).authentication_token }
      let(:valid_pet_params) { { type: Cat.name, gender: Pet::GENDER_MALE } }

      context "when specifying all required parameters" do
        let(:pet_params) { valid_pet_params }

        it "responds with 201" do
          subject
          expect(response.status).to eq 201
        end
      end

      %w[gender type].each do |attribute|
        context "when not specifying #{attribute}" do
          let(:pet_params) { valid_pet_params.except(attribute.to_sym) }

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

  describe "GET /pets/:id.json" do

    let(:pet) { FactoryGirl.create :pet, :dog, :male, :published }
    subject { get pet_path(pet, format: :json, user_token: token) }

    context "when logged in" do
      let(:token) { FactoryGirl.create(:user, :email_auth).authentication_token }

      context "when pet with given id does not exist" do
        subject { get pet_path(id: Forgery(:name).first_name, format: :json, user_token: token) }

        it "responds with 404" do
          subject
          expect(response.status).to eq 404
        end
      end

      context "when pet with given id exists" do
        it "responds with 200" do
          subject
          expect(response.status).to eq 200
        end

        it "returns the pet with the given id" do
          subject

          expect(json["id"]).to eql(pet.id)
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

  describe "PUT /pets/:id.json" do

    let(:pet) { FactoryGirl.create :pet, :dog, :male, :published }
    subject { put pet_path(pet, format: :json, user_token: token), { pet: pet_params }  }

    context "when logged in" do
      let(:token) { FactoryGirl.create(:user, :email_auth).authentication_token }

      context "when pet with given id does not exist" do
        let(:pet_params) { { name: Forgery(:name).first_name } }
        subject { put pet_path(id: Forgery(:name).first_name, format: :json, user_token: token), { pet: pet_params } }

        it "responds with 404" do
          subject
          expect(response.status).to eq 404
        end
      end

      context "when pet with given id exists" do
        context "when updating the name" do
          let(:pet_params) { { name: Forgery(:name).first_name } }

          it "responds with 200" do
            subject
            expect(response.status).to eq 200
          end

          it "returns the pet with the changed name" do
            subject

            expect(json["id"]).to eql(pet.id)
            expect(json["name"]).to eql(pet_params[:name])
          end
        end

        context "when updating the gender" do
          let(:pet_params) { { gender: Pet::GENDERS.reject { |g| g == pet.gender }.first } }

          it "responds with 200" do
            subject
            expect(response.status).to eq 200
          end

          it "returns the pet with the changed gender" do
            subject

            expect(json["id"]).to eql(pet.id)
            expect(json["gender"]).to eql(pet_params[:gender])
          end

          it "changes the metadata" do
            old_metadata = pet.metadata

            subject

            expect(json["id"]).to eql(pet.id)
            expect(json["metadata"]).not_to eql(old_metadata)
          end
        end

        context "when updating the type" do
          let(:pet_params) { { type: Pet::TYPES.reject { |t| t == pet.type }.first } }

          it "responds with 200" do
            subject
            expect(response.status).to eq 200
          end

          it "returns the pet with the changed type" do
            subject

            expect(json["id"]).to eql(pet.id)
            expect(json["type"]).to eql(pet_params[:type])
          end

          it "changes the metadata" do
            old_metadata = pet.metadata

            subject

            expect(json["id"]).to eql(pet.id)
            expect(json["metadata"]).not_to eql(old_metadata)
          end
        end

        %w[published vaccinated needs_transit_home].each do |attribute|
          context "when updating #{attribute}" do
            let(:pet_params) { { :"#{attribute}" => !pet.send(attribute.to_sym) } }

            it "responds with 200" do
              subject
              expect(response.status).to eq 200
            end

            it "returns the pet with the changed name" do
              subject

              expect(json["id"]).to eql(pet.id)
              expect(json[attribute]).to eql(pet_params[attribute.to_sym])
            end
          end
        end
      end
    end

    context "when not logged in" do
      let(:pet_params) { { } }
      let(:token) { "" }

      it "responds with 401" do
        subject
        expect(response.status).to eq 401
      end
    end

  end

  describe "DELETE /pets/:id.json" do

    let(:pet) { FactoryGirl.create :pet, :dog, :male, :published }
    subject { delete pet_path(pet, format: :json, user_token: token) }

    context "when logged in" do
      let(:token) { FactoryGirl.create(:user, :email_auth).authentication_token }

      context "when pet with given id does not exist" do
        subject { delete pet_path(id: Forgery(:name).first_name, format: :json, user_token: token) }

        it "responds with 404" do
          subject
          expect(response.status).to eq 404
        end
      end

      context "when pet with given id exists" do
        it "responds with 204" do
          subject
          expect(response.status).to eq 204
        end
      end
    end

    context "when not logged in" do
      let(:pet_params) { { } }
      let(:token) { "" }

      it "responds with 401" do
        subject
        expect(response.status).to eq 401
      end
    end

  end

  describe "GET /pets/top.json" do

    subject { get top_pets_path(format: :json, user_token: token) }

    context "when logged in" do
      let(:token) { FactoryGirl.create(:user, :email_auth).authentication_token }

      it "responds with 200" do
        subject
        expect(response.status).to eq 200
      end

      context "when there are less than 5 pets" do
        before do
          Pet.destroy_all
          FactoryGirl.create_list :pet, 4, :dog, :male, :published
        end

        it "returns all the pets" do
          subject

          expect(json.count).to be < 5
        end
      end

      context "when there are more than 5 pets" do
        before { FactoryGirl.create_list :pet, 10, :dog, :male, :published }

        it "returns 5 pets" do
          subject

          expect(json.count).to eql(5)
        end
      end
    end

    context "when not logged in" do
      let(:pet_params) { { } }
      let(:token) { "" }

      it "responds with 401" do
        subject
        expect(response.status).to eq 401
      end
    end

  end

end
