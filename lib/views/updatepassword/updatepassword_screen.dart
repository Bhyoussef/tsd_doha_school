import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constant.dart';
import '../../theme/app_colors.dart';
import '../../utils/shared_preferences.dart';
import 'widget/password_field_widget.dart';
import '../../controller/auth_controller/updatepassword_controller.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final PasswordChangeController _passwordChangeController =
      Get.put(PasswordChangeController());

  final _oldpassword = TextEditingController();
  final _newpassword = TextEditingController();
  final _confirmpassword = TextEditingController();

  int uid = 0;

  @override
  void initState() {
    super.initState();
    _fetchUid();
  }

  Future<void> _fetchUid() async {
    final fetchedUid =
        await SharedData.getFromStorage('parent', 'object', 'uid');
    setState(() {
      uid = fetchedUid;
      print(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PasswordFormField(
                  controller: _oldpassword,
                  labelText: 'oldpassword'.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                PasswordFormField(
                  controller: _newpassword,
                  labelText: 'newpassword'.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                PasswordFormField(
                  controller: _confirmpassword,
                  labelText: 'confirmpassword'.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                Center(
                  child: MaterialButton(
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width,
                    color: primarycolor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _passwordChangeController.updatePasswd(
                          uid,
                          _oldpassword.text,
                          _newpassword.text,
                          _confirmpassword.text,
                        );
                      }
                    },
                    child: Text(
                      'update'.tr,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                Obx(() => _passwordChangeController.isLoading.value
                    ? Center(
                        child: CircularProgressBar(
                        color: primarycolor,
                      ))
                    : Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
