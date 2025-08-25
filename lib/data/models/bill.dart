enum BillStatus {
  draft,
  pending,
  paid,
  overdue,
  cancelled,
  refunded;

  String get displayName {
    switch (this) {
      case BillStatus.draft:
        return 'Draft';
      case BillStatus.pending:
        return 'Pending';
      case BillStatus.paid:
        return 'Paid';
      case BillStatus.overdue:
        return 'Overdue';
      case BillStatus.cancelled:
        return 'Cancelled';
      case BillStatus.refunded:
        return 'Refunded';
    }
  }

  bool get isPaid => this == BillStatus.paid;

  bool get isPending => this == BillStatus.pending;

  bool get isOverdue => this == BillStatus.overdue;

  bool get canBePaid =>
      this == BillStatus.pending || this == BillStatus.overdue;
}

enum BillType {
  subscription,
  oneTime,
  usage,
  addon;

  String get displayName {
    switch (this) {
      case BillType.subscription:
        return 'Subscription';
      case BillType.oneTime:
        return 'One-time';
      case BillType.usage:
        return 'Usage-based';
      case BillType.addon:
        return 'Add-on';
    }
  }
}

enum PaymentMethod {
  creditCard,
  debitCard,
  bankTransfer,
  paypal,
  stripe,
  other;

  String get displayName {
    switch (this) {
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.stripe:
        return 'Stripe';
      case PaymentMethod.other:
        return 'Other';
    }
  }
}

class BillLineItem {
  final String id;
  final String description;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? productId;
  final Map<String, dynamic> metadata;

  const BillLineItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.productId,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'totalPrice': totalPrice,
    if (productId != null) 'productId': productId,
    'metadata': metadata,
  };

  factory BillLineItem.fromJson(Map<String, dynamic> json) => BillLineItem(
    id: json['id'],
    description: json['description'],
    quantity: json['quantity'],
    unitPrice: (json['unitPrice'] ?? 0.0).toDouble(),
    totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
    productId: json['productId'],
    metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
  );

  BillLineItem copyWith({
    String? id,
    String? description,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    String? productId,
    Map<String, dynamic>? metadata,
  }) {
    return BillLineItem(
      id: id ?? this.id,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      productId: productId ?? this.productId,
      metadata: metadata ?? this.metadata,
    );
  }
}

