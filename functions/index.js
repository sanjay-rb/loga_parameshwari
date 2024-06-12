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
        var notificationOnClickData = "";

        const date = `${data['on'].toDate().toDateString()} ${data['on'].toDate().toLocaleTimeString()}`;

        if (isCreation) {
            notificationTitle = "Pooja Created";
            notificationSubTitle = `New ${data['name']} is scheduled on ${date}`;
            notificationOnClickData = `created:${data['id']}`;
        }

        if (isUpdation) {
            notificationTitle = "Pooja Updated";
            notificationSubTitle = `Updates on ${data['name']} is scheduled on ${date}`;
            notificationOnClickData = `updated:${data['id']}`;
        }

        if (isDeletion) {
            notificationTitle = "Pooja Deleted";
            notificationSubTitle = `${data['name']} has been deleted`;
            notificationOnClickData = `deleted:${data['id']}`;
        }

        const payload = {
            data: {
                id: data.id,
                title: notificationTitle,
                subtitle: notificationSubTitle,
                onClickData: notificationOnClickData,
            },
        };

        const options = {
            content_available: true,
            priority: "high",
        }

        functions.logger.log(`Payload for Pooja Id : ${context.params.docID}`, payload);
        functions.logger.log(`Options for Pooja Id : ${context.params.docID}`, options);

        // const response = "";
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

