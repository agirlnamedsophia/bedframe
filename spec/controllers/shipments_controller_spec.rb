require 'rails_helper'

RSpec.describe ShipmentsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Shipment. As you add validations to Shipment, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ShipmentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all shipments as @shipments" do
      shipment = Shipment.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:shipments)).to eq([shipment])
    end
  end

  describe "GET #show" do
    it "assigns the requested shipment as @shipment" do
      shipment = Shipment.create! valid_attributes
      get :show, params: {id: shipment.to_param}, session: valid_session
      expect(assigns(:shipment)).to eq(shipment)
    end
  end

  describe "GET #new" do
    it "assigns a new shipment as @shipment" do
      get :new, params: {}, session: valid_session
      expect(assigns(:shipment)).to be_a_new(Shipment)
    end
  end

  describe "GET #edit" do
    it "assigns the requested shipment as @shipment" do
      shipment = Shipment.create! valid_attributes
      get :edit, params: {id: shipment.to_param}, session: valid_session
      expect(assigns(:shipment)).to eq(shipment)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Shipment" do
        expect {
          post :create, params: {shipment: valid_attributes}, session: valid_session
        }.to change(Shipment, :count).by(1)
      end

      it "assigns a newly created shipment as @shipment" do
        post :create, params: {shipment: valid_attributes}, session: valid_session
        expect(assigns(:shipment)).to be_a(Shipment)
        expect(assigns(:shipment)).to be_persisted
      end

      it "redirects to the created shipment" do
        post :create, params: {shipment: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Shipment.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved shipment as @shipment" do
        post :create, params: {shipment: invalid_attributes}, session: valid_session
        expect(assigns(:shipment)).to be_a_new(Shipment)
      end

      it "re-renders the 'new' template" do
        post :create, params: {shipment: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested shipment" do
        shipment = Shipment.create! valid_attributes
        put :update, params: {id: shipment.to_param, shipment: new_attributes}, session: valid_session
        shipment.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested shipment as @shipment" do
        shipment = Shipment.create! valid_attributes
        put :update, params: {id: shipment.to_param, shipment: valid_attributes}, session: valid_session
        expect(assigns(:shipment)).to eq(shipment)
      end

      it "redirects to the shipment" do
        shipment = Shipment.create! valid_attributes
        put :update, params: {id: shipment.to_param, shipment: valid_attributes}, session: valid_session
        expect(response).to redirect_to(shipment)
      end
    end

    context "with invalid params" do
      it "assigns the shipment as @shipment" do
        shipment = Shipment.create! valid_attributes
        put :update, params: {id: shipment.to_param, shipment: invalid_attributes}, session: valid_session
        expect(assigns(:shipment)).to eq(shipment)
      end

      it "re-renders the 'edit' template" do
        shipment = Shipment.create! valid_attributes
        put :update, params: {id: shipment.to_param, shipment: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested shipment" do
      shipment = Shipment.create! valid_attributes
      expect {
        delete :destroy, params: {id: shipment.to_param}, session: valid_session
      }.to change(Shipment, :count).by(-1)
    end

    it "redirects to the shipments list" do
      shipment = Shipment.create! valid_attributes
      delete :destroy, params: {id: shipment.to_param}, session: valid_session
      expect(response).to redirect_to(shipments_url)
    end
  end

end
