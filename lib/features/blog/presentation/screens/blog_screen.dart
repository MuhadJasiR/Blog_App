import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_palete.dart';
import 'package:blog_app/core/utils/show_snakbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/presentation/blog/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/screens/add_new_blog_screen.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => BlogScreen(),
      );
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBLogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog App"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, AddNewBlogScreen.route());
              },
              icon: Icon(CupertinoIcons.add_circled))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color: index % 3 == 1
                      ? AppPalette.gradient1
                      : index % 3 == 1
                          ? AppPalette.gradient2
                          : AppPalette.gradient3,
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
