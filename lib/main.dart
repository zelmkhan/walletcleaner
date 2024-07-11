import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lamb_csb/bl/cubit.dart';
import 'package:lamb_csb/bl/states.dart';
import 'package:lamb_csb/screen/home_screen.dart';
import 'package:oktoast/oktoast.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white
    ),
    home: BlocProvider<BlCubit>(
      create: (context) => BlCubit(InitialState()),
      child: const OKToast(child: HomeScreen()),
    ),
  )
);