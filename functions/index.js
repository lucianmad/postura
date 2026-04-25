const { onValueWritten } = require("firebase-functions/v2/database");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

exports.sendPostureNotification = onValueWritten(
  {
    ref: "users/{uid}/devices/{deviceId}/notify",
    region: "europe-west1"
  },
    async (event) => {
    const data = event.data.after.val();
    if (!data) return null;

    const uid = event.params.uid;
    const status = data.status;

    const userDoc = await getFirestore()
        .collection('users')
        .doc(uid)
        .get();

    const fcmToken = userDoc.data()?.fcmToken;
    if (!fcmToken) return null;

    await getMessaging().send({
        token: fcmToken,
        notification: {
            title: 'Postura — Posture Alert',
            body: `Bad posture detected: ${status}`
        },
        data: {
          postureType: status
        }
    });

    await event.data.after.ref.set(null);
    return null;
  }
);