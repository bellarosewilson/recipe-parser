# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Recipes", type: :request do
  describe "GET /recipes" do
    it "returns success when signed in and shows the recipes index" do
      user = User.create!(
        email: "recipes_spec@example.com",
        password: "password123",
        password_confirmation: "password123"
      )
      sign_in user

      get recipes_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("List of All Recipes")
    end

    it "redirects to sign in when not authenticated" do
      get recipes_path

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
