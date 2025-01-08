import 'package:cocoa_monitor/view/global_components/custom_button.dart';
import 'package:cocoa_monitor/view/reset_password/reset_password_controller.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../global_components/text_input_decoration.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResetPasswordController resetPasswordController =
        Get.put(ResetPasswordController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            child: Container(color: Colors.transparent),
            preferredSize: Size.fromHeight(0)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New password"),
            TextFormField(
              controller: resetPasswordController.newPasswordTextController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                enabledBorder: inputBorder,
                focusedBorder: inputBorderFocused,
                errorBorder: inputBorder,
                focusedErrorBorder: inputBorderFocused,
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter new password',
                hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              keyboardType: TextInputType.phone,
              validator: (String? value) =>
                  value!.trim().isEmpty ? "password is required" : null,
            ),
            SizedBox(
              height: 10,
            ),
            Text("Confirm new password"),
            TextFormField(
              controller: resetPasswordController.confirmPasswordTextController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                enabledBorder: inputBorder,
                focusedBorder: inputBorderFocused,
                errorBorder: inputBorder,
                focusedErrorBorder: inputBorderFocused,
                filled: true,
                fillColor: Colors.white,
                hintText: 'Confirm new password',
                hintStyle: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              keyboardType: TextInputType.phone,
              validator: (String? value) => value!.trim().isEmpty
                  ? "password confirmation is required"
                  : null,
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              isFullWidth: true,
              horizontalPadding: 10,
              backgroundColor: AppColor.black,
              onTap: ()=> resetPasswordController.resetPassword(),
              child: Text("Reset"),
            )
          ],
        ),
      ),
    );
  }
}
