import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImp implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImp(this.box);
  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    box.read(
      () {
        for (var i = 0; i < box.length; i++) {
          blogs.add(BlogModel.fromJson(box.get(i.toString())));
        }
      },
    );
    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    box.clear();
    box.write(
      () {
        for (int i = 0; i < blogs.length; i++) {
          box.put(i.toString(), blogs[i].toJson());
        }
      },
    );
  }
}