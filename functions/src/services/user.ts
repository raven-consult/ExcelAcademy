import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';


// The function will create a new document in the firestore collection
// "users" when a new user is created in firebase authentication service
// The document will have the same id as the user's uid
export const createUserDocument = functions.auth.user().onCreate((user) => {
  functions.logger.log("Creating document for user", user.uid);

  return admin.firestore().collection("users").doc(user.uid).set({
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
});
