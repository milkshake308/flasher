class IoProgress {
  int current;
  final int total;

  IoProgress({required this.current, required this.total});

  double get fraction {
    if (total <= 0 || current <= 0) {
      return 0;
    }
    if (current >= total) {
      return 1;
    }
    return current / total;
  }
}
