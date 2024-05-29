import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:kanemaonline/api/payment_api.dart';
import 'package:kanemaonline/data/countries.dart';
import 'package:kanemaonline/helpers/constants/colors.dart';
import 'package:kanemaonline/helpers/fx/url_launcher.dart';
import 'package:kanemaonline/providers/auth_provider.dart';
import 'package:kanemaonline/screens/browser/browser_screen.dart';
import 'package:kanemaonline/screens/generics/choose_country_popup.dart';
import 'package:kanemaonline/widgets/activity_loading_widget.dart';
import 'package:kanemaonline/widgets/bot_toasts.dart';
import 'package:kanemaonline/widgets/checking_payment_popup.dart';
import 'package:kanemaonline/widgets/payment_success_popup.dart';
import 'package:provider/provider.dart';

class PaymentGatewayScreen extends StatefulWidget {
  final int totalPrice;
  final String packageName;
  final int duration;
  final bool isPayPerView;
  const PaymentGatewayScreen({
    super.key,
    required this.totalPrice,
    required this.packageName,
    required this.duration,
    required this.isPayPerView,
  });

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  int mobileMoneyIndex = 0;
  bool isPaymentLoading = false;

  TextEditingController mobilePhoneNumberController = TextEditingController();

  TextEditingController creditCardName = TextEditingController();
  TextEditingController creditCardNumber = TextEditingController();
  TextEditingController creditCardExpiry = TextEditingController();
  TextEditingController creditCardCVV = TextEditingController();

