import '../../pw_app.dart';

class RedeemSuccessful extends StatefulWidget {
  const RedeemSuccessful({Key? key}) : super(key: key);

  @override
  State<RedeemSuccessful> createState() => _RedeemSuccessfulState();
}

class _RedeemSuccessfulState extends State<RedeemSuccessful> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: BGImageWithChild(
        imgUrl: "dashboard-bg.png",
        child: Container(
          height: size.height,
          width: size.width,
          padding: const EdgeInsets.all(20),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const Icon(
                  Icons.monetization_on,
                  color: Colors.white,
                  size: 100,
                ),

                const SizedBox(height: 30,),

                PosterCard(
                  title: "Redeemed Successfully",
                  subTitle: "Thank you. Your redemption request has been submitted. Please allow us 1-3 weeks to process your gift card",
                  onTap: () {
                  },
                  imageAsset: "Assets/redeem.png",
                ),

                const SizedBox(height: 30,),

                CustomBtn(
                    btnLable: "Done",
                    onPressed: (){
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Dashboard()),
                          (route) => false
                      );
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
