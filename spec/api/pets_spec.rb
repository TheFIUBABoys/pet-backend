require "rails_helper"

describe "Pets API" do
  describe "GET /pets.json" do
    it "returns all the pets" do
      user = FactoryGirl.create :user

      get "/pets.json?user_token=#{user.authentication_token}"

      expect(response.status).to eq 200

      # body = JSON.parse(response.body)
      # movie_titles = body.map { |m| m["title"] }
      #
      # expect(movie_titles).to match_array(["The Lord of the Rings",
      #                                      "The Two Towers"])
    end
  end
end
