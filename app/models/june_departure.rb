class JuneDeparture < ActiveRecord::Base
  # NOTE: if you do not specify this, the schema is still in the
  # search path, so ActiveRecord will still find the table.
  # Name collisions between schema would be a problem.
  self.table_name = "reporting.june_departures"
  def self.refresh
    Scenic.database.refresh_materialized_view(table_name)
  end
end