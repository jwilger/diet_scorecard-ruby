require_relative '../../app/services/record_new_food'

RSpec.describe Services::RecordNewFood do
  context 'when a meal ID is provided' do
    it 'creates a new Food record associated with the meal'

    context 'when the food is successfully created' do
      it 'returns a Success result'
      it 'sets the result data to the newly created Food'
    end

    context 'when the food data is invalid' do
      it 'returns a Failure result'
      it 'sets the result data to the invalid Food object'
    end
  end

  context 'when no meal ID is provided' do
    it 'calls the RecordNewMeal service with the provided meal inputs'

    context 'when the new meal is recorded successfully' do
      it 'calls itself with the meal id input in addition to original food inputs'
      it 'returns the result of calling itself with the new inputs'
    end

    context 'when the new meal cannot be recorded' do
      it 'returns the failure result from the RecordNewMeal service'
    end
  end
end
