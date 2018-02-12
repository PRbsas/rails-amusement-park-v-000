class Ride < ActiveRecord::Base
  belongs_to :user
  belongs_to :attraction

  def take_ride
    if enough_tickets? && tall_enough?
      go_on_ride
    elsif !enough_tickets? && tall_enough?
      "Sorry. #{not_enough_tickets_message}"
    elsif enough_tickets? && !tall_enough?
      "Sorry. #{not_tall_enough_message}"
    else
      "Sorry. #{not_enough_tickets_message} #{not_tall_enough_message}"
    end
  end

  def enough_tickets?
    self.user.tickets >= self.attraction.tickets
  end

  def tall_enough?
    self.user.height >= self.attraction.min_height
  end

  def not_enough_tickets_message
    "You do not have enough tickets to ride the #{self.attraction.name}."
  end

  def not_tall_enough_message
    "You are not tall enough to ride the #{self.attraction.name}."
  end

  def go_on_ride
    updated_happiness = self.user.happiness + self.attraction.happiness_rating
    tickets_left = self.user.tickets - self.attraction.tickets
    updated_nausea = self.user.nausea + self.attraction.nausea_rating

    self.user.update(happiness: updated_happiness, tickets: tickets_left, nausea: updated_nausea)
    self.user.save
    "Thanks for riding the #{self.attraction.name}!"
  end
end
