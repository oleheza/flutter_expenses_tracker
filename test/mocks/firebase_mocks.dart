import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<FirebaseFirestore>(),
    MockSpec<AuthCredential>(),
    MockSpec<FacebookAuth>(),
  ],
)
class FirebaseMocks {}
