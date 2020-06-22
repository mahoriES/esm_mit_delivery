class SupportRequest {
  String ticketTemplate;
  String supportForEntityID;
  String raisedBy;
  String raisedByEntityID;
  String raisedByEntityEmail;
  String raisedByEntityPhone;
  List<SupportAttachments> supportAttachments;
  String supportComment;

  SupportRequest(
      {this.ticketTemplate,
      this.supportForEntityID,
      this.raisedBy,
      this.raisedByEntityID,
      this.raisedByEntityEmail,
      this.raisedByEntityPhone,
      this.supportAttachments,
      this.supportComment});

  SupportRequest.fromJson(Map<String, dynamic> json) {
    ticketTemplate = json['ticketTemplate'];
    supportForEntityID = json['supportForEntityID'];
    raisedBy = json['raisedBy'];
    raisedByEntityID = json['raisedByEntityID'];
    raisedByEntityEmail = json['raisedByEntityEmail'];
    raisedByEntityPhone = json['raisedByEntityPhone'];
    if (json['supportAttachments'] != null) {
      supportAttachments = new List<SupportAttachments>();
      json['supportAttachments'].forEach((v) {
        supportAttachments.add(new SupportAttachments.fromJson(v));
      });
    }
    supportComment = json['supportComment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticketTemplate'] = this.ticketTemplate;
    data['supportForEntityID'] = this.supportForEntityID;
    data['raisedBy'] = this.raisedBy;
    data['raisedByEntityID'] = this.raisedByEntityID;
    data['raisedByEntityEmail'] = this.raisedByEntityEmail;
    data['raisedByEntityPhone'] = this.raisedByEntityPhone;
    if (this.supportAttachments != null) {
      data['supportAttachments'] =
          this.supportAttachments.map((v) => v.toJson()).toList();
    }
    data['supportComment'] = this.supportComment;
    return data;
  }
}

class SupportAttachments {
  String attachmentType;
  String attachmentLink;

  SupportAttachments({this.attachmentType, this.attachmentLink});

  SupportAttachments.fromJson(Map<String, dynamic> json) {
    attachmentType = json['attachmentType'];
    attachmentLink = json['attachmentLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attachmentType'] = this.attachmentType;
    data['attachmentLink'] = this.attachmentLink;
    return data;
  }
}
