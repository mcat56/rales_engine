class DatesFacade
  attr_reader :data
  def initialize(best_day)
    @data = { data: { attributes: { best_day: best_day.to_s[0..9] } } }
  end

end
