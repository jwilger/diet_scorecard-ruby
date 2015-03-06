require 'rails_helper'

describe Food do
  context 'when a serving value is written as a string' do
    it 'provides it back as a float value' do
      subject.servings_fields.each do |field|
        subject.send("#{field}=", "2.5")
        expect(subject.send(field)).to eq 2.5
      end
    end
  end

  it 'has a servings field for each food type' do
    expect(subject.servings_fields).to eq DietScorecard::FoodType.map { |ft| "#{ft.key}_servings".to_sym }
  end
end
