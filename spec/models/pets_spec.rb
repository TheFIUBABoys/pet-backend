describe Pet do

  describe "#create" do

    let(:user) { FactoryGirl.create :user, :email_auth }
    subject { described_class.create(pet_params) }

    context "all required params are present" do
      let(:pet_params) { { user: user, gender: Pet::GENDER_MALE, type: Dog.name, colors: "black", description: "nice" } }

      it "creates a pet" do
        expect { subject }.to change(Pet, :count).by(1)
      end

      it "reeturns a model with no errors" do
        expect(subject.errors).to be_empty
      end

      it "generates metadata based on type" do
        expect(subject.metadata).to include("perro")
      end

      it "generates metadata based on gender" do
        expect(subject.metadata).to include("macho")
      end

      it "generates metadata based on colors" do
        expect(subject.metadata).to include("black")
      end

      it "generates metadata based on colors" do
        expect(subject.metadata).to include("nice")
      end
    end

    context "whan a required param is missing" do
      %w[user gender type].each do |attribute|
        let(:pet_params) { { user: user, gender: Pet::GENDER_MALE, type: Dog.name }.except(attribute.to_sym) }

        it "doesn't create a pet" do
          expect { subject }.to change(Pet, :count).by(0)
        end

        it "returns a model with errors" do
          expect(subject.errors).not_to be_empty
        end
      end
    end

  end

  describe ".publish" do

    subject { pet.publish }

    context "when pet is unpublished" do
      let(:pet) { FactoryGirl.create :pet, :male, :dog, :unpublished }

      it "changes the published attribute to true" do
        subject

        expect(pet.published).to be(true)
      end

      it "does not save the changes" do
        subject

        expect(Pet.find(pet.id).published).to be(false)
      end
    end

    context "when pet is published" do
      let(:pet) { FactoryGirl.create :pet, :male, :dog, :published }

      it "does not change the published attribute" do
        subject

        expect(pet.published).to be(true)
      end
    end

  end

  describe ".unpublish" do

    subject { pet.unpublish }

    context "when pet is published" do
      let(:pet) { FactoryGirl.create :pet, :male, :dog, :published }

      it "changes the published attribute to false" do
        subject

        expect(pet.published).to be(false)
      end

      it "does not save the changes" do
        subject

        expect(Pet.find(pet.id).published).to be(true)
      end
    end

    context "when pet is unpublished" do
      let(:pet) { FactoryGirl.create :pet, :male, :dog, :unpublished }

      it "does not change the published attribute" do
        subject

        expect(pet.published).to be(false)
      end
    end

  end

  describe ".publish!" do

    subject { pet.publish! }

    context "when pet is unpublished" do
      let(:pet) { FactoryGirl.create :pet, :male, :dog, :unpublished }

      it "changes the published attribute to true" do
        subject

        expect(pet.published).to be(true)
      end

      it "saves the changes" do
        subject

        expect(Pet.find(pet.id).published).to be(true)
      end
    end

    context "when pet is published" do
      let(:pet) { FactoryGirl.create :pet, :male, :dog, :published }

      it "does not change the published attribute" do
        subject

        expect(pet.published).to be(true)
      end
    end

  end

  describe ".unpublish" do

    subject { pet.unpublish! }

    context "when pet is published" do
      let(:pet) { FactoryGirl.create :pet, :male, :dog, :published }

      it "changes the published attribute to false" do
        subject

        expect(pet.published).to be(false)
      end

      it "saves the changes" do
        subject

        expect(Pet.find(pet.id).published).to be(false)
      end
    end

    context "when pet is unpublished" do
      let(:pet) { FactoryGirl.create :pet, :male, :dog, :unpublished }

      it "does not change the published attribute" do
        subject

        expect(pet.published).to be(false)
      end
    end

  end

  describe ".distance_to" do

    let(:pet) { FactoryGirl.create :pet, :dog, :male, :published, location: "50,50" }

    it "calculates distance between coordinates correctly" do
      expect(pet.distance_to([60, 60]).to_i).to eql(1278730)
    end

  end

end
