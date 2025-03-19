import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/API_Constant.dart';
import '../../../validators/Message.dart';
import '../../../widgets/AppText.dart';
import '../../../widgets/utility/Utility.dart';
import '../../dashboard/Dashboard.dart';
import '../api_call/api_call.dart';
import '../../../main.dart'; // Import main.dart to access navigatorKey

void showDeleteAccountDialog(BuildContext context) {
  bool isChecked = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const AppText(
                    "Delete account",
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      const Flexible(
                        child: AppText(
                          "Check the box to confirm account deletion!",
                          textAlign: TextAlign.start,
                          fontSize: 18,
                          color: Colors.black,
                          maxLines: 20,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const AppText("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isChecked
                              ? () async {
                                  bool isSuccess = await postUserId(
                                      apiUrl: Api().userDelete,
                                      isAccountDelete: false);

                                  if (isSuccess) {
                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    sharedPreferences.clear();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/Login',
                                            (Route<dynamic> route) => false);
                                    Utility()
                                        .toast(context, Message().userDeleted);
                                  } else {
                                    Utility()
                                        .toast(context, Message().ErrorMsg);
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isChecked ? Colors.purple : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const AppText("Delete"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
