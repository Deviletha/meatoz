import 'package:flutter/material.dart';

import '../../../Components/text_widget.dart';
import '../../../theme/colors.dart';
import '../../accounts/subscription_plans.dart';

class MeatozPlan extends StatefulWidget {
  const MeatozPlan({Key? key}) : super(key: key);

  @override
  State<MeatozPlan> createState() => _MeatozPlanState();
}

class _MeatozPlanState extends State<MeatozPlan> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return Subscription();
        }),
      ),
      child: Container(
        height: 85,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(ColorT.subscriptionCard1),
                  Color(ColorT.subscriptionCard),
                  Color(ColorT.subscriptionCard),
                ])),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/logo_short.png",
                height: 50,
                alignment: Alignment.centerLeft,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Meatoz Subscription Plan",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Subscription plan details",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextConst(
                    text: "Know More",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
