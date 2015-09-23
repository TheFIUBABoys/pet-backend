describe "Users API" do

  describe "POST /users.json" do

    subject { post user_registration_path(format: :json), { user: user_params } }

    context "with email credentials" do
      let(:password) { Forgery(:basic).text(at_least: 8) }
      let(:user_params) do
        { email: Forgery(:internet).email_address, password: password, password_confirmation: password }
      end

      context "when email does not exist" do
        context "when password is provided" do
          context "when passwords match" do
            it "responds with 200" do
              subject
              expect(response.status).to eq 200
            end

            it "returns the user with an authentication token" do
              subject
              expect(json["email"]).to eql(user_params[:email])
              expect(json["authentication_token"]).to be_present
            end
          end

          context "when passwords don't match" do
            let(:user_params) do
              {
                email: Forgery(:internet).email_address,
                password: Forgery(:basic).text(at_least: 8),
                password_confirmation: Forgery(:basic).text(at_least: 8)
              }
            end

            it "responds with 422" do
              subject
              expect(response.status).to eq 422
            end
          end
        end

        context "when password isn't provided" do
          let(:user_params) { { email: Forgery(:internet).email_address } }

          it "responds with 422" do
            subject
            expect(response.status).to eq 422
          end
        end
      end

      context "when email already exists" do
        let(:user) { FactoryGirl.create :user, :email_auth }
        let(:user_params) { {email: user.email, password: password, password_confirmation: password} }

        it "responds with 422" do
          subject
          expect(response.status).to eq 422
        end
      end
    end

    context "with facebook credentials" do
      let(:user_params) do
        { facebook_id: Forgery(:basic).text(at_least: 8), facebook_token: Forgery(:basic).text(at_least: 8) }
      end

      context "when facebook_id does not exist" do
        context "when facebook_token is provided" do
          it "responds with 200" do
            subject
            expect(response.status).to eq 200
          end
  
          it "returns the user with an authentication token" do
            subject
            expect(json["authentication_token"]).to be_present
          end
        end
        
        context "when facebook_token isn't provided" do
          let(:user_params) { { facebook_id: Forgery(:basic).text(at_least: 8) } }

          it "responds with 422" do
            subject
            expect(response.status).to eq 422
          end
        end
      end

      context "when facebook_id already exists" do
        let(:user) { FactoryGirl.create :user, :facebook_auth }
        let(:user_params) { { facebook_id: user.facebook_id, facebook_token: user.facebook_token } }

        it "logs in the existing user" do
          subject
          expect(json["id"]).to eql(user.id)
          expect(json["authentication_token"]).to be_present
        end
      end
    end

  end

  describe "POST /users/sign_in.json" do

    subject { post user_session_path(format: :json), { user: user_params } }

    context "with email credentials" do
      let(:user) { FactoryGirl.create :user, :email_auth }
      let(:user_params) { { email: user.email, password: user.password } }

      context "when email matches password" do
        it "responds with 201" do
          subject
          expect(response.status).to eq 201
        end

        it "returns the user with an authentication token" do
          subject
          expect(json["authentication_token"]).to be_present
        end
      end

      context "when email does not match password" do
        let(:user_params) { { email: user.email, password: Forgery(:basic).text } }

        it "responds with 401" do
          subject
          expect(response.status).to eq 401
        end
      end
    end

  end

end
