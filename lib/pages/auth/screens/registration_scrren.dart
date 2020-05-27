import 'package:MyShop/pages/auth/providers/registration_provider.dart';
import 'package:MyShop/pages/auth/widgets/outline_buttons.dart';
import 'package:MyShop/pages/auth/widgets/outline_sexbuttons.dart';
import 'package:MyShop/pages/auth/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../globals/colors.dart' as col;

class RegitrationScreen extends StatelessWidget {
  static const routeName = '/registration';

  @override
  Widget build(BuildContext context) {
    final proivder = Provider.of<RegistrationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Регистрация'),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldForRegistration(
                          hint: 'Имя',
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextFieldForRegistration(
                          hint: 'Фамилия',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  TextFieldForRegistration(
                    hint: 'Электронный адрес',
                  ),
                  SizedBox(height: 8),
                  TextFieldForRegistration(
                    hint: 'Новый пароль',
                  ),
                  SizedBox(height: 8),
                  TextFieldForRegistration(
                    hint: 'Подвердить пароль',
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Дата рождения'),
                  ),
                  Row(children: [
                    Expanded(
                      child: OutlineButtonsForRegistr(
                        function: () {},
                        name: 'День',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlineButtonsForRegistr(
                        function: () {},
                        name: 'Месяц',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlineButtonsForRegistr(
                        function: () {},
                        name: 'Год',
                      ),
                    ),
                  ]),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Пол'),
                  ),
                  Row(children: [
                    Expanded(
                      child: OutlineSexButtonsForRegistr(
                        function: () {},
                        name: 'Женщина',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlineSexButtonsForRegistr(
                        function: () {},
                        name: 'Мужчина',
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            if (MediaQuery.of(context).viewInsets.bottom == 0.0)
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CupertinoButton(
                    color: Colors.green,
                    onPressed: () {},
                    child: Text(
                      'Регистрация',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