  void payWithMobile() async {
    String phoneNumber = countries
            .where((element) => element['code'] == countryCode)
            .first['dial_code']
            .toString() +
        mobilePhoneNumberController.text.trim();

    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isPaymentLoading = true;
        });
        final response = await PaymentAPI.initiateDirectPayment(
          userId: Provider.of<AuthProvider>(context, listen: false).userid,
          amount: widget.totalPrice.toDouble(),
          packageName: widget.packageName,
          paymentMethod: "PawaPay",
          duration: widget.duration.toDouble(),
          phoneNumber: phoneNumber,
        );
        debugPrint(response.toString());
        if (response["message"]['status'] == "ACCEPTED") {
          showCupertinoModalPopup(
            context: context,
            builder: (context) => CheckingPaymentPopup(
              depositID: response['message']['depositId'],
              packageName: widget.packageName,
              amount: widget.totalPrice.toDouble(),
              onRetry: () => payWithMobile(),
              paymentMethod: "Mobile Money $phoneNumber",
              isPayperView: widget.isPayPerView,
            ),
          );
        } else {
          BotToasts.showToast(
            message: "Failed to process payment. Please try again.",
            isError: true,
          );
        }
        setState(() {
          isPaymentLoading = false;
        });
      } catch (err) {
        BotToasts.showToast(
          message: "Something went wrong, please try again.",
          isError: true,
        );
        debugPrint(err.toString());
        setState(() {
          isPaymentLoading = false;
        });
      }
    } else {
      BotToasts.showToast(
          message: "Please enter a valid phone number", isError: true);
    }
  }

  void payWithPayPal() async {
    try {
      setState(() {
        isPaymentLoading = true;
      });
      final response = await PaymentAPI.initiatePayPalPayment(
          userId: Provider.of<AuthProvider>(context, listen: false).userid,
          amount: widget.totalPrice.toDouble(),
          packageName: widget.packageName,
          paymentMethod: "PawaPay",
          duration: widget.duration.toDouble(),
          phoneNumber: "");
      if (response["status"] == "success") {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CheckingPaymentPopup(
            depositID: response['ref'],
            packageName: widget.packageName,
            amount: widget.totalPrice.toDouble(),
            onRetry: () => payWithPayPal(),
            paymentMethod: "PayPal",
            isPayperView: widget.isPayPerView,
          ),
        );

        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => BrowserScreen(
              url: response['message'],
              title: 'PayPal',
            ),
          ),
        ).then((value) {
          PaymentAPI.notifyBackened(ref: response['ref'], status: "CLOSED");
        });
      } else {
        BotToasts.showToast(
          message: "Failed to process payment. Please try again.",
          isError: true,
        );
      }
      setState(() {
        isPaymentLoading = false;
      });
    } catch (err) {
      BotToasts.showToast(
        message: "Something went wrong, please try again.",
        isError: true,
      );
      debugPrint(err.toString());
      setState(() {
        isPaymentLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Gateway"),
      ),
      body: isPaymentLoading
          ? const CustomIndicatorWidget()
          : Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Image.asset(
                      "assets/images/logo-white.png",
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Choose your payment method",
                  style: TextStyle(
                    color: white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _buildTabBar(),
                _buildProcessorSelector(),
              ],
            ),
    );
  }

  var selectedIndexTab = 0;
  _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tabBarButton(
              title: "Mobile Money",
              isActive: selectedIndexTab == 0,
              onTap: () {
                setState(() {
                  selectedIndexTab = 0;
                });
              }),
          _tabBarButton(
              title: "Paypal",
              isActive: selectedIndexTab == 1,
              onTap: () {
                setState(() {
                  selectedIndexTab = 1;
                });
              }),
          _tabBarButton(
              title: "Card",
              isActive: selectedIndexTab == 2,
              onTap: () {
                setState(() {
                  selectedIndexTab = 2;
                });
              }),
        ],
      ),
    );
  }

  _tabBarButton({
    required String title,
    required bool isActive,
    required Function onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            color: darkerAccent,
            borderRadius: BorderRadius.circular(5),
            border: isActive ? Border.all(color: darkAccent, width: 1.6) : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildProcessorSelector() {
    switch (selectedIndexTab) {
      case 0:
        return _buildMobileMoney();
      case 1:
        return _buildPayPal();
      case 2:
        return _buildCreditCard();
      default:
        return _buildMobileMoney();
    }
  }

  _buildMobileMoney() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          _buildTileContainer(
            onTap: () {
              mobileMoneyIndex = 0;
              setState(() {});
            },
            image: "assets/svg/mpamba.svg",
            name: "TNM Mpamba",
            description: "Pay using TNM Mpamba",
            isSelected: mobileMoneyIndex == 0,
            isSvg: true,
          ),
          _buildTileContainer(
            onTap: () {
              mobileMoneyIndex = 1;
              setState(() {});
            },
            image: "assets/images/airtel-money.png",
            name: "Airtel Money",
            description: "Pay using Airtel Money",
            isSelected: mobileMoneyIndex == 1,
          ),
          _buildFormFields()
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  String countryCode = "MW";

  Widget _buildFormFields() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: darkAccent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: mobilePhoneNumberController,
                style: TextStyle(
                  color: lightGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }

                  final phone = value.trim();
                  if (phone.startsWith('0')) {
                    return 'Phone number should not start with a 0';
                  }
                  if (phone.length < 9) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText:
                      mobileMoneyIndex == 0 ? "888 000 000" : "999 000 000",
                  hintStyle: TextStyle(
                    color: darkAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  prefixIcon: GestureDetector(
                    onTap: () async {
                      var code = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChooseCountryPopup(),
                        ),
                      );

                      if (code != null) {
                        setState(() {
                          countryCode = code;
                        });
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Center(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              countries
                                  .where((element) =>
                                      element['code'] == countryCode)
                                  .first['dial_code']
                                  .toString(),
                              style: TextStyle(
                                color: lightGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_down,
                              color: lightGrey,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: white),
                  ),
                  errorStyle: TextStyle(
                    color: red,
                    fontSize: 15,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    return GestureDetector(
      onTap: () => payWithMobile(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Pay ${NumberFormat.currency(symbol: "MWK ", locale: "en", decimalDigits: 0).format(widget.totalPrice)}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  _buildTileContainer({
    required Function onTap,
    required String name,
    required String description,
    required bool isSelected,
    required String image,
    bool? isSvg,
  }) {
    return Bounceable(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF242424),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: darkGrey.withOpacity(0.4),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.13,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: isSvg != null && isSvg == true
                    ? SvgPicture.asset(image)
                    : Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(image),
                          ),
                        ),
                      ),
              ),
            ),
            Column(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    color: lightGrey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: isSelected ? white : transparent,
                border: Border.all(
                  color: isSelected ? white : darkGrey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: isSelected
                  ? Center(
                      child: Icon(
                        Icons.check,
                        size: 12,
                        color: black,
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

// #PAYPAL

  Widget _buildPayPal() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Image.asset("assets/images/paypal.png"),
          ),
          const SizedBox(height: 20),
          _buildPayPalButton(),
        ],
      ),
    );
  }

  Widget _buildPayPalButton() {
    return GestureDetector(
      onTap: () => payWithPayPal(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Pay ${NumberFormat.currency(symbol: "MWK ", locale: "en", decimalDigits: 0).format(widget.totalPrice)}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Credit Card

  Widget _buildCreditCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: darkerAccent,
        border: Border.all(color: darkAccent, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Card Information",
            style: TextStyle(
              color: white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: creditCardName,
            style: TextStyle(
              color: lightGrey,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            decoration: inputDecoration().copyWith(
              hintText: 'CARD HOLDER NAME',
              hintStyle: TextStyle(
                color: white.withOpacity(.3),
              ),
              errorStyle: const TextStyle(
                color: Colors.red,
              ),
            ),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: creditCardNumber,
            style: TextStyle(
              color: lightGrey,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            decoration: inputDecoration().copyWith(
              hintText: 'CARD NUMBER',
              hintStyle: TextStyle(
                color: white.withOpacity(.3),
              ),
              errorStyle: const TextStyle(
                color: Colors.red,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              CreditCardNumberInputFormatter(
                useSeparators: true,
                onCardSystemSelected: (CardSystemData? cardSystemData) {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: TextFormField(
                controller: creditCardExpiry,
                style: TextStyle(
                  color: lightGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                decoration: inputDecoration().copyWith(
                  hintText: '00/00',
                  hintStyle: TextStyle(
                    color: white.withOpacity(.3),
                  ),
                  errorStyle: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CreditCardExpirationDateFormatter(),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: creditCardCVV,
                style: TextStyle(
                  color: lightGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                decoration: inputDecoration().copyWith(
                  hintText: 'CVV',
                  hintStyle: TextStyle(
                    color: white.withOpacity(.3),
                  ),
                  errorStyle: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CreditCardCvcInputFormatter(
                    isAmericanExpress: true,
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 15),
          _buildCreditCardButton(),
        ],
      ),
    );
  }

  _buildCreditCardButton() {
    return GestureDetector(
      onTap: () async {
        try {
          setState(() {
            isPaymentLoading = true;
          });
          final response = await PaymentAPI.initiateCardPayment(
              userId: Provider.of<AuthProvider>(context, listen: false).userid,
              amount: widget.totalPrice.toDouble(),
              packageName: widget.packageName,
              paymentMethod: "",
              duration: widget.duration.toDouble(),
              phoneNumber: "",
              creditCardNumber:
                  creditCardNumber.text.trim().replaceAll(" ", ""),
              creditCardExpiry:
                  creditCardExpiry.text.trim().replaceAll("/", ""),
              creditCardCVV: creditCardCVV.text.trim(),
              cardHolderName: creditCardName.text.trim());
          if (response["status"] == "success") {
            showCupertinoModalPopup(
              context: context,
              barrierDismissible: false,
              builder: (context) => PaymentSuccessPopup(
                packageName: widget.packageName,
                depositID: response["ref"],
                paymentMethod:
                    "Credit/Debit Card **${creditCardNumber.text.substring(creditCardNumber.text.length - 4)}",
                amount: widget.totalPrice.toDouble(),
                isPayPerView: widget.isPayPerView,
              ),
            );
          } else {
            BotToasts.showToast(
              message: "Failed to process payment. Please try again.",
              isError: true,
            );
          }
          setState(() {
            isPaymentLoading = false;
          });
        } catch (err) {
          BotToasts.showToast(
            message: "Something went wrong, please try again.",
            isError: true,
          );
          debugPrint(err.toString());
          setState(() {
            isPaymentLoading = false;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Pay ${NumberFormat.currency(symbol: "MWK ", locale: "en", decimalDigits: 0).format(widget.totalPrice)}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      hintStyle: TextStyle(
        color: darkAccent,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: white),
      ),
      errorStyle: TextStyle(
        color: red,
        fontSize: 15,
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
    );
  }
}
