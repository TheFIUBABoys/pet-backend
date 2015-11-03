class ReportsController < ApplicationController

  def index
    @data = {}

    pets = Pet.where(created_at: date_range, published: true)

    @data[I18n.t("reports.index.published")] = pets.for_adoption.count
    @data[I18n.t("reports.index.adopted")]   = pets.for_adoption.approved.count
    @data[I18n.t("reports.index.lost")]      = pets.lost.count
    @data[I18n.t("reports.index.found")]     = pets.lost.approved.count

    adopted_pets = Pet.for_adoption.approved
    @avg_adoption_time = average_approved_time(adopted_pets)

    found_pets = Pet.lost.approved
    @avg_found_time = average_approved_time(found_pets)
  end

  private

  def date_range
    from = Date.parse(params.fetch(:from, 1.month.ago.to_s))
    to   = Date.parse(params.fetch(:to, Date.today.to_s))

    [from..to]
  end

  def average_approved_time(pets)
    return 0 if pets.empty?

    time_taken = pets.map { |p| p.adoption_requests.find_by(approved: true).created_at - p.created_at }
    time_taken.inject(&:+).to_f / pets.count
  end

end
