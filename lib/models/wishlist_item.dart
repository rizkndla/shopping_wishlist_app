class WishlistItem {
  int? id;
  String name;
  double price;
  String category;
  String priority; // 'high', 'medium', 'low'
  String? productUrl;
  bool isBought;
  DateTime createdAt;

  WishlistItem({
    this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.priority,
    this.productUrl,
    this.isBought = false,
    required this.createdAt,
  });

  // Convert dari JSON ke WishlistItem
  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      name: json['name'] ?? '',
      price: json['price'] != null
          ? double.parse(json['price'].toString())
          : 0.0,
      category: json['category'] ?? 'Other',
      priority: json['priority'] ?? 'medium',
      productUrl: json['product_url'],
      isBought: json['is_bought'] != null
          ? (json['is_bought'] == 1 || json['is_bought'] == true)
          : false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  // Convert WishlistItem ke JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      'category': category,
      'priority': priority,
      if (productUrl != null) 'product_url': productUrl,
      'is_bought': isBought ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Untuk debugging
  @override
  String toString() {
    return 'WishlistItem{id: $id, name: $name, price: $price, category: $category, priority: $priority, isBought: $isBought}';
  }

  // Copy dengan perubahan
  WishlistItem copyWith({
    int? id,
    String? name,
    double? price,
    String? category,
    String? priority,
    String? productUrl,
    bool? isBought,
    DateTime? createdAt,
  }) {
    return WishlistItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      productUrl: productUrl ?? this.productUrl,
      isBought: isBought ?? this.isBought,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Priority color
  String get priorityColor {
    switch (priority) {
      case 'high':
        return '#FF5252'; // Red
      case 'medium':
        return '#FFB74D'; // Orange
      case 'low':
        return '#4CAF50'; // Green
      default:
        return '#757575'; // Grey
    }
  }

  // Priority icon
  String get priorityIcon {
    switch (priority) {
      case 'high':
        return '⭐';
      case 'medium':
        return '🔶';
      case 'low':
        return '🔷';
      default:
        return '⚪';
    }
  }

  // Format price ke Rupiah
  String get formattedPrice {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // Cek apakah item expired (lebih dari 30 hari)
  bool get isExpired {
    return createdAt.isBefore(DateTime.now().subtract(Duration(days: 30)));
  }
}
