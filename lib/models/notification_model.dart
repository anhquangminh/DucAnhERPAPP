class NotificationModel {
  final String id;
  final String receiver;
  final String subject;
  final String content;
  final String? companyId;
  final String? userId;
  final String? parentMajorId;
  final String? majorId;
  final String? idCheck;
  final String? idLog;
  final bool isMail;
  final bool isNotification;
  final bool isSMS;
  final String groupId;
  final DateTime createAt;
  String? createBy;
  int isRead;
  final String majorName;
  final String parentName;

  NotificationModel({
    required this.id,
    required this.receiver,
    required this.subject,
    required this.content,
    this.companyId,
    this.userId,
    this.parentMajorId,
    this.majorId,
    this.idCheck,
    this.idLog,
    this.isMail = false,
    this.isNotification = false,
    this.isSMS = false,
    required this.groupId,
    required this.createAt,
    this.createBy,
    required this.isRead,
    required this.majorName,
    required this.parentName,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      receiver: json['receiver'] ?? '',
      subject: json['subject'] ?? '',
      content: json['content'] ?? '',
      companyId: json['companyId'],
      userId: json['userId'],
      parentMajorId: json['parentMajorId'],
      majorId: json['majorId'],
      idCheck: json['idCheck'],
      idLog: json['idLog'],
      isMail: json['isMail'] ?? false,
      isNotification: json['isNotification'] ?? false,
      isSMS: json['isSMS'] ?? false,
      groupId: json['groupId'] ?? '',
      createAt: DateTime.tryParse(json['createAt'] ?? '') ?? DateTime.now(),
      createBy: json['createBy'],
      isRead: json['isRead'] ?? 0,
      majorName: json['majorName'] ?? '',
      parentName: json['parentName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiver': receiver,
      'subject': subject,
      'content': content,
      'companyId': companyId,
      'userId': userId,
      'parentMajorId': parentMajorId,
      'majorId': majorId,
      'idCheck': idCheck,
      'idLog': idLog,
      'isMail': isMail,
      'isNotification': isNotification,
      'isSMS': isSMS,
      'groupId': groupId,
      'createAt': createAt.toIso8601String(),
      'createBy': createBy,
      'isRead': isRead,
      'majorName': majorName,
      'parentName': parentName,
    };
  }
}
