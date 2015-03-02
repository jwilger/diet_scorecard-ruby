require 'diet_scorecard/food_type'

describe DietScorecard::FoodType do
  let(:score_table) {[2,2,1,1,0,-1]}

  subject {
    described_class.new(:sauce, score_table: score_table)
  }

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
    expect(subject.minimum_servings).to eq 2
  end

  it 'recommends a maximum serving of the last serving with a non-zero point value' do
    expect(subject.maximum_servings).to eq 4
  end

  context 'when a food has no positive point values' do
    let(:score_table) { [0] }

    it 'recommends a minimum of 0 servings' do
      expect(subject.minimum_servings).to eq 0
    end
  end

  it 'requires the point value of servings to be in descending order' do
    expect {
      described_class.new(:wev, score_table: [2,2,0,1])
    }.to raise_error(ArgumentError, "score_table must be in strictly descending order")
  end

  it 'is immutable' do
    expect(subject).to be_frozen
  end

  it 'also has an immutable points table' do
    score_table = [2,1,0]
    x = described_class.new(:thing, score_table: score_table)
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

  context 'sorting different food types' do
    it 'sorts food types with identical score tables by key' do
      sauce = described_class.new(:sauce, score_table: score_table)
      beans = described_class.new(:beans, score_table: score_table)
      junk = described_class.new(:junk, score_table: score_table)
      
      expect([sauce, beans, junk].sort).to eq [beans, junk, sauce]
    end

    it 'sorts by the highest mean score for six servings' do
      score_a = [2,2,2,2,1,0]
      score_b = [2,2,2,2,0,0]
      score_c = [2,2,1,1,1,0]
      score_d = [2,2,1,0,-1,-1]
      score_e = [1,1,1,0,0,-1]
      score_f = [0,0,-1,-1,-2,-2]
      score_g = [-1,-1,-1,-1,-1,-1]
      score_h = [-1,-1,-1,-1,-1,-2]

      food_typer = ->(l, s) { described_class.new(l, score_table: s) }

      a = food_typer.(:a, score_a)
      b = food_typer.(:b, score_b)
      c = food_typer.(:c, score_c)
      d = food_typer.(:d, score_d)
      e = food_typer.(:e, score_e)
      f = food_typer.(:f, score_f)
      g = food_typer.(:g, score_g)
      h = food_typer.(:h, score_h)

      expect([b,d,f,h,g,e,c,a].sort).to eq [a,b,c,d,e,f,g,h]
    end
  end
end
