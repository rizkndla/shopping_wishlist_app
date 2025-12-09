class Category {
  int id;
  String name;
  String icon;
  String color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.color = '#4285F4',
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      icon: json['icon'] ?? '📦',
      color: json['color'] ?? '#4285F4',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  static List<Category> defaultCategories = [
    Category(id: 1, name: 'Electronics', icon: '📱', color: '#4285F4'),
    Category(id: 2, name: 'Fashion', icon: '👕', color: '#EA4335'),
    Category(id: 3, name: 'Books', icon: '📚', color: '#FBBC05'),
    Category(id: 4, name: 'Food', icon: '🍔', color: '#34A853'),
    Category(id: 5, name: 'Hobbies', icon: '🎨', color: '#9C27B0'),
    Category(id: 6, name: 'Home', icon: '🏠', color: '#FF9800'),
    Category(id: 7, name: 'Other', icon: '📦', color: '#9E9E9E'),
  ];
}