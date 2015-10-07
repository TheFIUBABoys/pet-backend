module ForgeryHelpers
  def forged_id
    Forgery(:basic).number(at_least: 1000, at_most: 10000)
  end
end
