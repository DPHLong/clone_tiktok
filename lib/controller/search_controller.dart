import 'package:clone_tiktok/models/user_model.dart';
import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final Rx<List<UserModel>> _searchResults = Rx<List<UserModel>>([]);
  List<UserModel> get searchResults => _searchResults.value;

  searchUsers(String query) async {
    if (query.isNotEmpty) {
      _searchResults.bindStream(
        firestore
            .collection('tiktokers')
            .where('username', isGreaterThanOrEqualTo: query)
            .where('username', isLessThanOrEqualTo: query + '\uf8ff')
            .snapshots()
            .map((QuerySnapshot snap) {
              List<UserModel> retVal = [];
              for (var element in snap.docs) {
                if (element['uid'] == firebaseAuth.currentUser!.uid) {
                  // Skip the current user's profile
                  continue;
                } else {
                  retVal.add(UserModel.fromSnap(element));
                }
              }
              return retVal;
            }),
      );
    } else {
      return [];
    }
  }
}
