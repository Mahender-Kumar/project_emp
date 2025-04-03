import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_emp/blocs/auth/auth_bloc.dart';
import 'package:project_emp/blocs/employee/add_employee_event.dart';
import 'package:project_emp/blocs/employee/edit_employee_bloc.dart';
import 'package:project_emp/blocs/theme/theme_bloc.dart';
import 'package:project_emp/blocs/theme/theme_event.dart';
import 'package:project_emp/blocs/employee/add_employee_bloc.dart';
import 'package:project_emp/core/configs/size_config.dart';
import 'package:project_emp/core/router/app_router.dart';
import 'package:project_emp/firebase_options.dart';
import 'package:project_emp/presentation/services/auth_service.dart';
import 'package:project_emp/presentation/services/firestore_service.dart';
import 'package:project_emp/blocs/employee/fetch_emploee_bloc.dart';
import 'package:project_emp/presentation/widgets/role_sheet.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddEmployeeBloc(FirestoreService())),
        BlocProvider(create: (context) => EditEmployeeBloc(FirestoreService())),
        BlocProvider(create: (_) => ThemeBloc()..add(SetInitialTheme())),
        BlocProvider(create: (context) => AuthBloc(AuthService())),
        BlocProvider(create: (_) => FetchEmployeeBloc()..add(LoadEmployees())),
        BlocProvider(create: (context) => JobCubit()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return OrientationBuilder(
                builder: (context, orientation) {
                  SizeConfig().init(constraints, orientation);

                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData.light(),
                    darkTheme: ThemeData.dark(),
                    themeMode: state,
                    routerConfig: AppRouter.instance.router,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
