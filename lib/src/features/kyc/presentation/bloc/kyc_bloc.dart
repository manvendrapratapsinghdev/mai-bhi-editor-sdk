import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/kyc_status.dart';
import '../../domain/repositories/kyc_repository.dart';

part 'kyc_event.dart';
part 'kyc_state.dart';

/// BLoC that manages KYC document upload and status.
class KycBloc extends Bloc<KycEvent, KycState> {
  final KycRepository _kycRepository;

  KycBloc({
    required KycRepository kycRepository,
  })  : _kycRepository = kycRepository,
        super(const KycState()) {
    on<KycStatusRequested>(_onStatusRequested);
    on<KycDocumentTypeChanged>(_onDocumentTypeChanged);
    on<KycImagePicked>(_onImagePicked);
    on<KycUploadRequested>(_onUploadRequested);
  }

  Future<void> _onStatusRequested(
    KycStatusRequested event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(isLoadingStatus: true, clearError: true));
    try {
      final status = await _kycRepository.getKycStatus();
      emit(state.copyWith(
        verificationStatus: status,
        isLoadingStatus: false,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isLoadingStatus: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingStatus: false,
        errorMessage: 'Failed to load KYC status.',
      ));
    }
  }

  void _onDocumentTypeChanged(
    KycDocumentTypeChanged event,
    Emitter<KycState> emit,
  ) {
    emit(state.copyWith(
      selectedDocumentType: event.documentType,
      clearError: true,
      clearSuccess: true,
    ));
  }

  void _onImagePicked(
    KycImagePicked event,
    Emitter<KycState> emit,
  ) {
    emit(state.copyWith(
      pickedFilePath: event.filePath,
      clearError: true,
      clearSuccess: true,
    ));
  }

  Future<void> _onUploadRequested(
    KycUploadRequested event,
    Emitter<KycState> emit,
  ) async {
    if (state.pickedFilePath == null) {
      emit(state.copyWith(
        errorMessage: 'Please select a document image first.',
      ));
      return;
    }

    emit(state.copyWith(
      isUploading: true,
      uploadProgress: 0.0,
      clearError: true,
      clearSuccess: true,
    ));

    try {
      await _kycRepository.uploadDocument(
        documentType: state.selectedDocumentType,
        filePath: state.pickedFilePath!,
        onProgress: (progress) {
          // We can't emit from a callback directly, so we use
          // addError/add pattern. For simplicity, the final state
          // will show completion.
        },
      );

      emit(state.copyWith(
        isUploading: false,
        uploadProgress: 1.0,
        verificationStatus: KycVerificationStatus.pending,
        successMessage: 'Document uploaded successfully! Your verification '
            'is now pending review.',
        clearPickedFile: true,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isUploading: false,
        uploadProgress: 0.0,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isUploading: false,
        uploadProgress: 0.0,
        errorMessage: 'Upload failed. Please try again.',
      ));
    }
  }
}
