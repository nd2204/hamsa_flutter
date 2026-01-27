enum RepeatCycle {
  none,
  daily,
  weekly,
  monthly,
  yearly;

  String get displayName {
    switch (this) {
      case RepeatCycle.none:
        return "Không lặp lại";
      case RepeatCycle.daily:
        return "Hàng ngày";
      case RepeatCycle.weekly:
        return "Hàng tuần";
      case RepeatCycle.monthly:
        return "Hàng tháng";
      case RepeatCycle.yearly:
        return "Hàng năm";
    }
  }

  static RepeatCycle fromString(String value) {
    switch (value) {
      case "Không lặp lại":
        return RepeatCycle.none;
      case "Hàng ngày":
        return RepeatCycle.daily;
      case "Hàng tuần":
        return RepeatCycle.weekly;
      case "Hàng tháng":
        return RepeatCycle.monthly;
      case "Hàng năm":
        return RepeatCycle.yearly;
      default:
        return RepeatCycle.none;
    }
  }

  static RepeatCycle fromInt(int value) {
    return RepeatCycle.values[value];
  }
}
