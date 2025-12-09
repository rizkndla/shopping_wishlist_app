class User {
  int? id;
  String username;
  String email;
  double monthlyBudget;
  String? token; // Untuk authentication nanti
  DateTime? createdAt;

  User({
    this.id,
    required this.username,
    required this.email,
    this.monthlyBudget = 0.0,
    this.token,
    this.createdAt,
  });

  // Convert dari JSON ke User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      monthlyBudget: json['monthly_budget'] != null
          ? double.parse(json['monthly_budget'].toString())
          : 0.0,
      token: json['token'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  // Convert User ke JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'email': email,
      'monthly_budget': monthlyBudget,
      if (token != null) 'token': token,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  // Untuk debugging
  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, monthlyBudget: $monthlyBudget}';
  }

  // Copy dengan perubahan
  User copyWith({
    int? id,
    String? username,
    String? email,
    double? monthlyBudget,
    String? token,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Format budget ke Rupiah
  String get formattedBudget {
    return 'Rp ${monthlyBudget.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // Cek apakah user valid (ada username & email)
  bool get isValid {
    return username.isNotEmpty && email.isNotEmpty;
  }

  // Cek apakah user adalah guest/anonymous
  bool get isGuest {
    return id == null;
  }

  // User avatar initial
  String get avatarInitial {
    if (username.isNotEmpty) {
      return username[0].toUpperCase();
    }
    return 'U';
  }

  // Email domain
  String get emailDomain {
    if (email.contains('@')) {
      return email.split('@')[1];
    }
    return '';
  }

  // Budget status (berdasarkan pengeluaran)
  String budgetStatus(double totalSpent) {
    if (monthlyBudget == 0) return 'No budget set';

    double percentage = (totalSpent / monthlyBudget) * 100;

    if (percentage < 50) {
      return 'Under budget';
    } else if (percentage < 80) {
      return 'Moderate';
    } else if (percentage < 100) {
      return 'Almost full';
    } else {
      return 'Over budget';
    }
  }
}
