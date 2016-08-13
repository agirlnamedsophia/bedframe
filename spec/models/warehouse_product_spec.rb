require 'rails_helper'

RSpec.describe WarehouseProduct, type: :model do
  describe '#decrement_available_inventory' do
    context 'when quantity purchased is passed in' do
      it 'decreases available_inventory until min 0' do
      end
    end
  end
end
