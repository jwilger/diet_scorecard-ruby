require 'diet_scorecard/daily_scorecard'

describe DietScorecard::DailyScorecard do
  subject {
    described_class.new(date: the_date, meals_service: meals_service)
  }

  let(:the_date) { Date.new(2013,6,11) }

  let(:meals_service) { double(:meals_service, for_date: []) }

  it 'knows the date with which it was created' do
    expect(subject.date).to eq the_date
  end

  it 'can return the previous scorecard' do
    expect(subject.previous.date).to eq Date.new(2013,6,10)
  end

  it 'can return the next scorecard' do
    expect(subject.next.date).to eq Date.new(2013,6,12)
  end

  it 'can convert itself to params for Rails URL helpers' do
    expect(subject.to_param).to \
      eq({:year => '2013', :month => '6', :day => '11'})
  end

  it 'has a food type scorecard for each foodtype' do
    DietScorecard::FoodType.each do |food_type|
      result = subject.food_type_scorecards.detect { |ftsc|
        ftsc.food_type == food_type
      }
      expect(result).to be_present
    end
  end

  it 'reports the possible points as the sum of possible points from each food type scorecard' do
    expected_total = subject.food_type_scorecards.reduce(0) { |total, ftsc| total + ftsc.possible_points }
    expect(subject.possible_points).to eq expected_total
  end

  context 'when instantiated with a Time object for date' do
    let(:the_date) { Time.local(2014,10,13,14,21,33) }

    it 'converts the time to a date' do
      expect(subject.date).to eq the_date.to_date
    end
  end

  context 'when no meals have been recorded for the day' do
    it 'reports the total points as 0' do
      expect(subject.total_points).to eq 0
    end
  end
end
