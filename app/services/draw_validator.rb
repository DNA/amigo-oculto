class DrawValidator
  attr_reader :group, :people, :errors

  def initialize(group)
    @group = group
    @people = group.people.to_a
    @errors = []
  end

  def valid?
    @errors = []

    return add_error("Group must have at least 2 participants") if people.size < 2

    # Build constraint graph
    # For each person, determine who they CAN give to
    possible_recipients = build_possible_recipients_map

    # Check if any person has no possible recipients
    people.each do |person|
      if possible_recipients[person.id].empty?
        add_error("#{person.name} has no valid recipients (all options are excluded or constrained)")
        return false
      end
    end

    # Use backtracking to check if a valid assignment exists
    assignment = {}
    if can_assign?(people.dup, possible_recipients, assignment)
      true
    else
      add_error("No valid Secret Santa assignment exists with the current exclusions")
      false
    end
  end

  private

  def add_error(message)
    @errors << message
    false
  end

  def build_possible_recipients_map
    # Map person_id -> array of possible recipient person_ids
    map = {}

    people.each do |giver|
      excluded_ids = giver.excluded_people.pluck(:id)

      # A person can give to anyone except:
      # - themselves
      # - people they've excluded
      possible = people.reject do |recipient|
        recipient.id == giver.id || excluded_ids.include?(recipient.id)
      end

      map[giver.id] = possible.map(&:id)
    end

    map
  end

  def can_assign?(remaining_people, possible_recipients, assignment)
    # Base case: all people have been assigned
    return true if remaining_people.empty?

    giver = remaining_people.shift

    # Get possible recipients for this giver
    possible = possible_recipients[giver.id].dup

    # Remove people who are already receivers
    possible -= assignment.values

    # Remove people who would create a bidirectional assignment
    # If this giver is already receiving from someone, they can't give back to that person
    if assignment.values.include?(giver.id)
      giver_of_current = assignment.key(giver.id)
      possible.delete(giver_of_current)
    end

    # Try each possible recipient
    possible.each do |recipient_id|
      # Check bidirectional constraint: if we assign giver -> recipient,
      # then recipient can't give to giver
      # We need to ensure that if recipient hasn't been assigned yet,
      # they will have at least one valid option after this constraint

      assignment[giver.id] = recipient_id

      # Recursively try to assign the rest
      if can_assign?(remaining_people.dup, possible_recipients, assignment.dup)
        return true
      end

      # Backtrack
      assignment.delete(giver.id)
    end

    # No valid assignment found for this branch
    false
  end
end