class BillAddress {
  final String? name;
  final String? company;
  final String street;
  final String? street2;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const BillAddress({
    this.name,
    this.company,
    required this.street,
    this.street2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  String get fullAddress {
    final parts = <String>[];
    if (name?.isNotEmpty == true) parts.add(name!);
    if (company?.isNotEmpty == true) parts.add(company!);
    parts.add(street);
    if (street2?.isNotEmpty == true) parts.add(street2!);
    parts.add('$city, $state $postalCode');
    parts.add(country);
    return parts.join('\n');
  }

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (company != null) 'company': company,
    'street': street,
    if (street2 != null) 'street2': street2,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'country': country,
  };

  factory BillAddress.fromJson(Map<String, dynamic> json) => BillAddress(
    name: json['name'],
    company: json['company'],
    street: json['street'],
    street2: json['street2'],
    city: json['city'],
    state: json['state'],
    postalCode: json['postalCode'],
    country: json['country'],
  );

  BillAddress copyWith({
    String? name,
    String? company,
    String? street,
    String? street2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
  }) {
    return BillAddress(
      name: name ?? this.name,
      company: company ?? this.company,
      street: street ?? this.street,
      street2: street2 ?? this.street2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }
}

class PaymentInfo {
  final PaymentMethod method;
  final String? transactionId;
  final String? paymentProcessorId;
  final DateTime? paidAt;
  final Map<String, dynamic> processorData;

  const PaymentInfo({
    required this.method,
    this.transactionId,
    this.paymentProcessorId,
    this.paidAt,
    this.processorData = const {},
  });

  Map<String, dynamic> toJson() => {
    'method': method.name,
    if (transactionId != null) 'transactionId': transactionId,
    if (paymentProcessorId != null) 'paymentProcessorId': paymentProcessorId,
    if (paidAt != null) 'paidAt': paidAt!.toIso8601String(),
    'processorData': processorData,
  };

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
    method: PaymentMethod.values.firstWhere(
      (e) => e.name == json['method'],
      orElse: () => PaymentMethod.other,
    ),
    transactionId: json['transactionId'],
    paymentProcessorId: json['paymentProcessorId'],
    paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    processorData: Map<String, dynamic>.from(json['processorData'] ?? {}),
  );

  PaymentInfo copyWith({
    PaymentMethod? method,
    String? transactionId,
    String? paymentProcessorId,
    DateTime? paidAt,
    Map<String, dynamic>? processorData,
  }) {
    return PaymentInfo(
      method: method ?? this.method,
      transactionId: transactionId ?? this.transactionId,
      paymentProcessorId: paymentProcessorId ?? this.paymentProcessorId,
      paidAt: paidAt ?? this.paidAt,
      processorData: processorData ?? this.processorData,
    );
  }
}

class Bill {
  final String id;
  final String billNumber;
  final String userId;
  final String? projectId;
  final BillType type;
  final BillStatus status;
  final String currency;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final List<BillLineItem> lineItems;
  final BillAddress? billingAddress;
  final PaymentInfo? paymentInfo;
  final DateTime issueDate;
  final DateTime dueDate;
  final DateTime? paidAt;
  final String? notes;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Bill({
    required this.id,
    required this.billNumber,
    required this.userId,
    this.projectId,
    required this.type,
    required this.status,
    required this.currency,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.lineItems,
    this.billingAddress,
    this.paymentInfo,
    required this.issueDate,
    required this.dueDate,
    this.paidAt,
    this.notes,
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  // Computed properties
  bool get isOverdue =>
      status != BillStatus.paid &&
      status != BillStatus.cancelled &&
      DateTime.now().isAfter(dueDate);

  bool get isPaid => status == BillStatus.paid;

  bool get isPending => status == BillStatus.pending;

  bool get canBePaid => status.canBePaid;

  int get daysPastDue {
    if (!isOverdue) return 0;
    return DateTime.now().difference(dueDate).inDays;
  }

  String get formattedTotal {
    return '${_getCurrencySymbol()}${totalAmount.toStringAsFixed(2)}';
  }

  String get formattedSubtotal {
    return '${_getCurrencySymbol()}${subtotal.toStringAsFixed(2)}';
  }

  String get formattedTax {
    return '${_getCurrencySymbol()}${taxAmount.toStringAsFixed(2)}';
  }

  String get formattedDiscount {
    return '${_getCurrencySymbol()}${discountAmount.toStringAsFixed(2)}';
  }

  String _getCurrencySymbol() {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      default:
        return '$currency ';
    }
  }

  double get taxRate {
    return subtotal > 0 ? (taxAmount / subtotal) * 100 : 0;
  }

  double get discountRate {
    return subtotal > 0 ? (discountAmount / subtotal) * 100 : 0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'billNumber': billNumber,
    'userId': userId,
    if (projectId != null) 'projectId': projectId,
    'type': type.name,
    'status': status.name,
    'currency': currency,
    'subtotal': subtotal,
    'taxAmount': taxAmount,
    'discountAmount': discountAmount,
    'totalAmount': totalAmount,
    'lineItems': lineItems.map((e) => e.toJson()).toList(),
    if (billingAddress != null) 'billingAddress': billingAddress!.toJson(),
    if (paymentInfo != null) 'paymentInfo': paymentInfo!.toJson(),
    'issueDate': issueDate.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    if (paidAt != null) 'paidAt': paidAt!.toIso8601String(),
    if (notes != null) 'notes': notes,
    'metadata': metadata,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
    id: json['id'],
    billNumber: json['billNumber'],
    userId: json['userId'],
    projectId: json['projectId'],
    type: BillType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => BillType.oneTime,
    ),
    status: BillStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => BillStatus.pending,
    ),
    currency: json['currency'] ?? 'USD',
    subtotal: (json['subtotal'] ?? 0.0).toDouble(),
    taxAmount: (json['taxAmount'] ?? 0.0).toDouble(),
    discountAmount: (json['discountAmount'] ?? 0.0).toDouble(),
    totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
    lineItems: (json['lineItems'] as List? ?? [])
        .map((e) => BillLineItem.fromJson(e))
        .toList(),
    billingAddress: json['billingAddress'] != null
        ? BillAddress.fromJson(json['billingAddress'])
        : null,
    paymentInfo: json['paymentInfo'] != null
        ? PaymentInfo.fromJson(json['paymentInfo'])
        : null,
    issueDate: DateTime.parse(
      json['issueDate'] ?? DateTime.now().toIso8601String(),
    ),
    dueDate: DateTime.parse(
      json['dueDate'] ??
          DateTime.now().add(const Duration(days: 30)).toIso8601String(),
    ),
    paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    notes: json['notes'],
    metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    createdAt: DateTime.parse(
      json['createdAt'] ?? DateTime.now().toIso8601String(),
    ),
    updatedAt: DateTime.parse(
      json['updatedAt'] ?? DateTime.now().toIso8601String(),
    ),
  );

