import 'package:flutter/cupertino.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            CupertinoIcons.wifi_slash,
            size: 48,
            color: CupertinoColors.systemGrey,
          ),
          SizedBox(height: 16),
          Text(
            'No Internet Connection',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
} 