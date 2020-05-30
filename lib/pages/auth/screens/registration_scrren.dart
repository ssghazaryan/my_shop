import 'package:MyShop/pages/auth/providers/auth.dart';
import 'package:MyShop/pages/auth/widgets/outline_buttons.dart';
import 'package:MyShop/pages/auth/widgets/outline_sexbuttons.dart';
import 'package:MyShop/widgets/get_loader.dart';
import 'package:MyShop/widgets/pager.dart';
import 'package:MyShop/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../globals/colors.dart' as col;

class RegitrationScreen extends StatelessWidget {
  static const routeName = '/registration';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Регистрация'),
      ),
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Builder(
              builder: (context) => Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: provider.form,
                      child: ListView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldOutline(
                                  hint: 'Имя',
                                  controller: provider.nameController,
                                  function: (value) {
                                    if (value.isEmpty)
                                      return 'Заполните поле';
                                    else
                                      return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextFieldOutline(
                                  controller: provider.secondNameController,
                                  hint: 'Фамилия',
                                  function: (value) {
                                    if (value.isEmpty)
                                      return 'Заполните поле';
                                    else
                                      return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          TextFieldOutline(
                            controller: provider.emailController,
                            hint: 'Электронный адрес',
                            function: (value) {
                              if (value.isEmpty)
                                return 'Заполните поле';
                              else
                                return null;
                            },
                          ),
                          SizedBox(height: 8),
                          TextFieldOutline(
                            controller: provider.passController,
                            hint: 'Новый пароль',
                            function: (value) {
                              if (value.isEmpty)
                                return 'Заполните поле';
                              else if (value.trim().length < 6)
                                return 'Мин 6 единиц';
                              else
                                return null;
                            },
                          ),
                          SizedBox(height: 8),
                          TextFieldOutline(
                            obscureText: true,
                            controller: provider.pass2Controller,
                            hint: 'Подвердить пароль',
                            function: (value) {
                              if (value.isEmpty)
                                return 'Заполните поле';
                              else if (value.trim().length < 6)
                                return 'Мин 6 единиц';
                              else if (provider.passController.text !=
                                  provider.pass2Controller.text)
                                return 'Пароль не совпадает';
                              else
                                return null;
                            },
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Дата рождения'),
                          ),
                          Row(children: [
                            Expanded(
                              child: OutlineButtonsForRegistr(
                                name: provider.days[provider.day]['name'],
                                function: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (ctx) => PagerForAll(
                                      list: provider.days,
                                      index: provider.day,
                                    ),
                                  ).then((value) {
                                    if (value != null) provider.setDay(value);
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: OutlineButtonsForRegistr(
                                  name: provider.months[provider.month]['name'],
                                  function: () {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (ctx) => PagerForAll(
                                        list: provider.months,
                                        index: provider.month,
                                      ),
                                    ).then((value) {
                                      if (value != null)
                                        provider.setMonth(value);
                                    });
                                  }),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: OutlineButtonsForRegistr(
                                name: provider.years[provider.year]['name'],
                                function: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (ctx) => PagerForAll(
                                      list: provider.years,
                                      index: provider.year,
                                    ),
                                  ).then((value) {
                                    if (value != null) provider.setYear(value);
                                  });
                                },
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
                                function: () => provider.setSex(0),
                                value: provider.sex == 0,
                                name: 'Женщина',
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: OutlineSexButtonsForRegistr(
                                function: () => provider.setSex(1),
                                value: provider.sex == 1,
                                name: 'Мужчина',
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                  if (MediaQuery.of(context).viewInsets.bottom == 0.0)
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CupertinoButton(
                          color: Colors.green,
                          onPressed: () => provider.saveForm(context),
                          child: Text(
                            'Регистрация',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  if (provider.isLoading)
                    PreLoader(
                      color: true,
                      marigin: true,
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
