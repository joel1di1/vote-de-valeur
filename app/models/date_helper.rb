class DateHelper

  @@start_date =  DateTime.new(2012,04,20)
  @@end_date =  DateTime.new(2012,05,01)

  def self.election_starts_at= datetime
    @@start_date = datetime
  end

  def self.election_ends_at= datetime
    @@end_date = datetime
  end

  def self.election_starts_at
    @@start_date
  end

  def self.election_ends_at
    @@end_date
  end

  def self.election_running?
    now = DateTime.now
    @@start_date < now && now < @@end_date
  end

  def self.election_closed?
     DateTime.now  > @@end_date
  end

end