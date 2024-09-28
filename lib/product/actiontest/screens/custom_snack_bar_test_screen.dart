// custom_snack_bar_test_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/default/widgets/custom_snack_bar.dart';

class CustomSnackBarTestScreen extends ConsumerStatefulWidget {
  const CustomSnackBarTestScreen({super.key});

  @override
  ConsumerState<CustomSnackBarTestScreen> createState() =>
      _CustomSnackBarTestScreenState();
}

class _CustomSnackBarTestScreenState
    extends ConsumerState<CustomSnackBarTestScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom SnackBar Test'),
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.toys),
            title: Text('Test With Default Values'),
          ),
          ListTile(
            trailing: const Icon(Icons.textsms),
            title: const Text('Show SnackBar'),
            onTap: () {
              showCustomSnackBar(context, '✅ 완료', '값 변경 안내의 정보성 메시지를 주로 담아요');
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: ListTile(
              leading: Icon(Icons.smart_toy),
              title: Text('Test with Custom Input'),
            ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: 'Content'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                ElevatedButton(
                  onPressed: titleController.text.isNotEmpty ||
                          contentController.text.isNotEmpty
                      ? () {
                          titleController.clear();
                          contentController.clear();
                          setState(() {});
                        }
                      : null,
                  child: const Icon(Icons.refresh),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: titleController.text.isNotEmpty &&
                            contentController.text.isNotEmpty
                        ? () {
                            showCustomSnackBar(context, titleController.text,
                                contentController.text);
                          }
                        : null,
                    child: const Text('Show SnackBar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
