require_relative "test_helper"

describe Door do

  let(:door) { Door.new }

  describe "initial state" do
    it "is closed" do
      assert_equal false, door.open?
      assert_equal true,  door.closed?
    end

    it "is unlocked" do
      assert_equal true,  door.knob_unlocked?
      assert_equal false, door.knob_locked?
      assert_equal true,  door.deadbolt_unlocked?
      assert_equal false, door.deadbolt_locked?
    end
  end

  it "can open and close when unlocked" do
    door.close!
    assert_equal true, door.closed?
    door.open!
    assert_equal false, door.closed?
    door.close!
  end

  describe "that is closed" do
    before(:each) { door.close! }

    it "can be redundantly closed" do
      assert_equal true, door.closed?
      door.close!
      assert_equal true, door.closed?
    end

    describe "with deadbolt locked" do
      before(:each) { door.lock_deadbolt! }

      it "knows it is locked" do
        assert_equal true, door.deadbolt_locked?
        assert_equal false, door.knob_locked?
      end

      it "cannot open" do
        assert_door_cannot_open
      end

      it "can open if deadbolt unlocked" do
        door.unlock_deadbolt!
        assert_closed_door_can_open
      end
    end

    describe "with knob locked" do
      before(:each) { door.lock_knob! }

      it "knows it is locked" do
        assert_equal true, door.knob_locked?
        assert_equal false, door.deadbolt_locked?
      end

      it "cannot open" do
        assert_door_cannot_open
      end

      it "can open if knob unlocked" do
        door.unlock_knob!
        assert_closed_door_can_open
      end
    end
  end

  describe "that is open" do
    before(:each) { door.open! }

    it "can be redundantly opened" do
      assert_equal true, door.open?
      door.open!
      assert_equal true, door.open?
    end

    describe "with deadbolt locked" do
      before(:each) { door.lock_deadbolt! }

      it "cannot close" do
        assert_door_cannot_close
      end

      it "can close if deadbolt unlocked" do
        door.unlock_deadbolt!
        assert_open_door_can_close
      end
    end

    describe "with knob locked" do
      before(:each) { door.lock_knob! }

      it "can close" do
        assert_open_door_can_close
      end
    end
  end

  describe "that is closed with both locks locked" do
    before(:each) do
      door.close!
      door.lock_knob!
      door.lock_deadbolt!
    end

    it "cannot open" do
    assert_door_cannot_open
    end

    it "cannot open if only knob unlocked" do
      door.unlock_knob!
      assert_door_cannot_open
    end

    it "cannot open if only deadbolt unlocked" do
      door.unlock_deadbolt!
      assert_door_cannot_open
    end

    it "can open if only both unlocked" do
      door.unlock_knob!
      door.unlock_deadbolt!
      assert_closed_door_can_open
    end
  end

  # –––––– Helpers ––––––

  def assert_closed_door_can_open
    assert_equal true, door.may_open?
    assert_equal false, door.open?
    door.open!
    assert_equal true, door.open?
  end

  def assert_open_door_can_close
    assert_equal true, door.may_close?
    assert_equal false, door.closed?
    door.close!
    assert_equal true, door.closed?
  end

  def assert_door_cannot_open
    assert_equal false, door.may_open?
    assert_invalid_transition { door.open! }
  end

  def assert_door_cannot_close
    assert_equal false, door.may_close?
    assert_invalid_transition { door.close! }
  end
end
