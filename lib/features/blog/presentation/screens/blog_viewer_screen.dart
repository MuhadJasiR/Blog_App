import 'package:blog_app/core/theme/app_palete.dart';
import 'package:blog_app/core/utils/calculate_reading_rime.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerScreen extends StatelessWidget {
  final Blog blog;
  static route(Blog blog) => MaterialPageRoute(
        builder: (context) => BlogViewerScreen(
          blog: blog,
        ),
      );
  const BlogViewerScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "By ${blog.posterName}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${formatDateTime(blog.updatedAt)} || ${calculateReadingTime(blog.content)} min",
                  style: const TextStyle(
                    color: AppPalette.greyColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  blog.content,
                  style: const TextStyle(height: 2),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
