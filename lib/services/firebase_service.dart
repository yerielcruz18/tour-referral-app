import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }
  
  // Phone Authentication
  static Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-sign in (Android only)
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      onError(e.toString());
    }
  }
  
  // Verify SMS Code
  static Future<User?> signInWithSMSCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      
      UserCredential userCredential = await auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }
  
  // Check if user exists
  static Future<bool> checkUserExists(String userId) async {
    try {
      DocumentSnapshot doc = await firestore.collection('users').doc(userId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
  
  // Create new user
  static Future<void> createUser({
    required String userId,
    required String phone,
    required String name,
    required String email,
    required String agentCode,
    String? instagramUsername,
    required String notificationFrequency,
  }) async {
    try {
      await firestore.collection('users').doc(userId).set({
        'id': userId,
        'phone': phone,
        'name': name,
        'email': email,
        'agentCode': agentCode,
        'instagramUsername': instagramUsername,
        'points': 0,
        'currentStreak': 0,
        'longestStreak': 0,
        'lastShareDate': DateTime.now().toIso8601String(),
        'notificationFrequency': notificationFrequency,
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': true,
        'totalShares': 0,
        'totalCommissions': 0.0,
      });
      
      // Also add agent code to separate collection for easy lookup
      await firestore.collection('agentCodes').doc(agentCode).set({
        'userId': userId,
        'name': name,
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error creating user: $e');
      throw e;
    }
  }
  
  // Get user data
  static Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
  
  // Update user points
  static Future<void> updatePoints(String userId, int pointsToAdd) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'points': FieldValue.increment(pointsToAdd),
        'totalShares': FieldValue.increment(1),
        'lastShareDate': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating points: $e');
    }
  }
  
  // Sign out
  static Future<void> signOut() async {
    await auth.signOut();
  }
}