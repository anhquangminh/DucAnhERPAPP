class ApplicationUser {
  String id;
  String userName;
  String firstName;
  String lastName;
  DateTime dob;
  String phoneNumber;
  String email;
  String address;
  String companyId;
  String deptId;
  int isFirstLogin;
  String groupId;
  int ordinarily;
  DateTime createAt;
  String createBy;
  int isActive;
  String approvalUserId;
  DateTime dateApproval;
  String departmentId;
  int departmentOrder;
  int approvalOrder;
  String approvalId;
  String lastApprovalId;
  String isStatus;

  ApplicationUser({
    this.id = '',
    this.userName = '',
    this.firstName = '',
    this.lastName = '',
    DateTime? dob,
    this.phoneNumber = '',
    this.email = '',
    this.address = '',
    this.companyId = '',
    this.deptId = '',
    this.isFirstLogin = 0,
    this.groupId = '',
    this.ordinarily = 0,
    DateTime? createAt,
    this.createBy = '',
    this.isActive = 0,
    this.approvalUserId = '',
    DateTime? dateApproval,
    this.departmentId = '',
    this.departmentOrder = 0,
    this.approvalOrder = 0,
    this.approvalId = '',
    this.lastApprovalId = '',
    this.isStatus = '',
  })  : dob = dob ?? DateTime.now(),
        createAt = createAt ?? DateTime.now(),
        dateApproval = dateApproval ?? DateTime.now();

  factory ApplicationUser.fromJson(Map<String, dynamic> json) {
    return ApplicationUser(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      dob: DateTime.tryParse(json['dob'] ?? '') ?? DateTime.now(),
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      companyId: json['companyId'] ?? '',
      deptId: json['deptId'] ?? '',
      isFirstLogin: json['isFirstLogin'] ?? 0,
      groupId: json['groupId'] ?? '',
      ordinarily: json['ordinarily'] ?? 0,
      createAt: DateTime.tryParse(json['createAt'] ?? '') ?? DateTime.now(),
      createBy: json['createBy'] ?? '',
      isActive: json['isActive'] ?? 0,
      approvalUserId: json['approvalUserId'] ?? '',
      dateApproval: DateTime.tryParse(json['dateApproval'] ?? '') ?? DateTime.now(),
      departmentId: json['departmentId'] ?? '',
      departmentOrder: json['departmentOrder'] ?? 0,
      approvalOrder: json['approvalOrder'] ?? 0,
      approvalId: json['approvalId'] ?? '',
      lastApprovalId: json['lastApprovalId'] ?? '',
      isStatus: json['isStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob.toIso8601String(),
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'companyId': companyId,
      'deptId': deptId,
      'isFirstLogin': isFirstLogin,
      'groupId': groupId,
      'ordinarily': ordinarily,
      'createAt': createAt.toIso8601String(),
      'createBy': createBy,
      'isActive': isActive,
      'approvalUserId': approvalUserId,
      'dateApproval': dateApproval.toIso8601String(),
      'departmentId': departmentId,
      'departmentOrder': departmentOrder,
      'approvalOrder': approvalOrder,
      'approvalId': approvalId,
      'lastApprovalId': lastApprovalId,
      'isStatus': isStatus,
    };
  }
}
