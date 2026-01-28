class UserId {
  final String value;
  UserId(this.value);

  @override
  bool operator ==(Object other) {
    return other is UserId && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "UserId($value)";
}
