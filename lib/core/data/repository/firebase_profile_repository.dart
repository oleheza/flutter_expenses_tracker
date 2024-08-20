import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/exceptions/profile_not_found_exception.dart';
import '../../domain/model/profile_model.dart';
import '../../domain/repository/profile_repository.dart';

@Injectable(as: ProfileRepository)
class FirebaseProfileRepository implements ProfileRepository {
  static const _profileCollectionName = 'profiles';

  final CollectionReference _collection;

  FirebaseProfileRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _collection = firebaseFirestore.collection(_profileCollectionName);

  @override
  Future<void> createProfile(ProfileModel profile) {
    return _collection.add(profile.asMap());
  }

  @override
  Future<void> deleteProfile(String userId) async {
    final profileRef = await _collection
        .where(ProfileModel.fieldUserId, isEqualTo: userId)
        .get();

    return profileRef.docs.firstOrNull?.reference.delete();
  }

  @override
  Future<void> updateProfile(ProfileModel profile) {
    return _collection.doc(profile.id).update(profile.asMap());
  }

  @override
  Future<ProfileModel> getProfile(String userId) async {
    final snapshot = await _collection
        .where(ProfileModel.fieldUserId, isEqualTo: userId)
        .get();

    final doc = snapshot.docs.firstOrNull;
    if (doc == null) {
      throw ProfileNotFoundException();
    }

    return ProfileModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  @override
  Stream<ProfileModel?> subscribeToProfileChanges(String userId) {
    return _collection
        .where(ProfileModel.fieldUserId, isEqualTo: userId)
        .snapshots()
        .map((event) {
      final documentRef = event.docs.firstOrNull;
      final documentData = documentRef?.data();
      if (documentData == null) {
        return null;
      }
      final data = documentData as Map<String, dynamic>;
      return ProfileModel.fromMap(
        documentRef?.id,
        data,
      );
    });
  }
}
