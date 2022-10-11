
import 'package:cloud_firestore/cloud_firestore.dart';

class  Referral{
   String id;
   int elligible;
   String accountName;
   String accountNumber;
   String bank;
   String code;
   String snippet;
   String phone;
   int balance;

  Referral({
   required this.id,
   required this.elligible,
   required this.accountName,
   required this.accountNumber,
   required this.bank,
   required this.code,
   required this.snippet,
   required this.balance,
  required  this.phone
  });

  
 factory Referral.fromDocument(DocumentSnapshot doc) {
    return Referral(
      id: doc.id,
      elligible: doc.get('elligible') ?? "",
      accountName: doc.get('accountName') ?? "",
      accountNumber: doc.get('accountNumber') ?? "",
      phone: doc.get('phone') ?? "",
      bank: doc.get('bank') ?? "",
      balance: doc.get('balance') ?? "",
      code: doc.get('code') ?? "",
      snippet: doc.get('snippet') ?? ""
    );
}
}









