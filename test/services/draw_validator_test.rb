require "test_helper"

class DrawValidatorTest < ActiveSupport::TestCase
  test "valid draw with no exclusions" do
    group = Group.create!(name: "Test Group", password: "password123")
    person1 = Person.create!(name: "Alice", group: group)
    person2 = Person.create!(name: "Bob", group: group)
    person3 = Person.create!(name: "Charlie", group: group)

    assert group.draw_possible?, "Draw should be possible with 3 people and no exclusions"
  end

  test "invalid draw with complete exclusion deadlock" do
    group = Group.create!(name: "Test Group", password: "password123")
    alice = Person.create!(name: "Alice", group: group)
    bob = Person.create!(name: "Bob", group: group)
    charlie = Person.create!(name: "Charlie", group: group)

    # Everyone excludes everyone else - impossible configuration
    alice.excluded_people << [ bob, charlie ]
    bob.excluded_people << [ alice, charlie ]
    charlie.excluded_people << [ alice, bob ]

    assert_not group.draw_possible?, "Draw should not be possible when everyone excludes everyone"
    assert group.draw_validation_errors.any?, "Should have validation errors"
  end

  test "invalid draw with mutual exclusions in small group" do
    group = Group.create!(name: "Test Group", password: "password123")
    alice = Person.create!(name: "Alice", group: group)
    bob = Person.create!(name: "Bob", group: group)

    # Both exclude each other
    alice.excluded_people << bob
    bob.excluded_people << alice

    assert_not group.draw_possible?, "Draw should not be possible when only 2 people exclude each other"
  end

  test "valid draw with some exclusions" do
    group = Group.create!(name: "Test Group", password: "password123")
    alice = Person.create!(name: "Alice", group: group)
    bob = Person.create!(name: "Bob", group: group)
    charlie = Person.create!(name: "Charlie", group: group)
    diana = Person.create!(name: "Diana", group: group)

    # Alice excludes Bob (but Bob doesn't exclude Alice)
    alice.excluded_people << bob

    assert group.draw_possible?, "Draw should be possible with 4 people and one exclusion"
  end

  test "invalid draw with too few participants" do
    group = Group.create!(name: "Test Group", password: "password123")
    alice = Person.create!(name: "Alice", group: group)

    assert_not group.draw_possible?, "Draw should not be possible with only 1 person"
  end

  test "valid draw with seed data configuration" do
    # Replicate the seed data exclusions
    group = Group.create!(name: "Natal 2025", password: "secret123")

    leonardo = Person.create!(name: "Leonardo", group: group)
    michelle = Person.create!(name: "Michelle", group: group)
    aline = Person.create!(name: "Aline", group: group)
    davi = Person.create!(name: "Davi", group: group)
    rafa = Person.create!(name: "Rafa", group: group)
    gabriel = Person.create!(name: "Gabriel", group: group)
    dani = Person.create!(name: "Dani", group: group)
    luciana = Person.create!(name: "Luciana", group: group)
    luis = Person.create!(name: "Luis", group: group)
    diana = Person.create!(name: "Diana", group: group)
    almir = Person.create!(name: "Almir", group: group)
    irene = Person.create!(name: "Irene", group: group)

    leonardo.excluded_people << michelle
    michelle.excluded_people << leonardo

    aline.excluded_people << [ dani, davi, rafa, gabriel ]
    dani.excluded_people << [ aline, davi, rafa, gabriel ]
    davi.excluded_people << [ aline, dani, rafa, gabriel ]
    rafa.excluded_people << [ aline, dani, davi, gabriel ]
    gabriel.excluded_people << [ aline, dani, davi, rafa ]

    luciana.excluded_people << luis
    luis.excluded_people << luciana

    diana.excluded_people << almir
    almir.excluded_people << diana

    assert group.draw_possible?, "Draw should be possible with seed data configuration"
  end
end
