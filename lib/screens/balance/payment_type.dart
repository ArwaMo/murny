import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:murny_final_project/bloc/user_bloc/user_cubit.dart';
import 'package:murny_final_project/method/alert_snackbar.dart';
import 'package:murny_final_project/method/show_loading.dart';
import 'package:murny_final_project/screens/balance/payment_radio_button.dart';
import 'package:murny_final_project/screens/google_maps/google_maps_screen.dart';
import 'package:murny_final_project/widgets/primary_button.dart';

class PaymentTypeScreen extends StatefulWidget {
  const PaymentTypeScreen(
      {super.key,
      required this.driverID,
      required this.currentLocation,
      required this.destination,
      required this.cartID});

  @override
  State<PaymentTypeScreen> createState() => _PaymentTypeScreenState();

  final String driverID, currentLocation, destination;
  final int cartID;
}

enum Payment { visa, wallet, applePay, cash }

class _PaymentTypeScreenState extends State<PaymentTypeScreen> {
  Payment selectedValue = Payment.cash;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width / 20,
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              const Align(
                alignment: Alignment.topRight,
                child: Text(
                  "الدفع",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              const Align(
                alignment: Alignment.topRight,
                child: Text(
                  "اختر طريقة الدفع المناسبة لك",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 42,
              ),
              PaymentRadioButton(
                value: Payment.visa,
                selectedValue: selectedValue,
                onChange: (value) {
                  setState(() {});
                  selectedValue = value!;
                },
                paymentMethod: "البطاقة الإئتمانية",
                imagePath: "assets/images/visa_icon.png",
              ),
              PaymentRadioButton(
                value: Payment.wallet,
                selectedValue: selectedValue,
                onChange: (value) {
                  setState(() {});
                  selectedValue = value!;
                },
                paymentMethod: "المحفظة",
                imagePath: "assets/images/wallet_icon.png",
              ),
              PaymentRadioButton(
                value: Payment.cash,
                selectedValue: selectedValue,
                onChange: (value) {
                  setState(() {});
                  selectedValue = value!;
                },
                paymentMethod: "نقداً",
                imagePath: "assets/images/cash_icon.png",
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 22,
              ),
              BlocConsumer<UserCubit, UserState>(
                listener: (context, state) {
                  if (state is UserLoadingOrderState) {
                    showLoadingDialog(context: context);
                  }
                  if (state is UserSuccessOrderState) {
                    Navigator.pop(context);
                    showSuccessSnackBar(context, "Order has been places successfully");
                    Navigator.pop(context);
                  }
                  if (state is UserErrorOrderState) {
                    showLoadingDialog(context: context);
                    showErrorSnackBar(context, state.errMsg);
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    title: "تأكيد الطلب",
                    onPressed: () {
                      context.read<UserCubit>().userPostOrder(
                          driverId: widget.driverID,
                          locationFrom: widget.currentLocation,
                          locationTo: widget.destination,
                          cartId: widget.cartID,
                          paymentMethod: selectedValue.name);
                    },
                    isText: true,
                    isPadding: false,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
