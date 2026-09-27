import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/providers/feed_provider.dart';
import '../../../data/repositories/content/post_repository.dart';

class PublishScreen extends ConsumerStatefulWidget {
  final VoidCallback? onPublished;

  const PublishScreen({
    super.key,
    this.onPublished,
  });

  @override
  ConsumerState<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends ConsumerState<PublishScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final PostRepository _repository = PostRepository();

  List<Map<String, dynamic>> _topics = [];

  String? _selectedTopicId;

  String _postType = 'experience';

  bool _loadingTopics = true;
  bool _publishing = false;

  final Map<String, String> _postTypes = const {
    'opinion': '观点',
    'experience': '经历',
    'question': '问题',
    'analysis': '分析',
    'life': '生活分享',
  };

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadTopics() async {
    try {
      final topics = await _repository.fetchTopics();

      if (!mounted) {
        return;
      }

      setState(() {
        _topics = topics;

        if (topics.isNotEmpty) {
          _selectedTopicId = topics.first['id']?.toString();
        }

        _loadingTopics = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadingTopics = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('话题加载失败：$e'),
        ),
      );
    }
  }

  Future<void> _publish() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTopicId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请选择一个话题'),
        ),
      );
      return;
    }

    setState(() {
      _publishing = true;
    });

    try {
      await _repository.createPost(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        postType: _postType,
        topicId: _selectedTopicId!,
      );

      ref.invalidate(feedProvider(0));
      ref.invalidate(feedProvider(1));
      ref.invalidate(feedProvider(2));

      _titleController.clear();
      _contentController.clear();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('发布成功'),
        ),
      );

      widget.onPublished?.call();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('发布失败：$e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _publishing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '发布',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _publishing ? null : _publish,
              child: _publishing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      '发布',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              maxLength: 60,
              decoration: InputDecoration(
                labelText: '标题',
                hintText: '写下你想讨论的问题',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入标题';
                }

                if (value.trim().length < 5) {
                  return '标题至少需要5个字';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              minLines: 8,
              maxLines: 14,
              maxLength: 3000,
              decoration: InputDecoration(
                labelText: '正文',
                hintText: '分享你的观点、经历或者正在面对的问题……',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入正文';
                }

                if (value.trim().length < 10) {
                  return '正文至少需要10个字';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              '内容类型',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _postTypes.entries.map((entry) {
                final selected = _postType == entry.key;

                return ChoiceChip(
                  label: Text(entry.value),
                  selected: selected,
                  onSelected: _publishing
                      ? null
                      : (_) {
                          setState(() {
                            _postType = entry.key;
                          });
                        },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              '选择话题',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (_loadingTopics)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_topics.isEmpty)
              const Text(
                '暂无可用话题',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            else
              DropdownButtonFormField<String>(
                initialValue: _selectedTopicId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: '请选择话题',
                ),
                items: _topics.map((topic) {
                  final id = topic['id']?.toString();
                  final name = topic['name']?.toString() ?? '';

                  return DropdownMenuItem<String>(
                    value: id,
                    child: Text(name),
                  );
                }).toList(),
                onChanged: _publishing
                    ? null
                    : (value) {
                        setState(() {
                          _selectedTopicId = value;
                        });
                      },
              ),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: _publishing ? null : _publish,
                child: _publishing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        '发布帖子',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '发布后内容会出现在首页 Feed 中。',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}