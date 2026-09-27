class Profile {
  const Profile({
    required this.id,
    required this.nickname,
    this.avatarUrl,
  });

  final String id;
  final String nickname;
  final String? avatarUrl;

  factory Profile.fromMap(Map<String, dynamic> map) {
    final rawNickname = map['nickname'];
    final nickname = (rawNickname is String && rawNickname.trim().isNotEmpty)
        ? rawNickname.trim()
        : '用户';

    return Profile(
      id: map['id'] as String? ?? '',
      nickname: nickname,
      avatarUrl: map['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'avatar_url': avatarUrl,
    };
  }
}