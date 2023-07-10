class FeatureState {
  final String key;
  final bool? value;

  FeatureState({required this.key, required this.value});

  bool get isOverride => value != null;
}
