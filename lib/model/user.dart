class User {
  final String name;
  final int age;

  User({required this.name, required this.age});

  // Convert User to JSON for storage
  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
  };

  // Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'] as String,
    age: json['age'] as int,
  );
}