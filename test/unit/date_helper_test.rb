require 'test_helper'

class DateHelperTest < ActiveSupport::TestCase

  test "date helper read information from DB" do
    start_date = 3.days.ago
    end_date = 3.days.from_now

    Configuration.delete_all
    Configuration.create :name => 'current', :start_date => start_date, :end_date => end_date

    assert_equal start_date,DateHelper.election_starts_at
    assert_equal end_date,DateHelper.election_ends_at
  end

  test "election closed" do
    assert !election_closed?(1.day.ago, 1.day.from_now)
    assert !election_closed?(1.minute.ago, 1.minute.from_now)
    assert !election_closed?(1.day.from_now, 2.day.from_now)
    assert election_closed?(2.day.ago, 1.day.ago)
    assert election_closed?(2.day.ago, 1.second.ago)
    assert election_closed?(10.seconds.from_now, 1.day.ago)
  end

  test "election_running" do
    assert election_running?(1.day.ago, 1.day.from_now)
    assert election_running?(1.minute.ago, 1.minute.from_now)
    assert !election_running?(1.day.from_now, 2.day.from_now)
    assert !election_running?(2.day.ago, 1.day.ago)
    assert !election_running?(2.day.ago, 1.second.ago)
    assert !election_running?(10.seconds.from_now, 1.day.ago)
  end


  def election_running?(start, end_date)
    DateHelper.election_starts_at= start
    DateHelper.election_ends_at= end_date

    DateHelper.election_running?
  end

  def election_closed?(start, end_date)
    DateHelper.election_starts_at= start
    DateHelper.election_ends_at= end_date

    DateHelper.election_closed?
  end


end
