import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_palete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snakbar.dart';

import 'package:blog_app/features/blog/presentation/blog/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/screens/blog_screen.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogScreen(),
      );
  const AddNewBlogScreen({super.key});

  @override
  State<AddNewBlogScreen> createState() => _AddNewBlogScreenState();
}

class _AddNewBlogScreenState extends State<AddNewBlogScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> selectedTopics = [];
  final formKey = GlobalKey<FormState>();
  File? image;

  selectImage() async {
    final selectedImage = await pickImage();
    if (selectedImage != null) {
      setState(() {
        image = selectedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(BlogUploadEvent(
          posterId: posterId,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          image: image!,
          topics: selectedTopics));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: uploadBlog, icon: const Icon(CupertinoIcons.checkmark))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            print('Current State: $state');
            if (state is BlogFailure) {
              showSnackBar(context, state.error);
            } else if (state is BlogUploadSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                BlogScreen.route(),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Loader();
            }
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          )
                        : GestureDetector(
                            onTap: () => selectImage(),
                            child: DottedBorder(
                                radius: const Radius.circular(10),
                                borderType: BorderType.RRect,
                                color: AppPalette.borderColor,
                                strokeCap: StrokeCap.round,
                                dashPattern: const [10, 4],
                                child: const SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text("Select your image")
                                    ],
                                  ),
                                )),
                          ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: [
                        "Technology",
                        "Business",
                        "Programming",
                        "Entertainment"
                      ]
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedTopics.contains(e)) {
                                        selectedTopics.remove(e);
                                      } else {
                                        selectedTopics.add(e);
                                      }
                                      setState(() {});
                                    },
                                    child: Chip(
                                        label: Text(e),
                                        color: selectedTopics.contains(e)
                                            ? const WidgetStatePropertyAll(
                                                AppPalette.gradient1)
                                            : null,
                                        side: const BorderSide(
                                            color: AppPalette.borderColor)),
                                  ),
                                ),
                              )
                              .toList()),
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                        controller: titleController, hintText: "Blog Title"),
                    const SizedBox(height: 10),
                    BlogEditor(
                        controller: contentController,
                        hintText: "Blog Content"),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
