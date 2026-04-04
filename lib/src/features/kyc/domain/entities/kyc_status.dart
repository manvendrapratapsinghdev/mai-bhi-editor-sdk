/// Status of a KYC submission.
enum KycVerificationStatus {
  none,
  pending,
  approved,
  rejected,
}

/// Supported document types for KYC.
enum KycDocumentType {
  aadhaar,
  pan,
  passport,
  voterId,
}

/// Extension to get display names.
extension KycDocumentTypeX on KycDocumentType {
  String get displayName {
    switch (this) {
      case KycDocumentType.aadhaar:
        return 'Aadhaar Card';
      case KycDocumentType.pan:
        return 'PAN Card';
      case KycDocumentType.passport:
        return 'Passport';
      case KycDocumentType.voterId:
        return 'Voter ID';
    }
  }

  String get apiValue {
    switch (this) {
      case KycDocumentType.aadhaar:
        return 'aadhaar';
      case KycDocumentType.pan:
        return 'pan';
      case KycDocumentType.passport:
        return 'passport';
      case KycDocumentType.voterId:
        return 'voter_id';
    }
  }
}

extension KycVerificationStatusX on KycVerificationStatus {
  String get displayName {
    switch (this) {
      case KycVerificationStatus.none:
        return 'Not Submitted';
      case KycVerificationStatus.pending:
        return 'Pending Review';
      case KycVerificationStatus.approved:
        return 'Approved';
      case KycVerificationStatus.rejected:
        return 'Rejected';
    }
  }
}
