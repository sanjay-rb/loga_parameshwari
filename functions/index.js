const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

exports.poojaNotification = functions
    .firestore
    .document('/Pooja/{docID}')
    .onWrite(async (snap, context) => {
        functions.logger.log("Pooja collection changes with id : ", context.params.docID);

        var data;

        var isCreation = false;
        var isUpdation = false;
        var isDeletion = false;

        if (snap.before.exists) {
            if (snap.after.exists) {
                isUpdation = true;
                data = snap.after.data();
            } else {
                isDeletion = true;
                data = snap.before.data();
            }
        } else {
            isCreation = true;
            data = snap.after.data();
        }

        var notificationTitle = "";
        var notificationSubTitle = "";

        if (isCreation) {
            notificationHead = "Pooja Created";
            notificationSubTitle = `Created : ${data['name']} on ${data['on']}`;
        }

        if (isUpdation) {
            notificationHead = "Pooja Updated";
            notificationSubTitle = `Updated : ${data['name']} on ${data['on']}`;
        }

        if (isDeletion) {
            notificationHead = "Pooja Deleted";
            notificationSubTitle = `Deleted : ${data['name']} on ${data['on']}`;
        }

        const payload = {
            data: {
                id: data.id,
                title: notificationTitle,
                subtitle: notificationSubTitle,
            },
        };

        const options = {
            content_available: true,
            priority: "high",
        }

        const response = await admin
            .messaging()
            .sendToTopic("com.sanjoke.loga_parameshwari", payload, options)
            .then((response) => {
                functions.logger.log("Successfully sent message:", response);
                return response;
            }).catch((errorMsg) => {
                functions.logger.error("Error sending message:", errorMsg);
                return errorMsg;
            });
        return response;
    });

