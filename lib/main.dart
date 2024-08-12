import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/data/repositories/todos_repository.dart';

import 'core/app/app.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/users_repository.dart';
import 'data/services/firebase_auth_service.dart';
import 'data/services/firebase_user_service.dart';
import 'firebase_options.dart';
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/todo/todos_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firebaseAuthService = FirebaseAuthService();
  final firebaseUserService = FirebaseUserService();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            firebaseAuthService: firebaseAuthService,
          ),
        ),
        RepositoryProvider(
          create: (context) => UsersRepository(
            firebaseUserService: firebaseUserService,
          ),
        ),
        RepositoryProvider(
          create: (context) => TodosRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => AuthBloc(
              ctx.read<AuthRepository>(),
              ctx.read<UsersRepository>(),
            )..add(InitialAuthEvent()),
          ),
          BlocProvider(
            create: (ctx) => TodosBloc(
              todosRepository: TodosRepository(),
            )..add(LoadTodos()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
