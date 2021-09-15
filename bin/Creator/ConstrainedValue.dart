class ConstrainedValue {

  String name;
  int begin;
  int end;
  String type;

  ConstrainedValue(this.name, this.begin, this.end, this.type);

  void recomputeConstraint(ConstrainedValue constraint, Function compute) {
      var diff = constraint.end - constraint.begin;

      if (constraint.begin > begin) {
        return;
      }
      begin = compute(begin, diff);
      end = compute(end, diff);

  }

  @override
  String toString() {
    return ('$name of type {$type} [$begin - $end]\n');
  }

}