require "aasm"

class Door
  include AASM

  aasm do
    state :closed, initial: true
    state :open

    event :open do
      transitions to: :open, if: [:deadbolt_unlocked?, :knob_unlocked?]
    end

    event :close do
      transitions to: :closed, if: :deadbolt_unlocked?
    end
  end

  aasm :deadbolt_lock, namespace: :deadbolt do
    state :unlocked, initial: true
    state :locked

    event :lock_deadbolt do
      transitions to: :locked
    end

    event :unlock_deadbolt do
      transitions to: :unlocked
    end
  end

  aasm :knob_lock, namespace: :knob do
    state :unlocked, initial: true
    state :locked

    event :lock_knob do
      transitions to: :locked
    end

    event :unlock_knob do
      transitions to: :unlocked
    end
  end
end
