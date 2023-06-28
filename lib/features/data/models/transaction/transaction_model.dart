import 'package:hive/hive.dart';
import '../../../domain/entities/transaction/transaction_entity.dart';

part 'transaction_model.g.dart';


@HiveType(typeId: 2)
class TransactionModel extends TransactionEntity with HiveObjectMixin {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final String? description;
  @HiveField(5)
  final String account;
  @HiveField(6)
  final bool isIncome;
  @HiveField(7)
  final List<String>? tags;
  @HiveField(8)
  final String? payee;
  @HiveField(9)
  final String? currency;
  @HiveField(10)
  final String? location;
  @HiveField(11)
  final String? receiptImage;
  @HiveField(12)
  final String? paymentMethod;
  @HiveField(13)
  final bool? isRecurring;
  @HiveField(14)
  final String? frequency;
  @HiveField(15)
  final DateTime? reminderDate;
  @HiveField(16)
  final bool? isCleared;
  @HiveField(17)
  final String? notes;
  @HiveField(18)
  final List<String>? linkedTransactions;
  @HiveField(19)
  final bool? isVoid;

  TransactionModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.category,
    required this.account,
    required this.isIncome,
    this.description,
    this.tags,
    this.payee,
    this.currency,
    this.location,
    this.receiptImage,
    this.paymentMethod,
    this.isRecurring,
    this.frequency,
    this.reminderDate,
    this.isCleared,
    this.notes,
    this.linkedTransactions,
    this.isVoid,
  }) : super(
          id: id,
          date: date,
          amount: amount,
          category: category,
          description: description,
          account: account,
          isIncome: isIncome,
          tags: tags,
          payee: payee,
          currency: currency,
          location: location,
          receiptImage: receiptImage,
          paymentMethod: paymentMethod,
          isRecurring: isRecurring,
          frequency: frequency,
          reminderDate: reminderDate,
          isCleared: isCleared,
          notes: notes,
          linkedTransactions: linkedTransactions,
          isVoid: isVoid,
        );

  TransactionModel copyWith({
    String? id,
    DateTime? date,
    double? amount,
    String? category,
    String? description,
    String? account,
    bool? isIncome,
    List<String>? tags,
    String? payee,
    String? currency,
    String? location,
    String? receiptImage,
    String? paymentMethod,
    bool? isRecurring,
    String? frequency,
    DateTime? reminderDate,
    bool? isCleared,
    String? notes,
    List<String>? linkedTransactions,
    bool? isVoid,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      account: account ?? this.account,
      isIncome: isIncome ?? this.isIncome,
      tags: tags ?? this.tags,
      payee: payee ?? this.payee,
      currency: currency ?? this.currency,
      location: location ?? this.location,
      receiptImage: receiptImage ?? this.receiptImage,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isRecurring: isRecurring ?? this.isRecurring,
      frequency: frequency ?? this.frequency,
      reminderDate: reminderDate ?? this.reminderDate,
      isCleared: isCleared ?? this.isCleared,
      notes: notes ?? this.notes,
      linkedTransactions: linkedTransactions ?? this.linkedTransactions,
      isVoid: isVoid ?? this.isVoid,
    );
  }
}
