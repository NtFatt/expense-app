import 'pay_later_enums.dart';

class PayLaterPayment {
  const PayLaterPayment({
    required this.id,
    required this.targetId,
    required this.targetType,
    required this.amount,
    required this.paymentType,
    required this.paidAt,
    this.note,
    required this.createdAt,
  }) : assert(amount >= 0);

  final String id;
  final String targetId;
  final PayLaterTargetType targetType;
  final double amount;
  final PayLaterPaymentType paymentType;
  final DateTime paidAt;
  final String? note;
  final DateTime createdAt;
}
