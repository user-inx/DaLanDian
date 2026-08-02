class PostModel {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final int likes;
  final int comments;
  final int favorites;

  const PostModel({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.favorites,
  });
}

/// 首页模拟数据
const List<PostModel> demoPosts = [
  PostModel(
    id: '1',
    title: '男士商务穿搭推荐',
    author: 'Alex',
    imageUrl: '',
    likes: 128,
    comments: 18,
    favorites: 36,
  ),
  PostModel(
    id: '2',
    title: '机械键盘选购指南',
    author: 'Kevin',
    imageUrl: '',
    likes: 356,
    comments: 42,
    favorites: 89,
  ),
  PostModel(
    id: '3',
    title: '高效办公桌面分享',
    author: 'David',
    imageUrl: '',
    likes: 268,
    comments: 31,
    favorites: 57,
  ),
  PostModel(
    id: '4',
    title: '健身入门训练计划',
    author: 'Tom',
    imageUrl: '',
    likes: 512,
    comments: 76,
    favorites: 121,
  ),
  PostModel(
    id: '5',
    title: '户外露营装备清单',
    author: 'Jack',
    imageUrl: '',
    likes: 219,
    comments: 24,
    favorites: 48,
  ),
  PostModel(
    id: '6',
    title: '每日阅读推荐',
    author: 'Leo',
    imageUrl: '',
    likes: 175,
    comments: 15,
    favorites: 29,
  ),
];