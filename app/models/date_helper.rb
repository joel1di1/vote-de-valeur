class DateHelper

  @@default_start_date =  DateTime.new(2012,04,20)
  @@default_end_date =  DateTime.new(2012,05,01)

  def self.current_configuration
    configuration = Configuration.find_by_name 'current'
    if configuration.nil?
      configuration = Configuration.create :name => 'current', :start_date => @@default_start_date, :end_date => @@default_end_date
      if !configuration.save
        raise configuration.errors.inspect
      end
    end
    configuration
  end

  def self.election_starts_at= datetime
    configuration = current_configuration()
    configuration.update_attribute :start_date, datetime
  end

  def self.election_ends_at= datetime
    configuration = current_configuration()
    configuration.update_attribute :end_date, datetime
  end

  def self.election_starts_at
    current_configuration().start_date
  end

  def self.election_ends_at
    current_configuration().end_date
  end

  def self.election_running?
    now = DateTime.now
    config = current_configuration
    config.start_date < now && now < config.end_date
  end

  def self.election_closed?
     DateTime.now > current_configuration.end_date
  end

  def self.election_started?
     DateTime.now > current_configuration.start_date
  end

  def self.set_election_time start_date, end_date
     current_configuration.update_attributes :start_date => start_date, :end_date => end_date
  end

  def self.format datetime
    I18n.l datetime, :locale => :fr
  end
  def self.format_start
    self.format self.election_starts_at
  end
  def self.format_end
    self.format self.election_ends_at
  end

end