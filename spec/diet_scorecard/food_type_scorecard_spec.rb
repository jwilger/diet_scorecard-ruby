require 'diet_scorecard/food_type_scorecard'

describe DietScorecard::FoodTypeScoreCard do
  let(:food_type) { double(:food_type, key: :some_stuff) }

  subject {
    described_class.new(food_type: food_type, date: Date.new(2013,12,22))
  }

  it 'has a food_type_key that matches its food_type' do
    expect(subject.food_type_key).to eq :some_stuff
  end
end
