part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supaBaseUrl,
    anonKey: AppSecrets.supaBaseAnonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => Hive.box(name: "blogs"));
  serviceLocator.registerFactory(() => InternetConnection());

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImp(serviceLocator()),
  );
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImp(
      serviceLocator(),
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<UserSignUp>(
    () => UserSignUp(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<UserLogin>(
    () => UserLogin(serviceLocator()),
  );

  serviceLocator.registerFactory<CurrentUser>(
    () => CurrentUser(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<AuthBloc>(() => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator()));
}

void _initBlog() {
  //Data source
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImp(serviceLocator()),
    )
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImp(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    //Use case
    ..registerFactory(
      () => UploadBlog(serviceLocator()),
    )
    ..registerFactory(
      () => GetAllBlogs(serviceLocator()),
    )
    //Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
