import 'package:flutter/material.dart';

class ConfirmPopup extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmPopup({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height * 0.4; // Giới hạn chiều cao

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight), // Chặn overflow
            child: Column(
              mainAxisSize: MainAxisSize.min, // Chỉ chiếm không gian cần thiết
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Đưa icon và title ra 2 bên
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 10),
                Text('or'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onCancel();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue),
                  ),
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
