import 'package:flutter/material.dart';
import '../../common/const/component/custom_text_form_field.dart';
import '../../common/layout/default_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, //가운데 정렬
        children: const [
          // cmd + shift + k: 키보드 타이핑 올라옴
          CustomTextFormField(
            hintText: '이메일을 입력해주세요.',
            onChanged: (String value) {},
          ),
          CustomTextFormField(
            hintText: '비밀번호를 입력해주세요.',
            onChanged: (String value) {},
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
