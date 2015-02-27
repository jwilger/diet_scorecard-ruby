describe DietScorecard::DailyScorecard do
  subject { described_class.new(date: the_date) }

  let(:the_date) { Time.zone.now.to_date }

  it 'knows the date with which it was created' do
    expect(subject.date).to eq the_date
  end

  context 'when instantiated with a Time object for date' do
    let(:the_date) { Time.zone.local(2014,10,13,14,21,33) }

    it 'converts the time to a date' do
      expect(subject.date).to eq the_date.to_date
    end
  end
end
