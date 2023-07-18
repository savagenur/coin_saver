enum Period {
  day,
  week,
  month,
  year,
  period,
}

const Map<int, Period> periodValues = {
  0: Period.day,
  1: Period.week,
  2: Period.month,
  3: Period.year,
  4: Period.period,
};

  // Update the initial index to the desired value
  int? getKeyByValue(Map<int, Period> map, Period value) {
    // Loop through the map entries
    for (var entry in map.entries) {
      // Check if the entry value matches the given value
      if (entry.value == value) {
        // Return the key of the matching entry
        return entry.key;
      }
    }
    // If no match is found, return null
    return null;
  }