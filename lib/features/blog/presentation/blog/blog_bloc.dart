import 'dart:developer';
import 'dart:io';

import 'package:blog_app/core/usecase/use_case.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecase/uplaod_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
      : _getAllBlogs = getAllBlogs,
        _uploadBlog = uploadBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUploadEvent>(_onBlogUpload);
    on<BlogFetchAllBLogs>(_onFetchAllBlogs);
  }
  void _onBlogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final result = await _uploadBlog(UploadBlogParams(
      posterId: event.posterId,
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
    ));

    result.fold(
      (l) {
        log(l.message, name: "Upload blog");
        emit(BlogFailure(l.message));
      },
      (r) {
        log(r.content, name: "Upload blog");
        emit(BlogUploadSuccess());
      },
    );
  }

  void _onFetchAllBlogs(
      BlogFetchAllBLogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogDisplaySuccess(r)),
    );
  }
}
