import 'package:braintree_payment/braintree_payment.dart';
import 'package:tutor_search_system/models/braintree.dart';
import 'package:tutor_search_system/repositories/braintree_repository.dart';

Future<Braintree> prepareBraintreeCheckOut(double totalAmount) async {
  //get Braintree access client token;
  //the secret key is save in the  back end
  final clientToken = await BraintreeRepository().getBraintreeClientToken();
  //show dialog to input card info
  final braintreePaymentRequest = await BraintreePayment().showDropIn(
    nonce: clientToken,
    amount: totalAmount.toString(),
    nameRequired: false,
    inSandbox: true,
  );
  //
  return Braintree.constructor(
      totalAmount, braintreePaymentRequest['paymentNonce']);
}
