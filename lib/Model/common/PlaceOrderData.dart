import 'dart:convert';

class PlaceOrderData {
  String? referenceOrderID;
  String? externalRefID;
  String? customerIdentifier;
  String? accountIdentifier;
  String? accountNumber;
  String? utid;
  String? rewardName;
  Sender? sender;
  Sender? recipient;
  String? emailSubject;
  String? message;
  bool? sendEmail;
  String? etid;
  String? status;
  String? campaign;
  String? createdAt;
  String? notes;
  Reward? reward;

  PlaceOrderData(
      {this.referenceOrderID,
        this.externalRefID,
        this.customerIdentifier,
        this.accountIdentifier,
        this.accountNumber,
        this.utid,
        this.rewardName,
        this.sender,
        this.recipient,
        this.emailSubject,
        this.message,
        this.sendEmail,
        this.etid,
        this.status,
        this.campaign,
        this.createdAt,
        this.notes,
        this.reward});

  PlaceOrderData.fromJson(Map<String, dynamic> json) {
    referenceOrderID = json['referenceOrderID'];
    externalRefID = json['externalRefID'];
    customerIdentifier = json['customerIdentifier'];
    accountIdentifier = json['accountIdentifier'];
    accountNumber = json['accountNumber'];
    utid = json['utid'];
    rewardName = json['rewardName'];
    sender =
    json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    recipient = json['recipient'] != null
        ? new Sender.fromJson(json['recipient'])
        : null;
    emailSubject = json['emailSubject'];
    message = json['message'];
    sendEmail = json['sendEmail'];
    etid = json['etid'];
    status = json['status'];
    campaign = json['campaign'];
    createdAt = json['createdAt'];
    notes = json['notes'];
    reward =
    json['reward'] != null ? new Reward.fromJson(json['reward']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['referenceOrderID'] = this.referenceOrderID;
    data['externalRefID'] = this.externalRefID;
    data['customerIdentifier'] = this.customerIdentifier;
    data['accountIdentifier'] = this.accountIdentifier;
    data['accountNumber'] = this.accountNumber;
    data['utid'] = this.utid;
    data['rewardName'] = this.rewardName;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    if (this.recipient != null) {
      data['recipient'] = this.recipient!.toJson();
    }
    data['emailSubject'] = this.emailSubject;
    data['message'] = this.message;
    data['sendEmail'] = this.sendEmail;
    data['etid'] = this.etid;
    data['status'] = this.status;
    data['campaign'] = this.campaign;
    data['createdAt'] = this.createdAt;
    data['notes'] = this.notes;
    if (this.reward != null) {
      data['reward'] = this.reward!.toJson();
    }
    return data;
  }
}


class Sender {
  String? firstName;
  String? lastName;
  String? email;

  Sender({this.firstName, this.lastName, this.email});

  Sender.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    return data;
  }
}

class Reward {
  Credentials? credentials;
  List<CredentialList>? credentialList;
  String? redemptionInstructions;

  Reward({this.credentials, this.credentialList, this.redemptionInstructions});

  Reward.fromJson(Map<String, dynamic> json) {
    credentials = json['credentials'] != null
        ? new Credentials.fromJson(json['credentials'])
        : null;
    if (json['credentialList'] != null) {
      credentialList = <CredentialList>[];
      json['credentialList'].forEach((v) {
        credentialList!.add(new CredentialList.fromJson(v));
      });
    }
    redemptionInstructions = json['redemptionInstructions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.credentials != null) {
      data['credentials'] = this.credentials!.toJson();
    }
    if (this.credentialList != null) {
      data['credentialList'] =
          this.credentialList!.map((v) => v.toJson()).toList();
    }
    data['redemptionInstructions'] = this.redemptionInstructions;
    return data;
  }
}

class Credentials {
  String? redemptionLink;
  String? expiration;

  Credentials({this.redemptionLink, this.expiration});

  Credentials.fromJson(Map<String, dynamic> json) {
    redemptionLink = json['Redemption Link'];
    expiration = json['Expiration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Redemption Link'] = this.redemptionLink;
    data['Expiration'] = this.expiration;
    return data;
  }
}

class CredentialList {
  String? label;
  String? value;
  String? type;
  String? credentialType;

  CredentialList({this.label, this.value, this.type, this.credentialType});

  CredentialList.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    type = json['type'];
    credentialType = json['credentialType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    data['type'] = this.type;
    data['credentialType'] = this.credentialType;
    return data;
  }
}
