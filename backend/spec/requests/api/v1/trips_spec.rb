require "rails_helper"

RSpec.describe "API::V1::Trips", type: :request do
  let!(:user) { User.create!(email: "alice@example.com", password: "12345678") }
  let!(:headers) { auth_headers_for(user, password: "12345678") }

  describe "GET /api/v1/trips" do
    before do
      create(:trip, user:, title: "Aventura en Perú")
      create(:trip, user:, title: "Viaje a la Patagonia")
    end

    it "returns the user's trips" do
      get "/api/v1/trips", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
      expect(json.first["title"]).to be_present
    end
  end

  describe "POST /api/v1/trips" do
    it "creates a new trip" do
      expect {
        post "/api/v1/trips",
             params: { trip: { title: "Desierto de Atacama", description: "Sol y estrellas", public: true } },
             headers: headers,
             as: :json
      }.to change(Trip, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "GET /api/v1/trips/:id" do
    let!(:trip) { Trip.create!(user:, title: "Solo mío") }

    it "returns the trip details" do
      get "/api/v1/trips/#{trip.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["title"]).to eq("Solo mío")
    end

    it "returns 404 for another user's trip" do
      other_trip = Trip.create!(user: User.create!(email: "bob@example.com", password: "12345678"), title: "No tuyo")
      get "/api/v1/trips/#{other_trip.id}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
