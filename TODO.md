# TODO list

* Stop using JSON in database and use separate fields instead. When the user request a config JSON or
  polygon GeoJSON, just generate them (create some helper functions for them). Doing this will enable
  the edit task method to fill all the fields with the same configuration.
