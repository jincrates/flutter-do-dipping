import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    //외부에서 받아서 처리할 value(변하는 값)
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.autofocus = false,
    required this.onChanged,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      // 비밀번호 입력할 때
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onChanged,
      //공통적으로 스타일링하는 값(변하지 않는 값)
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20), // padding 설정
          hintText: hintText,
          errorText: errorText,
          hintStyle: const TextStyle(
            color: BODY_TEXT_COLOR,
            fontSize: 14.0,
          ),
        fillColor: INPUT_BG_COLOR,
        // false - 배경색 없음, true - 배경색 있음
        filled: true,
        // 모든 Input 상태의 기본 스타일 셋팅
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder:  baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }
}
