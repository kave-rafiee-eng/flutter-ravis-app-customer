class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? info;
  final String? agentMemory;

  const UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.info,
    this.agentMemory,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString(),
      info: json['info']?.toString(),
      agentMemory: json['agentMemory']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'info': info,
    'agentMemory': agentMemory,
  };
}
