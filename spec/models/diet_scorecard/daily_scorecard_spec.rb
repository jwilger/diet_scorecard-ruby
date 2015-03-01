require_relative '../../../app/models/diet_scorecard/daily_scorecard'

describe DietScorecard::DailyScorecard do
  subject { described_class.new(date: the_date) }

  let(:the_date) { Time.now.to_date }

  it 'knows the date with which it was created' do
    expect(subject.date).to eq the_date
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
