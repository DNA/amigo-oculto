class DrawGenerator
  attr_reader :group, :people, :errors

  def initialize(group)
    @group = group
    @people = group.people.to_a
    @errors = []
  end

  def generate
    @errors = []

    # First validate that a draw is possible
    validator = DrawValidator.new(group)
    unless validator.valid?
      @errors = validator.errors
      return false
    end

    # Check if draw already exists
    if group.draws.exists?
      @errors << "Draw has already been generated for this group"
      return false
    end

    # Generate the draw
    assignment = find_valid_assignment

    if assignment
      # Save all draws in a transaction
      Draw.transaction do
        assignment.each do |giver_id, receiver_id|
          Draw.create!(
            group: group,
            giver_id: giver_id,
            receiver_id: receiver_id
          )
        end
      end
      true
    else
      @errors << "Failed to generate a valid draw (this should not happen if validation passed)"
      false
    end
  end

  private

  def find_valid_assignment
    possible_recipients = build_possible_recipients_map

    result = can_assign?(people.shuffle, possible_recipients, {})
    result.is_a?(Hash) ? result : nil
  end

  def build_possible_recipients_map
    map = {}

    people.each do |giver|
      excluded_ids = giver.excluded_people.pluck(:id)

      possible = people.reject do |recipient|
        recipient.id == giver.id || excluded_ids.include?(recipient.id)
      end

      map[giver.id] = possible.map(&:id)
    end

    map
  end

  def can_assign?(remaining_people, possible_recipients, assignment)
    return assignment if remaining_people.empty?

    giver = remaining_people.shift
    possible = possible_recipients[giver.id].dup

    # Remove already assigned receivers
    possible -= assignment.values

    # Remove bidirectional constraint: if someone already gives to this giver,
    # this giver can't give back to them
    if assignment.values.include?(giver.id)
      giver_of_current = assignment.key(giver.id)
      possible.delete(giver_of_current)
    end

    # Try each possible recipient
    possible.shuffle.each do |recipient_id|
      new_assignment = assignment.merge(giver.id => recipient_id)

      result = can_assign?(remaining_people.dup, possible_recipients, new_assignment)
      return result if result
    end

    false
  end
end
