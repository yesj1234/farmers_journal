// enum DateView { day, week, month }
enum MainView { day, week, month, community }

/// PlaceAutocompleteStatus from [here](https://developers.google.com/maps/documentation/places/web-service/autocomplete?_gl=1*j7omyq*_up*MQ..*_ga*ODQ3MzE0MDQuMTczMjA4MjE0MA..*_ga_NRWSTWS78N*MTczMjA4MjEzOS4xLjEuMTczMjA4MjU1OS4wLjAuMA..#PlacesAutocompleteStatus)
enum ResponseStatus {
  OK,
  ZERO_RESULTS,
  INVALID_REQUEST,
  OVER_QUERY_LIMIT,
  REQUEST_DENIED,
  UNKNOWN_ERROR,
  OVER_DAILY_LIMIT,
}

/// LocationType from [here](https://developers.google.com/maps/documentation/geocoding/requests-geocoding?_gl=1*1upvnzh*_up*MQ..*_ga*ODM3MzE3NzYwLjE3MzIxOTA0OTE.*_ga_NRWSTWS78N*MTczMjE5MDQ5MC4xLjEuMTczMjE5MjM5My4wLjAuMA..#responses)
enum LocationType {
  ROOFTOP,
  RANGE_INTERPOLATED,
  GEOMETRIC_CENTER,
  APPROXIMATE,
}
