// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    amount,
    category,
    note,
    transactionDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String type;
  final int amount;
  final String category;
  final String? note;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    this.note,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<int>(amount);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      type: Value(type),
      amount: Value(amount),
      category: Value(category),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      transactionDate: Value(transactionDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<int>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      note: serializer.fromJson<String?>(json['note']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<int>(amount),
      'category': serializer.toJson<String>(category),
      'note': serializer.toJson<String?>(note),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Transaction copyWith({
    String? id,
    String? type,
    int? amount,
    String? category,
    Value<String?> note = const Value.absent(),
    DateTime? transactionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Transaction(
    id: id ?? this.id,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    note: note.present ? note.value : this.note,
    transactionDate: transactionDate ?? this.transactionDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      note: data.note.present ? data.note.value : this.note,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    amount,
    category,
    note,
    transactionDate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.note == this.note &&
          other.transactionDate == this.transactionDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> type;
  final Value<int> amount;
  final Value<String> category;
  final Value<String?> note;
  final Value<DateTime> transactionDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.note = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String type,
    required int amount,
    required String category,
    this.note = const Value.absent(),
    required DateTime transactionDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       amount = Value(amount),
       category = Value(category),
       transactionDate = Value(transactionDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<int>? amount,
    Expression<String>? category,
    Expression<String>? note,
    Expression<DateTime>? transactionDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (note != null) 'note': note,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<int>? amount,
    Value<String>? category,
    Value<String?>? note,
    Value<DateTime>? transactionDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayLaterInstallmentPlansTable extends PayLaterInstallmentPlans
    with TableInfo<$PayLaterInstallmentPlansTable, PayLaterInstallmentPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayLaterInstallmentPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerNameMeta = const VerificationMeta(
    'providerName',
  );
  @override
  late final GeneratedColumn<String> providerName = GeneratedColumn<String>(
    'provider_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalAmountMeta = const VerificationMeta(
    'originalAmount',
  );
  @override
  late final GeneratedColumn<int> originalAmount = GeneratedColumn<int>(
    'original_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyPaymentAmountMeta =
      const VerificationMeta('monthlyPaymentAmount');
  @override
  late final GeneratedColumn<int> monthlyPaymentAmount = GeneratedColumn<int>(
    'monthly_payment_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minimumPaymentAmountMeta =
      const VerificationMeta('minimumPaymentAmount');
  @override
  late final GeneratedColumn<int> minimumPaymentAmount = GeneratedColumn<int>(
    'minimum_payment_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<int> paidAmount = GeneratedColumn<int>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalInstallmentsMeta = const VerificationMeta(
    'totalInstallments',
  );
  @override
  late final GeneratedColumn<int> totalInstallments = GeneratedColumn<int>(
    'total_installments',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidInstallmentsMeta = const VerificationMeta(
    'paidInstallments',
  );
  @override
  late final GeneratedColumn<int> paidInstallments = GeneratedColumn<int>(
    'paid_installments',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDayOfMonthMeta = const VerificationMeta(
    'dueDayOfMonth',
  );
  @override
  late final GeneratedColumn<int> dueDayOfMonth = GeneratedColumn<int>(
    'due_day_of_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    providerName,
    originalAmount,
    monthlyPaymentAmount,
    minimumPaymentAmount,
    paidAmount,
    totalInstallments,
    paidInstallments,
    startDate,
    dueDayOfMonth,
    status,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pay_later_installment_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<PayLaterInstallmentPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('provider_name')) {
      context.handle(
        _providerNameMeta,
        providerName.isAcceptableOrUnknown(
          data['provider_name']!,
          _providerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerNameMeta);
    }
    if (data.containsKey('original_amount')) {
      context.handle(
        _originalAmountMeta,
        originalAmount.isAcceptableOrUnknown(
          data['original_amount']!,
          _originalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalAmountMeta);
    }
    if (data.containsKey('monthly_payment_amount')) {
      context.handle(
        _monthlyPaymentAmountMeta,
        monthlyPaymentAmount.isAcceptableOrUnknown(
          data['monthly_payment_amount']!,
          _monthlyPaymentAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyPaymentAmountMeta);
    }
    if (data.containsKey('minimum_payment_amount')) {
      context.handle(
        _minimumPaymentAmountMeta,
        minimumPaymentAmount.isAcceptableOrUnknown(
          data['minimum_payment_amount']!,
          _minimumPaymentAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minimumPaymentAmountMeta);
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAmountMeta);
    }
    if (data.containsKey('total_installments')) {
      context.handle(
        _totalInstallmentsMeta,
        totalInstallments.isAcceptableOrUnknown(
          data['total_installments']!,
          _totalInstallmentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalInstallmentsMeta);
    }
    if (data.containsKey('paid_installments')) {
      context.handle(
        _paidInstallmentsMeta,
        paidInstallments.isAcceptableOrUnknown(
          data['paid_installments']!,
          _paidInstallmentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paidInstallmentsMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('due_day_of_month')) {
      context.handle(
        _dueDayOfMonthMeta,
        dueDayOfMonth.isAcceptableOrUnknown(
          data['due_day_of_month']!,
          _dueDayOfMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dueDayOfMonthMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PayLaterInstallmentPlan map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayLaterInstallmentPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      providerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_name'],
      )!,
      originalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_amount'],
      )!,
      monthlyPaymentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_payment_amount'],
      )!,
      minimumPaymentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_payment_amount'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_amount'],
      )!,
      totalInstallments: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_installments'],
      )!,
      paidInstallments: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_installments'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      dueDayOfMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day_of_month'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PayLaterInstallmentPlansTable createAlias(String alias) {
    return $PayLaterInstallmentPlansTable(attachedDatabase, alias);
  }
}

class PayLaterInstallmentPlan extends DataClass
    implements Insertable<PayLaterInstallmentPlan> {
  final String id;
  final String title;
  final String providerName;
  final int originalAmount;
  final int monthlyPaymentAmount;
  final int minimumPaymentAmount;
  final int paidAmount;
  final int totalInstallments;
  final int paidInstallments;
  final DateTime startDate;
  final int dueDayOfMonth;
  final String status;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PayLaterInstallmentPlan({
    required this.id,
    required this.title,
    required this.providerName,
    required this.originalAmount,
    required this.monthlyPaymentAmount,
    required this.minimumPaymentAmount,
    required this.paidAmount,
    required this.totalInstallments,
    required this.paidInstallments,
    required this.startDate,
    required this.dueDayOfMonth,
    required this.status,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['provider_name'] = Variable<String>(providerName);
    map['original_amount'] = Variable<int>(originalAmount);
    map['monthly_payment_amount'] = Variable<int>(monthlyPaymentAmount);
    map['minimum_payment_amount'] = Variable<int>(minimumPaymentAmount);
    map['paid_amount'] = Variable<int>(paidAmount);
    map['total_installments'] = Variable<int>(totalInstallments);
    map['paid_installments'] = Variable<int>(paidInstallments);
    map['start_date'] = Variable<DateTime>(startDate);
    map['due_day_of_month'] = Variable<int>(dueDayOfMonth);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PayLaterInstallmentPlansCompanion toCompanion(bool nullToAbsent) {
    return PayLaterInstallmentPlansCompanion(
      id: Value(id),
      title: Value(title),
      providerName: Value(providerName),
      originalAmount: Value(originalAmount),
      monthlyPaymentAmount: Value(monthlyPaymentAmount),
      minimumPaymentAmount: Value(minimumPaymentAmount),
      paidAmount: Value(paidAmount),
      totalInstallments: Value(totalInstallments),
      paidInstallments: Value(paidInstallments),
      startDate: Value(startDate),
      dueDayOfMonth: Value(dueDayOfMonth),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PayLaterInstallmentPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayLaterInstallmentPlan(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      providerName: serializer.fromJson<String>(json['providerName']),
      originalAmount: serializer.fromJson<int>(json['originalAmount']),
      monthlyPaymentAmount: serializer.fromJson<int>(
        json['monthlyPaymentAmount'],
      ),
      minimumPaymentAmount: serializer.fromJson<int>(
        json['minimumPaymentAmount'],
      ),
      paidAmount: serializer.fromJson<int>(json['paidAmount']),
      totalInstallments: serializer.fromJson<int>(json['totalInstallments']),
      paidInstallments: serializer.fromJson<int>(json['paidInstallments']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      dueDayOfMonth: serializer.fromJson<int>(json['dueDayOfMonth']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'providerName': serializer.toJson<String>(providerName),
      'originalAmount': serializer.toJson<int>(originalAmount),
      'monthlyPaymentAmount': serializer.toJson<int>(monthlyPaymentAmount),
      'minimumPaymentAmount': serializer.toJson<int>(minimumPaymentAmount),
      'paidAmount': serializer.toJson<int>(paidAmount),
      'totalInstallments': serializer.toJson<int>(totalInstallments),
      'paidInstallments': serializer.toJson<int>(paidInstallments),
      'startDate': serializer.toJson<DateTime>(startDate),
      'dueDayOfMonth': serializer.toJson<int>(dueDayOfMonth),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PayLaterInstallmentPlan copyWith({
    String? id,
    String? title,
    String? providerName,
    int? originalAmount,
    int? monthlyPaymentAmount,
    int? minimumPaymentAmount,
    int? paidAmount,
    int? totalInstallments,
    int? paidInstallments,
    DateTime? startDate,
    int? dueDayOfMonth,
    String? status,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PayLaterInstallmentPlan(
    id: id ?? this.id,
    title: title ?? this.title,
    providerName: providerName ?? this.providerName,
    originalAmount: originalAmount ?? this.originalAmount,
    monthlyPaymentAmount: monthlyPaymentAmount ?? this.monthlyPaymentAmount,
    minimumPaymentAmount: minimumPaymentAmount ?? this.minimumPaymentAmount,
    paidAmount: paidAmount ?? this.paidAmount,
    totalInstallments: totalInstallments ?? this.totalInstallments,
    paidInstallments: paidInstallments ?? this.paidInstallments,
    startDate: startDate ?? this.startDate,
    dueDayOfMonth: dueDayOfMonth ?? this.dueDayOfMonth,
    status: status ?? this.status,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PayLaterInstallmentPlan copyWithCompanion(
    PayLaterInstallmentPlansCompanion data,
  ) {
    return PayLaterInstallmentPlan(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      providerName: data.providerName.present
          ? data.providerName.value
          : this.providerName,
      originalAmount: data.originalAmount.present
          ? data.originalAmount.value
          : this.originalAmount,
      monthlyPaymentAmount: data.monthlyPaymentAmount.present
          ? data.monthlyPaymentAmount.value
          : this.monthlyPaymentAmount,
      minimumPaymentAmount: data.minimumPaymentAmount.present
          ? data.minimumPaymentAmount.value
          : this.minimumPaymentAmount,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      totalInstallments: data.totalInstallments.present
          ? data.totalInstallments.value
          : this.totalInstallments,
      paidInstallments: data.paidInstallments.present
          ? data.paidInstallments.value
          : this.paidInstallments,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      dueDayOfMonth: data.dueDayOfMonth.present
          ? data.dueDayOfMonth.value
          : this.dueDayOfMonth,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayLaterInstallmentPlan(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('providerName: $providerName, ')
          ..write('originalAmount: $originalAmount, ')
          ..write('monthlyPaymentAmount: $monthlyPaymentAmount, ')
          ..write('minimumPaymentAmount: $minimumPaymentAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('totalInstallments: $totalInstallments, ')
          ..write('paidInstallments: $paidInstallments, ')
          ..write('startDate: $startDate, ')
          ..write('dueDayOfMonth: $dueDayOfMonth, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    providerName,
    originalAmount,
    monthlyPaymentAmount,
    minimumPaymentAmount,
    paidAmount,
    totalInstallments,
    paidInstallments,
    startDate,
    dueDayOfMonth,
    status,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayLaterInstallmentPlan &&
          other.id == this.id &&
          other.title == this.title &&
          other.providerName == this.providerName &&
          other.originalAmount == this.originalAmount &&
          other.monthlyPaymentAmount == this.monthlyPaymentAmount &&
          other.minimumPaymentAmount == this.minimumPaymentAmount &&
          other.paidAmount == this.paidAmount &&
          other.totalInstallments == this.totalInstallments &&
          other.paidInstallments == this.paidInstallments &&
          other.startDate == this.startDate &&
          other.dueDayOfMonth == this.dueDayOfMonth &&
          other.status == this.status &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PayLaterInstallmentPlansCompanion
    extends UpdateCompanion<PayLaterInstallmentPlan> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> providerName;
  final Value<int> originalAmount;
  final Value<int> monthlyPaymentAmount;
  final Value<int> minimumPaymentAmount;
  final Value<int> paidAmount;
  final Value<int> totalInstallments;
  final Value<int> paidInstallments;
  final Value<DateTime> startDate;
  final Value<int> dueDayOfMonth;
  final Value<String> status;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PayLaterInstallmentPlansCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.providerName = const Value.absent(),
    this.originalAmount = const Value.absent(),
    this.monthlyPaymentAmount = const Value.absent(),
    this.minimumPaymentAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.totalInstallments = const Value.absent(),
    this.paidInstallments = const Value.absent(),
    this.startDate = const Value.absent(),
    this.dueDayOfMonth = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayLaterInstallmentPlansCompanion.insert({
    required String id,
    required String title,
    required String providerName,
    required int originalAmount,
    required int monthlyPaymentAmount,
    required int minimumPaymentAmount,
    required int paidAmount,
    required int totalInstallments,
    required int paidInstallments,
    required DateTime startDate,
    required int dueDayOfMonth,
    required String status,
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       providerName = Value(providerName),
       originalAmount = Value(originalAmount),
       monthlyPaymentAmount = Value(monthlyPaymentAmount),
       minimumPaymentAmount = Value(minimumPaymentAmount),
       paidAmount = Value(paidAmount),
       totalInstallments = Value(totalInstallments),
       paidInstallments = Value(paidInstallments),
       startDate = Value(startDate),
       dueDayOfMonth = Value(dueDayOfMonth),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PayLaterInstallmentPlan> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? providerName,
    Expression<int>? originalAmount,
    Expression<int>? monthlyPaymentAmount,
    Expression<int>? minimumPaymentAmount,
    Expression<int>? paidAmount,
    Expression<int>? totalInstallments,
    Expression<int>? paidInstallments,
    Expression<DateTime>? startDate,
    Expression<int>? dueDayOfMonth,
    Expression<String>? status,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (providerName != null) 'provider_name': providerName,
      if (originalAmount != null) 'original_amount': originalAmount,
      if (monthlyPaymentAmount != null)
        'monthly_payment_amount': monthlyPaymentAmount,
      if (minimumPaymentAmount != null)
        'minimum_payment_amount': minimumPaymentAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (totalInstallments != null) 'total_installments': totalInstallments,
      if (paidInstallments != null) 'paid_installments': paidInstallments,
      if (startDate != null) 'start_date': startDate,
      if (dueDayOfMonth != null) 'due_day_of_month': dueDayOfMonth,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayLaterInstallmentPlansCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? providerName,
    Value<int>? originalAmount,
    Value<int>? monthlyPaymentAmount,
    Value<int>? minimumPaymentAmount,
    Value<int>? paidAmount,
    Value<int>? totalInstallments,
    Value<int>? paidInstallments,
    Value<DateTime>? startDate,
    Value<int>? dueDayOfMonth,
    Value<String>? status,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PayLaterInstallmentPlansCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      providerName: providerName ?? this.providerName,
      originalAmount: originalAmount ?? this.originalAmount,
      monthlyPaymentAmount: monthlyPaymentAmount ?? this.monthlyPaymentAmount,
      minimumPaymentAmount: minimumPaymentAmount ?? this.minimumPaymentAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      paidInstallments: paidInstallments ?? this.paidInstallments,
      startDate: startDate ?? this.startDate,
      dueDayOfMonth: dueDayOfMonth ?? this.dueDayOfMonth,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (providerName.present) {
      map['provider_name'] = Variable<String>(providerName.value);
    }
    if (originalAmount.present) {
      map['original_amount'] = Variable<int>(originalAmount.value);
    }
    if (monthlyPaymentAmount.present) {
      map['monthly_payment_amount'] = Variable<int>(monthlyPaymentAmount.value);
    }
    if (minimumPaymentAmount.present) {
      map['minimum_payment_amount'] = Variable<int>(minimumPaymentAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<int>(paidAmount.value);
    }
    if (totalInstallments.present) {
      map['total_installments'] = Variable<int>(totalInstallments.value);
    }
    if (paidInstallments.present) {
      map['paid_installments'] = Variable<int>(paidInstallments.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (dueDayOfMonth.present) {
      map['due_day_of_month'] = Variable<int>(dueDayOfMonth.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayLaterInstallmentPlansCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('providerName: $providerName, ')
          ..write('originalAmount: $originalAmount, ')
          ..write('monthlyPaymentAmount: $monthlyPaymentAmount, ')
          ..write('minimumPaymentAmount: $minimumPaymentAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('totalInstallments: $totalInstallments, ')
          ..write('paidInstallments: $paidInstallments, ')
          ..write('startDate: $startDate, ')
          ..write('dueDayOfMonth: $dueDayOfMonth, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayLaterInvoicesTable extends PayLaterInvoices
    with TableInfo<$PayLaterInvoicesTable, PayLaterInvoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayLaterInvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerNameMeta = const VerificationMeta(
    'providerName',
  );
  @override
  late final GeneratedColumn<String> providerName = GeneratedColumn<String>(
    'provider_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statementMonthMeta = const VerificationMeta(
    'statementMonth',
  );
  @override
  late final GeneratedColumn<DateTime> statementMonth =
      GeneratedColumn<DateTime>(
        'statement_month',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _statementDateMeta = const VerificationMeta(
    'statementDate',
  );
  @override
  late final GeneratedColumn<DateTime> statementDate =
      GeneratedColumn<DateTime>(
        'statement_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minimumPaymentAmountMeta =
      const VerificationMeta('minimumPaymentAmount');
  @override
  late final GeneratedColumn<int> minimumPaymentAmount = GeneratedColumn<int>(
    'minimum_payment_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAmountMeta = const VerificationMeta(
    'paidAmount',
  );
  @override
  late final GeneratedColumn<int> paidAmount = GeneratedColumn<int>(
    'paid_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    providerName,
    statementMonth,
    statementDate,
    dueDate,
    totalAmount,
    minimumPaymentAmount,
    paidAmount,
    status,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pay_later_invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<PayLaterInvoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('provider_name')) {
      context.handle(
        _providerNameMeta,
        providerName.isAcceptableOrUnknown(
          data['provider_name']!,
          _providerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerNameMeta);
    }
    if (data.containsKey('statement_month')) {
      context.handle(
        _statementMonthMeta,
        statementMonth.isAcceptableOrUnknown(
          data['statement_month']!,
          _statementMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_statementMonthMeta);
    }
    if (data.containsKey('statement_date')) {
      context.handle(
        _statementDateMeta,
        statementDate.isAcceptableOrUnknown(
          data['statement_date']!,
          _statementDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_statementDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('minimum_payment_amount')) {
      context.handle(
        _minimumPaymentAmountMeta,
        minimumPaymentAmount.isAcceptableOrUnknown(
          data['minimum_payment_amount']!,
          _minimumPaymentAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minimumPaymentAmountMeta);
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
        _paidAmountMeta,
        paidAmount.isAcceptableOrUnknown(data['paid_amount']!, _paidAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAmountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PayLaterInvoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayLaterInvoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      providerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_name'],
      )!,
      statementMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}statement_month'],
      )!,
      statementDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}statement_date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount'],
      )!,
      minimumPaymentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_payment_amount'],
      )!,
      paidAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_amount'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PayLaterInvoicesTable createAlias(String alias) {
    return $PayLaterInvoicesTable(attachedDatabase, alias);
  }
}

class PayLaterInvoice extends DataClass implements Insertable<PayLaterInvoice> {
  final String id;
  final String providerName;
  final DateTime statementMonth;
  final DateTime statementDate;
  final DateTime dueDate;
  final int totalAmount;
  final int minimumPaymentAmount;
  final int paidAmount;
  final String status;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PayLaterInvoice({
    required this.id,
    required this.providerName,
    required this.statementMonth,
    required this.statementDate,
    required this.dueDate,
    required this.totalAmount,
    required this.minimumPaymentAmount,
    required this.paidAmount,
    required this.status,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['provider_name'] = Variable<String>(providerName);
    map['statement_month'] = Variable<DateTime>(statementMonth);
    map['statement_date'] = Variable<DateTime>(statementDate);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['total_amount'] = Variable<int>(totalAmount);
    map['minimum_payment_amount'] = Variable<int>(minimumPaymentAmount);
    map['paid_amount'] = Variable<int>(paidAmount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PayLaterInvoicesCompanion toCompanion(bool nullToAbsent) {
    return PayLaterInvoicesCompanion(
      id: Value(id),
      providerName: Value(providerName),
      statementMonth: Value(statementMonth),
      statementDate: Value(statementDate),
      dueDate: Value(dueDate),
      totalAmount: Value(totalAmount),
      minimumPaymentAmount: Value(minimumPaymentAmount),
      paidAmount: Value(paidAmount),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PayLaterInvoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayLaterInvoice(
      id: serializer.fromJson<String>(json['id']),
      providerName: serializer.fromJson<String>(json['providerName']),
      statementMonth: serializer.fromJson<DateTime>(json['statementMonth']),
      statementDate: serializer.fromJson<DateTime>(json['statementDate']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
      minimumPaymentAmount: serializer.fromJson<int>(
        json['minimumPaymentAmount'],
      ),
      paidAmount: serializer.fromJson<int>(json['paidAmount']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'providerName': serializer.toJson<String>(providerName),
      'statementMonth': serializer.toJson<DateTime>(statementMonth),
      'statementDate': serializer.toJson<DateTime>(statementDate),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'totalAmount': serializer.toJson<int>(totalAmount),
      'minimumPaymentAmount': serializer.toJson<int>(minimumPaymentAmount),
      'paidAmount': serializer.toJson<int>(paidAmount),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PayLaterInvoice copyWith({
    String? id,
    String? providerName,
    DateTime? statementMonth,
    DateTime? statementDate,
    DateTime? dueDate,
    int? totalAmount,
    int? minimumPaymentAmount,
    int? paidAmount,
    String? status,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PayLaterInvoice(
    id: id ?? this.id,
    providerName: providerName ?? this.providerName,
    statementMonth: statementMonth ?? this.statementMonth,
    statementDate: statementDate ?? this.statementDate,
    dueDate: dueDate ?? this.dueDate,
    totalAmount: totalAmount ?? this.totalAmount,
    minimumPaymentAmount: minimumPaymentAmount ?? this.minimumPaymentAmount,
    paidAmount: paidAmount ?? this.paidAmount,
    status: status ?? this.status,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PayLaterInvoice copyWithCompanion(PayLaterInvoicesCompanion data) {
    return PayLaterInvoice(
      id: data.id.present ? data.id.value : this.id,
      providerName: data.providerName.present
          ? data.providerName.value
          : this.providerName,
      statementMonth: data.statementMonth.present
          ? data.statementMonth.value
          : this.statementMonth,
      statementDate: data.statementDate.present
          ? data.statementDate.value
          : this.statementDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      minimumPaymentAmount: data.minimumPaymentAmount.present
          ? data.minimumPaymentAmount.value
          : this.minimumPaymentAmount,
      paidAmount: data.paidAmount.present
          ? data.paidAmount.value
          : this.paidAmount,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayLaterInvoice(')
          ..write('id: $id, ')
          ..write('providerName: $providerName, ')
          ..write('statementMonth: $statementMonth, ')
          ..write('statementDate: $statementDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('minimumPaymentAmount: $minimumPaymentAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    providerName,
    statementMonth,
    statementDate,
    dueDate,
    totalAmount,
    minimumPaymentAmount,
    paidAmount,
    status,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayLaterInvoice &&
          other.id == this.id &&
          other.providerName == this.providerName &&
          other.statementMonth == this.statementMonth &&
          other.statementDate == this.statementDate &&
          other.dueDate == this.dueDate &&
          other.totalAmount == this.totalAmount &&
          other.minimumPaymentAmount == this.minimumPaymentAmount &&
          other.paidAmount == this.paidAmount &&
          other.status == this.status &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PayLaterInvoicesCompanion extends UpdateCompanion<PayLaterInvoice> {
  final Value<String> id;
  final Value<String> providerName;
  final Value<DateTime> statementMonth;
  final Value<DateTime> statementDate;
  final Value<DateTime> dueDate;
  final Value<int> totalAmount;
  final Value<int> minimumPaymentAmount;
  final Value<int> paidAmount;
  final Value<String> status;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PayLaterInvoicesCompanion({
    this.id = const Value.absent(),
    this.providerName = const Value.absent(),
    this.statementMonth = const Value.absent(),
    this.statementDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.minimumPaymentAmount = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayLaterInvoicesCompanion.insert({
    required String id,
    required String providerName,
    required DateTime statementMonth,
    required DateTime statementDate,
    required DateTime dueDate,
    required int totalAmount,
    required int minimumPaymentAmount,
    required int paidAmount,
    required String status,
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       providerName = Value(providerName),
       statementMonth = Value(statementMonth),
       statementDate = Value(statementDate),
       dueDate = Value(dueDate),
       totalAmount = Value(totalAmount),
       minimumPaymentAmount = Value(minimumPaymentAmount),
       paidAmount = Value(paidAmount),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PayLaterInvoice> custom({
    Expression<String>? id,
    Expression<String>? providerName,
    Expression<DateTime>? statementMonth,
    Expression<DateTime>? statementDate,
    Expression<DateTime>? dueDate,
    Expression<int>? totalAmount,
    Expression<int>? minimumPaymentAmount,
    Expression<int>? paidAmount,
    Expression<String>? status,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (providerName != null) 'provider_name': providerName,
      if (statementMonth != null) 'statement_month': statementMonth,
      if (statementDate != null) 'statement_date': statementDate,
      if (dueDate != null) 'due_date': dueDate,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (minimumPaymentAmount != null)
        'minimum_payment_amount': minimumPaymentAmount,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayLaterInvoicesCompanion copyWith({
    Value<String>? id,
    Value<String>? providerName,
    Value<DateTime>? statementMonth,
    Value<DateTime>? statementDate,
    Value<DateTime>? dueDate,
    Value<int>? totalAmount,
    Value<int>? minimumPaymentAmount,
    Value<int>? paidAmount,
    Value<String>? status,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PayLaterInvoicesCompanion(
      id: id ?? this.id,
      providerName: providerName ?? this.providerName,
      statementMonth: statementMonth ?? this.statementMonth,
      statementDate: statementDate ?? this.statementDate,
      dueDate: dueDate ?? this.dueDate,
      totalAmount: totalAmount ?? this.totalAmount,
      minimumPaymentAmount: minimumPaymentAmount ?? this.minimumPaymentAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (providerName.present) {
      map['provider_name'] = Variable<String>(providerName.value);
    }
    if (statementMonth.present) {
      map['statement_month'] = Variable<DateTime>(statementMonth.value);
    }
    if (statementDate.present) {
      map['statement_date'] = Variable<DateTime>(statementDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (minimumPaymentAmount.present) {
      map['minimum_payment_amount'] = Variable<int>(minimumPaymentAmount.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<int>(paidAmount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayLaterInvoicesCompanion(')
          ..write('id: $id, ')
          ..write('providerName: $providerName, ')
          ..write('statementMonth: $statementMonth, ')
          ..write('statementDate: $statementDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('minimumPaymentAmount: $minimumPaymentAmount, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayLaterPaymentsTable extends PayLaterPayments
    with TableInfo<$PayLaterPaymentsTable, PayLaterPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayLaterPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTypeMeta = const VerificationMeta(
    'targetType',
  );
  @override
  late final GeneratedColumn<String> targetType = GeneratedColumn<String>(
    'target_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentTypeMeta = const VerificationMeta(
    'paymentType',
  );
  @override
  late final GeneratedColumn<String> paymentType = GeneratedColumn<String>(
    'payment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetId,
    targetType,
    amount,
    paymentType,
    paidAt,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pay_later_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<PayLaterPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('target_type')) {
      context.handle(
        _targetTypeMeta,
        targetType.isAcceptableOrUnknown(data['target_type']!, _targetTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTypeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_type')) {
      context.handle(
        _paymentTypeMeta,
        paymentType.isAcceptableOrUnknown(
          data['payment_type']!,
          _paymentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentTypeMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    } else if (isInserting) {
      context.missing(_paidAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PayLaterPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayLaterPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      )!,
      targetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      paymentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_type'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PayLaterPaymentsTable createAlias(String alias) {
    return $PayLaterPaymentsTable(attachedDatabase, alias);
  }
}

class PayLaterPayment extends DataClass implements Insertable<PayLaterPayment> {
  final String id;
  final String targetId;
  final String targetType;
  final int amount;
  final String paymentType;
  final DateTime paidAt;
  final String? note;
  final DateTime createdAt;
  const PayLaterPayment({
    required this.id,
    required this.targetId,
    required this.targetType,
    required this.amount,
    required this.paymentType,
    required this.paidAt,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['target_id'] = Variable<String>(targetId);
    map['target_type'] = Variable<String>(targetType);
    map['amount'] = Variable<int>(amount);
    map['payment_type'] = Variable<String>(paymentType);
    map['paid_at'] = Variable<DateTime>(paidAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PayLaterPaymentsCompanion toCompanion(bool nullToAbsent) {
    return PayLaterPaymentsCompanion(
      id: Value(id),
      targetId: Value(targetId),
      targetType: Value(targetType),
      amount: Value(amount),
      paymentType: Value(paymentType),
      paidAt: Value(paidAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory PayLaterPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayLaterPayment(
      id: serializer.fromJson<String>(json['id']),
      targetId: serializer.fromJson<String>(json['targetId']),
      targetType: serializer.fromJson<String>(json['targetType']),
      amount: serializer.fromJson<int>(json['amount']),
      paymentType: serializer.fromJson<String>(json['paymentType']),
      paidAt: serializer.fromJson<DateTime>(json['paidAt']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'targetId': serializer.toJson<String>(targetId),
      'targetType': serializer.toJson<String>(targetType),
      'amount': serializer.toJson<int>(amount),
      'paymentType': serializer.toJson<String>(paymentType),
      'paidAt': serializer.toJson<DateTime>(paidAt),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PayLaterPayment copyWith({
    String? id,
    String? targetId,
    String? targetType,
    int? amount,
    String? paymentType,
    DateTime? paidAt,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => PayLaterPayment(
    id: id ?? this.id,
    targetId: targetId ?? this.targetId,
    targetType: targetType ?? this.targetType,
    amount: amount ?? this.amount,
    paymentType: paymentType ?? this.paymentType,
    paidAt: paidAt ?? this.paidAt,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  PayLaterPayment copyWithCompanion(PayLaterPaymentsCompanion data) {
    return PayLaterPayment(
      id: data.id.present ? data.id.value : this.id,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentType: data.paymentType.present
          ? data.paymentType.value
          : this.paymentType,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayLaterPayment(')
          ..write('id: $id, ')
          ..write('targetId: $targetId, ')
          ..write('targetType: $targetType, ')
          ..write('amount: $amount, ')
          ..write('paymentType: $paymentType, ')
          ..write('paidAt: $paidAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetId,
    targetType,
    amount,
    paymentType,
    paidAt,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayLaterPayment &&
          other.id == this.id &&
          other.targetId == this.targetId &&
          other.targetType == this.targetType &&
          other.amount == this.amount &&
          other.paymentType == this.paymentType &&
          other.paidAt == this.paidAt &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class PayLaterPaymentsCompanion extends UpdateCompanion<PayLaterPayment> {
  final Value<String> id;
  final Value<String> targetId;
  final Value<String> targetType;
  final Value<int> amount;
  final Value<String> paymentType;
  final Value<DateTime> paidAt;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PayLaterPaymentsCompanion({
    this.id = const Value.absent(),
    this.targetId = const Value.absent(),
    this.targetType = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentType = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayLaterPaymentsCompanion.insert({
    required String id,
    required String targetId,
    required String targetType,
    required int amount,
    required String paymentType,
    required DateTime paidAt,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       targetId = Value(targetId),
       targetType = Value(targetType),
       amount = Value(amount),
       paymentType = Value(paymentType),
       paidAt = Value(paidAt),
       createdAt = Value(createdAt);
  static Insertable<PayLaterPayment> custom({
    Expression<String>? id,
    Expression<String>? targetId,
    Expression<String>? targetType,
    Expression<int>? amount,
    Expression<String>? paymentType,
    Expression<DateTime>? paidAt,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetId != null) 'target_id': targetId,
      if (targetType != null) 'target_type': targetType,
      if (amount != null) 'amount': amount,
      if (paymentType != null) 'payment_type': paymentType,
      if (paidAt != null) 'paid_at': paidAt,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayLaterPaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? targetId,
    Value<String>? targetType,
    Value<int>? amount,
    Value<String>? paymentType,
    Value<DateTime>? paidAt,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PayLaterPaymentsCompanion(
      id: id ?? this.id,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      amount: amount ?? this.amount,
      paymentType: paymentType ?? this.paymentType,
      paidAt: paidAt ?? this.paidAt,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(targetType.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (paymentType.present) {
      map['payment_type'] = Variable<String>(paymentType.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayLaterPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('targetId: $targetId, ')
          ..write('targetType: $targetType, ')
          ..write('amount: $amount, ')
          ..write('paymentType: $paymentType, ')
          ..write('paidAt: $paidAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $PayLaterInstallmentPlansTable payLaterInstallmentPlans =
      $PayLaterInstallmentPlansTable(this);
  late final $PayLaterInvoicesTable payLaterInvoices = $PayLaterInvoicesTable(
    this,
  );
  late final $PayLaterPaymentsTable payLaterPayments = $PayLaterPaymentsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    transactions,
    payLaterInstallmentPlans,
    payLaterInvoices,
    payLaterPayments,
  ];
}

typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required String type,
      required int amount,
      required String category,
      Value<String?> note,
      required DateTime transactionDate,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<int> amount,
      Value<String> category,
      Value<String?> note,
      Value<DateTime> transactionDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            Transaction,
            BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
          ),
          Transaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                type: type,
                amount: amount,
                category: category,
                note: note,
                transactionDate: transactionDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required int amount,
                required String category,
                Value<String?> note = const Value.absent(),
                required DateTime transactionDate,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                type: type,
                amount: amount,
                category: category,
                note: note,
                transactionDate: transactionDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        Transaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
      ),
      Transaction,
      PrefetchHooks Function()
    >;
typedef $$PayLaterInstallmentPlansTableCreateCompanionBuilder =
    PayLaterInstallmentPlansCompanion Function({
      required String id,
      required String title,
      required String providerName,
      required int originalAmount,
      required int monthlyPaymentAmount,
      required int minimumPaymentAmount,
      required int paidAmount,
      required int totalInstallments,
      required int paidInstallments,
      required DateTime startDate,
      required int dueDayOfMonth,
      required String status,
      Value<String?> note,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PayLaterInstallmentPlansTableUpdateCompanionBuilder =
    PayLaterInstallmentPlansCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> providerName,
      Value<int> originalAmount,
      Value<int> monthlyPaymentAmount,
      Value<int> minimumPaymentAmount,
      Value<int> paidAmount,
      Value<int> totalInstallments,
      Value<int> paidInstallments,
      Value<DateTime> startDate,
      Value<int> dueDayOfMonth,
      Value<String> status,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PayLaterInstallmentPlansTableFilterComposer
    extends Composer<_$AppDatabase, $PayLaterInstallmentPlansTable> {
  $$PayLaterInstallmentPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalAmount => $composableBuilder(
    column: $table.originalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyPaymentAmount => $composableBuilder(
    column: $table.monthlyPaymentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumPaymentAmount => $composableBuilder(
    column: $table.minimumPaymentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalInstallments => $composableBuilder(
    column: $table.totalInstallments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidInstallments => $composableBuilder(
    column: $table.paidInstallments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDayOfMonth => $composableBuilder(
    column: $table.dueDayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PayLaterInstallmentPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $PayLaterInstallmentPlansTable> {
  $$PayLaterInstallmentPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalAmount => $composableBuilder(
    column: $table.originalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyPaymentAmount => $composableBuilder(
    column: $table.monthlyPaymentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumPaymentAmount => $composableBuilder(
    column: $table.minimumPaymentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalInstallments => $composableBuilder(
    column: $table.totalInstallments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidInstallments => $composableBuilder(
    column: $table.paidInstallments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDayOfMonth => $composableBuilder(
    column: $table.dueDayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PayLaterInstallmentPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayLaterInstallmentPlansTable> {
  $$PayLaterInstallmentPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originalAmount => $composableBuilder(
    column: $table.originalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyPaymentAmount => $composableBuilder(
    column: $table.monthlyPaymentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minimumPaymentAmount => $composableBuilder(
    column: $table.minimumPaymentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalInstallments => $composableBuilder(
    column: $table.totalInstallments,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paidInstallments => $composableBuilder(
    column: $table.paidInstallments,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get dueDayOfMonth => $composableBuilder(
    column: $table.dueDayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PayLaterInstallmentPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PayLaterInstallmentPlansTable,
          PayLaterInstallmentPlan,
          $$PayLaterInstallmentPlansTableFilterComposer,
          $$PayLaterInstallmentPlansTableOrderingComposer,
          $$PayLaterInstallmentPlansTableAnnotationComposer,
          $$PayLaterInstallmentPlansTableCreateCompanionBuilder,
          $$PayLaterInstallmentPlansTableUpdateCompanionBuilder,
          (
            PayLaterInstallmentPlan,
            BaseReferences<
              _$AppDatabase,
              $PayLaterInstallmentPlansTable,
              PayLaterInstallmentPlan
            >,
          ),
          PayLaterInstallmentPlan,
          PrefetchHooks Function()
        > {
  $$PayLaterInstallmentPlansTableTableManager(
    _$AppDatabase db,
    $PayLaterInstallmentPlansTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayLaterInstallmentPlansTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PayLaterInstallmentPlansTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PayLaterInstallmentPlansTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> providerName = const Value.absent(),
                Value<int> originalAmount = const Value.absent(),
                Value<int> monthlyPaymentAmount = const Value.absent(),
                Value<int> minimumPaymentAmount = const Value.absent(),
                Value<int> paidAmount = const Value.absent(),
                Value<int> totalInstallments = const Value.absent(),
                Value<int> paidInstallments = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<int> dueDayOfMonth = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PayLaterInstallmentPlansCompanion(
                id: id,
                title: title,
                providerName: providerName,
                originalAmount: originalAmount,
                monthlyPaymentAmount: monthlyPaymentAmount,
                minimumPaymentAmount: minimumPaymentAmount,
                paidAmount: paidAmount,
                totalInstallments: totalInstallments,
                paidInstallments: paidInstallments,
                startDate: startDate,
                dueDayOfMonth: dueDayOfMonth,
                status: status,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String providerName,
                required int originalAmount,
                required int monthlyPaymentAmount,
                required int minimumPaymentAmount,
                required int paidAmount,
                required int totalInstallments,
                required int paidInstallments,
                required DateTime startDate,
                required int dueDayOfMonth,
                required String status,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PayLaterInstallmentPlansCompanion.insert(
                id: id,
                title: title,
                providerName: providerName,
                originalAmount: originalAmount,
                monthlyPaymentAmount: monthlyPaymentAmount,
                minimumPaymentAmount: minimumPaymentAmount,
                paidAmount: paidAmount,
                totalInstallments: totalInstallments,
                paidInstallments: paidInstallments,
                startDate: startDate,
                dueDayOfMonth: dueDayOfMonth,
                status: status,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PayLaterInstallmentPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PayLaterInstallmentPlansTable,
      PayLaterInstallmentPlan,
      $$PayLaterInstallmentPlansTableFilterComposer,
      $$PayLaterInstallmentPlansTableOrderingComposer,
      $$PayLaterInstallmentPlansTableAnnotationComposer,
      $$PayLaterInstallmentPlansTableCreateCompanionBuilder,
      $$PayLaterInstallmentPlansTableUpdateCompanionBuilder,
      (
        PayLaterInstallmentPlan,
        BaseReferences<
          _$AppDatabase,
          $PayLaterInstallmentPlansTable,
          PayLaterInstallmentPlan
        >,
      ),
      PayLaterInstallmentPlan,
      PrefetchHooks Function()
    >;
typedef $$PayLaterInvoicesTableCreateCompanionBuilder =
    PayLaterInvoicesCompanion Function({
      required String id,
      required String providerName,
      required DateTime statementMonth,
      required DateTime statementDate,
      required DateTime dueDate,
      required int totalAmount,
      required int minimumPaymentAmount,
      required int paidAmount,
      required String status,
      Value<String?> note,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PayLaterInvoicesTableUpdateCompanionBuilder =
    PayLaterInvoicesCompanion Function({
      Value<String> id,
      Value<String> providerName,
      Value<DateTime> statementMonth,
      Value<DateTime> statementDate,
      Value<DateTime> dueDate,
      Value<int> totalAmount,
      Value<int> minimumPaymentAmount,
      Value<int> paidAmount,
      Value<String> status,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PayLaterInvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $PayLaterInvoicesTable> {
  $$PayLaterInvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get statementMonth => $composableBuilder(
    column: $table.statementMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get statementDate => $composableBuilder(
    column: $table.statementDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumPaymentAmount => $composableBuilder(
    column: $table.minimumPaymentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PayLaterInvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $PayLaterInvoicesTable> {
  $$PayLaterInvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get statementMonth => $composableBuilder(
    column: $table.statementMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get statementDate => $composableBuilder(
    column: $table.statementDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumPaymentAmount => $composableBuilder(
    column: $table.minimumPaymentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PayLaterInvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayLaterInvoicesTable> {
  $$PayLaterInvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get providerName => $composableBuilder(
    column: $table.providerName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get statementMonth => $composableBuilder(
    column: $table.statementMonth,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get statementDate => $composableBuilder(
    column: $table.statementDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minimumPaymentAmount => $composableBuilder(
    column: $table.minimumPaymentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paidAmount => $composableBuilder(
    column: $table.paidAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PayLaterInvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PayLaterInvoicesTable,
          PayLaterInvoice,
          $$PayLaterInvoicesTableFilterComposer,
          $$PayLaterInvoicesTableOrderingComposer,
          $$PayLaterInvoicesTableAnnotationComposer,
          $$PayLaterInvoicesTableCreateCompanionBuilder,
          $$PayLaterInvoicesTableUpdateCompanionBuilder,
          (
            PayLaterInvoice,
            BaseReferences<
              _$AppDatabase,
              $PayLaterInvoicesTable,
              PayLaterInvoice
            >,
          ),
          PayLaterInvoice,
          PrefetchHooks Function()
        > {
  $$PayLaterInvoicesTableTableManager(
    _$AppDatabase db,
    $PayLaterInvoicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayLaterInvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayLaterInvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayLaterInvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> providerName = const Value.absent(),
                Value<DateTime> statementMonth = const Value.absent(),
                Value<DateTime> statementDate = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<int> totalAmount = const Value.absent(),
                Value<int> minimumPaymentAmount = const Value.absent(),
                Value<int> paidAmount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PayLaterInvoicesCompanion(
                id: id,
                providerName: providerName,
                statementMonth: statementMonth,
                statementDate: statementDate,
                dueDate: dueDate,
                totalAmount: totalAmount,
                minimumPaymentAmount: minimumPaymentAmount,
                paidAmount: paidAmount,
                status: status,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String providerName,
                required DateTime statementMonth,
                required DateTime statementDate,
                required DateTime dueDate,
                required int totalAmount,
                required int minimumPaymentAmount,
                required int paidAmount,
                required String status,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PayLaterInvoicesCompanion.insert(
                id: id,
                providerName: providerName,
                statementMonth: statementMonth,
                statementDate: statementDate,
                dueDate: dueDate,
                totalAmount: totalAmount,
                minimumPaymentAmount: minimumPaymentAmount,
                paidAmount: paidAmount,
                status: status,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PayLaterInvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PayLaterInvoicesTable,
      PayLaterInvoice,
      $$PayLaterInvoicesTableFilterComposer,
      $$PayLaterInvoicesTableOrderingComposer,
      $$PayLaterInvoicesTableAnnotationComposer,
      $$PayLaterInvoicesTableCreateCompanionBuilder,
      $$PayLaterInvoicesTableUpdateCompanionBuilder,
      (
        PayLaterInvoice,
        BaseReferences<_$AppDatabase, $PayLaterInvoicesTable, PayLaterInvoice>,
      ),
      PayLaterInvoice,
      PrefetchHooks Function()
    >;
typedef $$PayLaterPaymentsTableCreateCompanionBuilder =
    PayLaterPaymentsCompanion Function({
      required String id,
      required String targetId,
      required String targetType,
      required int amount,
      required String paymentType,
      required DateTime paidAt,
      Value<String?> note,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PayLaterPaymentsTableUpdateCompanionBuilder =
    PayLaterPaymentsCompanion Function({
      Value<String> id,
      Value<String> targetId,
      Value<String> targetType,
      Value<int> amount,
      Value<String> paymentType,
      Value<DateTime> paidAt,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PayLaterPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PayLaterPaymentsTable> {
  $$PayLaterPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PayLaterPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PayLaterPaymentsTable> {
  $$PayLaterPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PayLaterPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayLaterPaymentsTable> {
  $$PayLaterPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get paymentType => $composableBuilder(
    column: $table.paymentType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PayLaterPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PayLaterPaymentsTable,
          PayLaterPayment,
          $$PayLaterPaymentsTableFilterComposer,
          $$PayLaterPaymentsTableOrderingComposer,
          $$PayLaterPaymentsTableAnnotationComposer,
          $$PayLaterPaymentsTableCreateCompanionBuilder,
          $$PayLaterPaymentsTableUpdateCompanionBuilder,
          (
            PayLaterPayment,
            BaseReferences<
              _$AppDatabase,
              $PayLaterPaymentsTable,
              PayLaterPayment
            >,
          ),
          PayLaterPayment,
          PrefetchHooks Function()
        > {
  $$PayLaterPaymentsTableTableManager(
    _$AppDatabase db,
    $PayLaterPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayLaterPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayLaterPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayLaterPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> targetId = const Value.absent(),
                Value<String> targetType = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> paymentType = const Value.absent(),
                Value<DateTime> paidAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PayLaterPaymentsCompanion(
                id: id,
                targetId: targetId,
                targetType: targetType,
                amount: amount,
                paymentType: paymentType,
                paidAt: paidAt,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String targetId,
                required String targetType,
                required int amount,
                required String paymentType,
                required DateTime paidAt,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PayLaterPaymentsCompanion.insert(
                id: id,
                targetId: targetId,
                targetType: targetType,
                amount: amount,
                paymentType: paymentType,
                paidAt: paidAt,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PayLaterPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PayLaterPaymentsTable,
      PayLaterPayment,
      $$PayLaterPaymentsTableFilterComposer,
      $$PayLaterPaymentsTableOrderingComposer,
      $$PayLaterPaymentsTableAnnotationComposer,
      $$PayLaterPaymentsTableCreateCompanionBuilder,
      $$PayLaterPaymentsTableUpdateCompanionBuilder,
      (
        PayLaterPayment,
        BaseReferences<_$AppDatabase, $PayLaterPaymentsTable, PayLaterPayment>,
      ),
      PayLaterPayment,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$PayLaterInstallmentPlansTableTableManager get payLaterInstallmentPlans =>
      $$PayLaterInstallmentPlansTableTableManager(
        _db,
        _db.payLaterInstallmentPlans,
      );
  $$PayLaterInvoicesTableTableManager get payLaterInvoices =>
      $$PayLaterInvoicesTableTableManager(_db, _db.payLaterInvoices);
  $$PayLaterPaymentsTableTableManager get payLaterPayments =>
      $$PayLaterPaymentsTableTableManager(_db, _db.payLaterPayments);
}
