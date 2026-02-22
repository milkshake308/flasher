class IoProgress {
  final int current;
  final int total;

  const IoProgress({required this.current, required this.total});

  int get percentage => total > 0 ? ((current / total) * 100).round() : 0;
}
