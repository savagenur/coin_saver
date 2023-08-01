enum TimeGroupType { month, week, day, year }
const Map<int, TimeGroupType> chartTimeGroupTypeValues = {
  0: TimeGroupType.year,
  1: TimeGroupType.month,
  2: TimeGroupType.week,
  3: TimeGroupType.day,
  
}; 

// int? getTimeGroupTypeKeyByValue(Map<int, TimeGroupType> map, TimeGroupType value) {
//   for (var entry in map.entries) {
//     if (entry.value == value) {
//       return entry.key;
//     }
//   }
//   return null;
// }