  Bill copyWith({
    String? id,
    String? billNumber,
    String? userId,
    String? projectId,
    BillType? type,
    BillStatus? status,
    String? currency,
    double? subtotal,
    double? taxAmount,
    double? discountAmount,
    double? totalAmount,
    List<BillLineItem>? lineItems,
    BillAddress? billingAddress,
    PaymentInfo? paymentInfo,
    DateTime? issueDate,
    DateTime? dueDate,
    DateTime? paidAt,
    String? notes,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bill(
      id: id ?? this.id,
      billNumber: billNumber ?? this.billNumber,
      userId: userId ?? this.userId,
      projectId: projectId ?? this.projectId,
      type: type ?? this.type,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      lineItems: lineItems ?? this.lineItems,
      billingAddress: billingAddress ?? this.billingAddress,
      paymentInfo: paymentInfo ?? this.paymentInfo,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      paidAt: paidAt ?? this.paidAt,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods for common operations
  Bill markAsPaid({required PaymentInfo paymentInfo, DateTime? paidAt}) {
    return copyWith(
      status: BillStatus.paid,
      paymentInfo: paymentInfo,
      paidAt: paidAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Bill markAsOverdue() {
    if (DateTime.now().isAfter(dueDate) && status == BillStatus.pending) {
      return copyWith(status: BillStatus.overdue, updatedAt: DateTime.now());
    }
    return this;
  }

  Bill cancel() {
    return copyWith(status: BillStatus.cancelled, updatedAt: DateTime.now());
  }

  Bill refund() {
    return copyWith(status: BillStatus.refunded, updatedAt: DateTime.now());
  }

  Bill addLineItem(BillLineItem lineItem) {
    final newLineItems = [...lineItems, lineItem];
    final newSubtotal = newLineItems.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
    final newTax = newSubtotal * (taxRate / 100);
    final newDiscount = newSubtotal * (discountRate / 100);
    final newTotal = newSubtotal + newTax - newDiscount;

    return copyWith(
      lineItems: newLineItems,
      subtotal: newSubtotal,
      taxAmount: newTax,
      discountAmount: newDiscount,
      totalAmount: newTotal,
      updatedAt: DateTime.now(),
    );
  }

  Bill removeLineItem(String lineItemId) {
    final newLineItems = lineItems
        .where((item) => item.id != lineItemId)
        .toList();
    final newSubtotal = newLineItems.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
    final newTax = newSubtotal * (taxRate / 100);
    final newDiscount = newSubtotal * (discountRate / 100);
    final newTotal = newSubtotal + newTax - newDiscount;

    return copyWith(
      lineItems: newLineItems,
      subtotal: newSubtotal,
      taxAmount: newTax,
      discountAmount: newDiscount,
      totalAmount: newTotal,
      updatedAt: DateTime.now(),
    );
  }

  Bill updateBillingAddress(BillAddress address) {
    return copyWith(billingAddress: address, updatedAt: DateTime.now());
  }

  Bill applyDiscount(double discountAmount) {
    final newDiscount = discountAmount;
    final newTotal = subtotal + taxAmount - newDiscount;

    return copyWith(
      discountAmount: newDiscount,
      totalAmount: newTotal,
      updatedAt: DateTime.now(),
    );
  }

  Bill updateTax(double taxRate) {
    final newTax = subtotal * (taxRate / 100);
    final newTotal = subtotal + newTax - discountAmount;

    return copyWith(
      taxAmount: newTax,
      totalAmount: newTotal,
      updatedAt: DateTime.now(),
    );
  }

  // Static factory methods
  static Bill createDraft({
    required String billNumber,
    required String userId,
    String? projectId,
    required BillType type,
    String currency = 'USD',
    BillAddress? billingAddress,
    String? notes,
  }) {
    final now = DateTime.now();
    return Bill(
      id: '',
      // Will be set by the backend
      billNumber: billNumber,
      userId: userId,
      projectId: projectId,
      type: type,
      status: BillStatus.draft,
      currency: currency,
      subtotal: 0.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      totalAmount: 0.0,
      lineItems: [],
      billingAddress: billingAddress,
      issueDate: now,
      dueDate: now.add(const Duration(days: 30)),
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
  }
}
