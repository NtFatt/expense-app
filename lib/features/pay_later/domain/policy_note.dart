import 'pay_later_enums.dart';

class PolicyNote {
  const PolicyNote({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final PolicySeverity severity;
  final String category;
}
