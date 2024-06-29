
class Profile {
  String name;
  String email;
  String photoUrl;

  Profile({
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}

