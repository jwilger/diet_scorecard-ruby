module DietScorecard
  class DailyScorecard
    attr_accessor :date
    private :date=

    def initialize(date:)
      self.date = date.to_date
    end
  end
end
