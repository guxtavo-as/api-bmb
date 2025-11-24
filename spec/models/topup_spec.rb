require 'rails_helper'

RSpec.describe Topup, type: :model do
  describe "validations" do
    subject { create(:topup) } # ← IMPORTANTE
  
    it { should validate_presence_of(:external_id) }
    it { should validate_uniqueness_of(:external_id).ignoring_case_sensitivity  }
    it { should validate_presence_of(:phone_number) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
  end
  

  describe "enums" do
    it do
      should define_enum_for(:status)
        .with_values(paid: 0, processing: 1, success: 2, failed: 3)
    end
  end
end
