const functions = require("firebase-functions");
const { debug } = require("firebase-functions/logger");
const admin = require('firebase-admin');

admin.initializeApp();

 var adminTokin = "fmcPhTI3S2Kf4ymVWhoDe7:APA91bEMShFhIEJRmoUb5k1NIW8X4bjA7XOapMIqBgUovKRTYidL7vpZgtN5WlWsHRZw0T5Of73Ppd18EBHZMU7e_KkNRkjIWOnMAiy7W5onxeFioguKDrg7oKGBvC6JixAw8SxhByzh";

exports.webhook = functions.https.onRequest((request, response)=> {
  const payloadData = request.rawBody;
  var dataObject =  JSON.parse(payloadData);
  var userId;
 
  //subscribe user
  var email = dataObject["data"]["customer"]["email"].toLowerCase();

  const usersRef = admin.firestore().collection("Users").where("email", "==",email);
  usersRef.get().then(querySnapshot => {
    querySnapshot.forEach(function(doc) {
        if(doc.exists)
        {
          userId = doc.id;
          admin.firestore().collection("Active Subcription").doc(userId).set({
            "ownerId": userId,
            "device": "",
          });
		   var userToken =  doc.data().token;
           var tokens = [adminTokin, userToken];
			//Admin new subcription notification
				var payload = {
					notification: {
						title: 'Subscription successful',
						body:  "You're now a Pro User",
						sound: 'default',
						badge:'1'
					},

					data: {
						click_action:"FLUTTER_NOTIFICATION_CLICK",
						navigation:"/notification"
					},
				};
				
				var options = {
					priority:"high",
				};

				try {
					admin.messaging().sendToDevice(tokens, payload, options);
					console.log('Notification sent successfully');
				} catch (err) {
					console.log(err);
				}
				
		  // Reward agents referal
		 var rCode =  doc.data().code;
		 if(rCode.length == 5){
         const agents = admin.firestore().collection("Agents").where("code", "==", rCode);
         agents.get().then(querySnapshot => {
		 querySnapshot.forEach(function(doc) {
			if(doc.exists)
			{
				var initialBalance =  doc.data().balance;
				var balance = (initialBalance + 100);
				var userId = doc.id;
				admin.firestore().collection("Agents").doc(userId).update({
					"balance": balance,
				  });
			}
		  });
		});
        }
	    }
      });
    });
    return response.sendStatus(200);
});



exports.notification = functions.firestore.document('Notifications/{ownerId}/list/{postId}').onWrite(async (snapshot, context) => {

   var message = "";
   newData = snapshot.after.data();
    

   if(newData.type == "Welcome" || newData.type == "Success" ||  newData.type == "Failed" ||  newData.type == "Points" ){
      if(newData.type == "Welcome"){
       message = "Welcome to My CBT, Thanks  for joining the community.";
      }else if(newData.type == "Success"){
       message = "Your subscription was successful! thank you for choosing My CBT.";
      }else if(newData.type == "Failed"){
       message = "Subscription failed due to invalid payment details, please try again.";
      }else if(newData.type == "Points"){
		message = newData.body;
	   }else {
       message = "You have a notification.";
      }
   
	     
	var payload = {
		notification: {
			title: newData.type,
			body: message,
			sound: 'default',
			badge:'1'
		},

		data: {
			click_action:"FLUTTER_NOTIFICATION_CLICK",
			navigation:"/notification"
			
		},
	};
	
	var options = {
		priority:"high",
	};

	try {
		 admin.messaging().sendToDevice(newData.token, payload, options);
		console.log('Notification sent successfully');
	} catch (err) {
		console.log(err);
	}

   }else{
	   
    admin.firestore().collection("Users").doc(newData.userId).get().then(snapshot => {
        
          var username = snapshot.data().username;
		  var profileImage = snapshot.data().url;
        //   if(newData.type == "Like"){
        //     message = username +" likes your post.";
        //   }else if(newData.type == "Comment"){
        //    message = username +" commented on your post.";
        //   }else if(newData.type == "Conversation Comment"){
        //    message = username +" replied  your answer.";
        //   }else if(newData.type == "Like answer"){
        //     message = username +" Likes your answer.";
        //    }else if(newData.type == "Conversation"){
        //    message = newData.body;
        //   }else {
        //    message = "You have a notification.";
        //   }

				var payload = {
					notification: {
						title:"Scholar",
						body: username+ " " + newData.body,
						sound: 'default',
						badge:'1'
					},

					data: {
						click_action:"FLUTTER_NOTIFICATION_CLICK",
						navigation:"/notification",
						profileImage:"profileImage"
					},
				};
				
				var options = {
					priority:"high",
				};

				try {
					 admin.messaging().sendToDevice(newData.token, payload, options);
				} catch (err) {
					console.log(err);
				}
      
     });
   }
  
});


//MANUAL ACTIVATION NOTIFICATION
exports.manualActivation = functions.firestore.document('New Subscription/{ownerId}').onWrite(async (snapshot, context) => {
	if (snapshot.empty) {
		console.log('No Devices');
		return;
	}
	
	const mycbtAdmin = admin.firestore().collection("Users").where("email", "==", "mycbt@gmail.com");
	    mycbtAdmin.get().then(querySnapshot => {
		 querySnapshot.forEach(function(doc) {
			if(doc.exists)
			{
				var adminTokin =  doc.data().token;
				var payload = {
					notification: {
						title: 'Offline Activation',
						body: "New offline activation recieved.",
						sound: 'default',
						badge:'1'
					},

					data: {
						click_action:"FLUTTER_NOTIFICATION_CLICK",
						navigation:"/activation"
					},
				};
				
				var options = {
					priority:"high",
				};

				try {
					 admin.messaging().sendToDevice(adminTokin, payload, options);
					console.log('Notification sent successfully');
				} catch (err) {
					console.log(err);
				}
			}
		  });
		});

});

