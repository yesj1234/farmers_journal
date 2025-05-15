// import { onDocumentCreated, DocumentSnapshot } from "firebase-functions/v2/firestore";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { initializeApp } from "firebase-admin/app";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
// import { Timestamp } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";

// Initialize Firebase Admin
initializeApp();

// Define interfaces for our data types
interface JournalData {
  writerId: string;
  title?: string;
  content?: string;
  createdAt?: Timestamp;
  // Add other journal fields as needed
}


interface FcmTokenData {
  token: string;
  createdAt: Timestamp;
  deviceId?: string;
  // Add other token fields as needed
}

/**
 * Cloud Function that sends a notification to a journal writer when a comment is added
 *
 * Triggered when a document is created in the comments subcollection of a journal
 */
// exports.notifyJournalWriter = onDocumentCreated(
//   "journals/{journalId}/comments/{commentId}",
//   async (event) => {
//     try {
//       const snapshot = event.data as DocumentSnapshot | undefined;
//       if (!snapshot) {
//         console.log("No data associated with the event");
//         return;
//       }
//
//       const { journalId, commentId } = event.params;
//
//       // We don't need commentData but can keep for future use if needed
//       // const commentData = snapshot.data() as CommentData;
//
//       // Get the journal document to find the writerId
//       const db = getFirestore();
//       const journalRef = db.collection("journals").doc(journalId);
//       const journalDoc = await journalRef.get();
//
//       if (!journalDoc.exists) {
//         console.error(`Journal document not found: ${journalId}`);
//         return;
//       }
//
//       const journalData = journalDoc.data() as JournalData;
//       const writerId = journalData.writer;
//
//       if (!writerId) {
//         console.error(`No writerId found for journal: ${journalId}`);
//         return;
//       }
//
//       // Get the user's latest FCM token from their FCM subcollection
//       const userFcmCollection = db.collection("users").doc(writerId).collection("tokens");
//       const userFcmSnapshot = await userFcmCollection
//         .orderBy("createdAt", "desc")
//         .limit(1)
//         .get();
//
//       if (userFcmSnapshot.empty) {
//         console.error(`No FCM tokens found for user: ${writerId}`);
//         return;
//       }
//
//       const userFcmDoc = userFcmSnapshot.docs[0];
//       const fcmData = userFcmDoc.data() as FcmTokenData;
//       const fcmToken = fcmData.token;
//
//       if (!fcmToken) {
//         console.error(`FCM token is empty for user: ${writerId}`);
//         return;
//       }
//
//       // Create notification message
//       const message = {
//         notification: {
//           title: "New Comment on Your Journal",
//           body: "Someone commented on your journal entry",
//         },
//         data: {
//           journalId: journalId,
//           commentId: commentId,
//           click_action: "FLUTTER_NOTIFICATION_CLICK",
//         },
//         token: fcmToken,
//       };
//
//       // Send the notification
//       const messaging = getMessaging();
//       const response = await messaging.send(message);
//       console.log("Successfully sent notification:", response);
//     } catch (error) {
//       console.error("Error sending notification:", error);
//     }
//   }
// );


exports.notifyJournalWriter = onDocumentCreated("journals/{journalId}/comments/{commentId}", async (event)=>{
    debugger;

    const snapshot = event.data;
    if (!snapshot) {
        console.log("No data associated with the event");
        return;
        }
    const {journalId} = event.params;

    const db = getFirestore();
    const journalSnapshot = await db.collection("journals").doc(journalId).get();

    if (!journalSnapshot.exists) {
       console.log(`No journal found with ID: ${journalId}`);
       return;
    }
    const journalData = journalSnapshot.data() as JournalData;
    const writerId = journalData["writer"];
    const userFcmCollection = db.collection("users").doc(writerId).collection("tokens");
    const userFcmSnapshot = await userFcmCollection
        .orderBy("createdAt", "desc")
        .limit(1)
        .get();

    if (userFcmSnapshot.empty) {
        console.error(`No FCM tokens found for user: ${writerId}`);
        return;
        }

    const userFcmDoc = userFcmSnapshot.docs[0];
    const fcmData = userFcmDoc.data() as FcmTokenData;
    const fcmToken = fcmData.token;

    if (!fcmToken) {
        console.error(`FCM token is empty for user: ${writerId}`);
        return;
    }

    // Create notification message
    const message = {
        notification: {
          title: "댓글 알림",
          body: "내 게시물에 새로운 댓글이 달렸습니다.",
        },
        data: {
          journalId: journalId,
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
        token: fcmToken,
      };

    // Send the notification
    const messaging = getMessaging();
    try {
        const response = await messaging.send(message);
        console.log("Successfully sent notification:", response);
    } catch (error) {
        console.error("Error sending notification:", error);
    }
});