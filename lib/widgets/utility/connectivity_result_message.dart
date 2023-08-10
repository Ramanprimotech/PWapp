import 'package:pwlp/pw_app.dart';

class ConnectivityMessage extends StatelessWidget {
  const ConnectivityMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
          height: 150.0,
          child: Center(
              child: Column(
            children: <Widget>[
              Text(
                Message().internetTitleMsg,
                style: const TextStyle(
                    fontSize: 22.0,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'texgyreadventor-regular',
                    decoration: TextDecoration.none),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              Text(
                Message().internetSubTtleMsg,
                style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black45,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'texgyreadventor-regular',
                    decoration: TextDecoration.none),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
