require_relative '../../../app/models/diet_scorecard/food_type'

describe DietScorecard::FoodType do
  let(:score_table) {[2,2,1,1,0,-1]}

  subject {
    described_class.new(:sauce, name: 'Awesome Sauces',
                        score_table: score_table)
  }

  it 'has a name' do
    expect(subject.name).to eq 'Awesome Sauces'
  end

  it 'has a key' do
    expect(subject.key).to eq :sauce
  end

  it 'has a score for each serving' do
    expect(subject.points_for_serving(1)).to eq 2
    expect(subject.points_for_serving(2)).to eq 2
    expect(subject.points_for_serving(3)).to eq 1
    expect(subject.points_for_serving(4)).to eq 1
    expect(subject.points_for_serving(5)).to eq 0
    expect(subject.points_for_serving(6)).to eq -1
  end

  it 'has the same score for each serving beyond the last defined serving' do
    expect(subject.points_for_serving(7)).to eq -1
  end

  it 'fails if you ask for an irrational serving number (less than the first serving)' do
    [-1,0].each do |n|
      expect { subject.points_for_serving(n) }.to \
        raise_error(ArgumentError, "Serving number must be an integer greater than 0")
    end
  end

  it 'recommends a minimum serving of the last serving with the highest point value' do
    expect(subject.minumum_servings).to eq 2
  end

  it 'recommends a maximum serving of the last serving with a non-zero point value' do
    expect(subject.maximum_servings).to eq 4
  end

  it 'requires the point value of servings to be in descending order' do
    expect {
      described_class.new(:wev, name: 'something', score_table: [2,2,0,1])
    }.to raise_error(ArgumentError, "score_table must be in strictly descending order")
  end

  it 'is immutable' do
    expect(subject).to be_frozen
  end

  it 'also has an immutable points table' do
    score_table = [2,1,0]
    x = described_class.new(:thing, name: 'Foo', score_table: score_table)
    score_table.reverse!
    expect(x.points_for_serving(1)).to eq 2
    expect(x.points_for_serving(2)).to eq 1
    expect(x.points_for_serving(3)).to eq 0
  end

  context 'when the minimum and maximum servings are the same' do
    let(:score_table) { [1,1,1,0,-1,-1] }

    it 'recommends a range with a single value' do
      expect(subject.recommended_servings).to eq 3
    end
  end

  context 'when the minimum and maximum servings are different' do
    it 'recommends a range form the minimum to the maximum serving' do
      expect(subject.recommended_servings).to eq 2..4
    end
  end
end
