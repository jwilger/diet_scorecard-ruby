require 'diet_scorecard/food_type_scorecard'
require 'diet_scorecard/food_type'

describe DietScorecard::FoodTypeScoreCard do
  let(:food_type) {
    DietScorecard::FoodType.new(:some_stuff, score_table: score_table)
  }

  let(:meals_service) { double(:meals_service) }
  let(:meal_scorecards_service) {
    double(:meal_scorecards_service, for_date: meal_scorecards)
  }

  let(:meal_scorecards) {[meal_a, meal_b]}

  let(:meal_a) { double(:meal_a, total_servings: 0) }
  let(:meal_b) { double(:meal_b, total_servings: 0) }

  let(:score_table) {[2,2,1,0,-1,-2]}

  let(:date) { Date.new(2013,12,22) }

  subject {
    described_class.new(food_type: food_type, date: date,
                        meals_service: meals_service,
                        meal_scorecards_service: meal_scorecards_service)
  }

  it 'has a food_type_key that matches its food_type' do
    expect(subject.food_type_key).to eq :some_stuff
  end

  it 'uses the meals recorded on the specified date' do
    subject.points_earned
    expect(meal_scorecards_service).to have_received(:for_date) \
      .with(date, meals_service: meals_service)
  end

  it 'calculates the total servings of a food type consumed on the date' do
    expect(meal_a).to receive(:total_servings).with(:some_stuff).and_return(3)
    expect(meal_b).to receive(:total_servings).with(:some_stuff).and_return(1)
    expect(subject.servings_consumed).to eq 4
  end

  it 'calculates the points earned based on the total servings' do
    expect(subject.points_earned).to eq 0

    allow(meal_a).to receive(:total_servings).and_return(1)
    expect(subject.points_earned).to eq 2

    allow(meal_a).to receive(:total_servings).and_return(2)
    expect(subject.points_earned).to eq 4

    allow(meal_a).to receive(:total_servings).and_return(3)
    expect(subject.points_earned).to eq 5

    allow(meal_a).to receive(:total_servings).and_return(4)
    expect(subject.points_earned).to eq 5

    allow(meal_a).to receive(:total_servings).and_return(5)
    expect(subject.points_earned).to eq 4

    allow(meal_a).to receive(:total_servings).and_return(6)
    expect(subject.points_earned).to eq 2

    allow(meal_a).to receive(:total_servings).and_return(7)
    expect(subject.points_earned).to eq 0

    allow(meal_a).to receive(:total_servings).and_return(8)
    expect(subject.points_earned).to eq -2
  end
end
