enum ChartPeriod{
  year,
  month,
  week,
  day,
}

const Map<int, ChartPeriod> chartPeriodValues = {
  0: ChartPeriod.year,
  1: ChartPeriod.month,
  2: ChartPeriod.week,
  3: ChartPeriod.day,
  
}; 

int? getChartPeriodKeyByValue(Map<int, ChartPeriod> map, ChartPeriod value) {
  for (var entry in map.entries) {
    if (entry.value == value) {
      return entry.key;
    }
  }
  return null;
}