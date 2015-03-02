require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the FoodTypeHelper. For example:
#
# describe FoodTypeHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe FoodTypeHelper do
  describe '#formatted_serving_recomendation' do
    it 'returns - for 0..0' do
      expect(helper.formatted_serving_recomendation(0..0)).to eq '-'
    end

    it 'returns "up to 2" for 0..2' do
      expect(helper.formatted_serving_recomendation(0..2)).to eq 'up to 2'
    end

    it 'returns "3 - 5" for 3..5' do
      expect(helper.formatted_serving_recomendation(3..5)).to eq '3 - 5'
    end

    it 'returns "at least 2" for 2..INFINITY' do
      expect(helper.formatted_serving_recomendation(2..Float::INFINITY)).to  \
        eq 'at least 2'
    end

    it 'returns unlimited for 0..INFINITY' do
      expect(helper.formatted_serving_recomendation(0..Float::INFINITY)).to  \
        eq 'unlimited'
    end
  end
end
