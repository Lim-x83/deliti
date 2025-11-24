class UserProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? profilePicture;
  final DateTime joinedDate;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePicture,
    required this.joinedDate,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      profilePicture: json['profile_picture'],
      joinedDate: DateTime.parse(json['created_at']),
    );
  }

  String get displayName => name;
  
  String get initials => name.isNotEmpty 
      ? name.split(' ').map((n) => n[0]).take(2).join().toUpperCase()
      : 'U';

  // For profile picture display
  String get profileImageUrl {
    if (profilePicture != null && profilePicture!.isNotEmpty) {
      return 'http://127.0.0.1/deliti/api/uploads/$profilePicture';
    }
    return ''; // Will use default avatar
  }
}