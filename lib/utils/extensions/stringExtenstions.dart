// capitalized a string
extension StringExtension on String {
  String capitalize() => (this != null)
      ? '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}'
      : '';
  String get allInCaps => this.toUpperCase();
}
