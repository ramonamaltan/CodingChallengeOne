### Smart Locks Challenge: Introduction
You are working for a company that sells smart locks. The smart locks have their own app with which you can open them. Every now and then our company servers send a csv file with the lock behaviors as shown in the examples below 👇

```shell
timestamp,lock_id,kind,status_change
2017-05-01T00:32:50Z,9db3b7eb,sensor,online
2017-05-01T00:40:20Z,6e711d12,gateway,online
2017-05-01T00:43:50Z,3831469f,sensor,offline
2017-05-01T00:50:10Z,3831469f,sensor,online
2017-05-01T00:50:30Z,89987171,gateway,online
```

In the example you can see that there are five different entries. The first entry, indicates that a sensor kind lock has been turned on at 00:32am on the 1st of May of 2017. The second one indicates that a gateway kind lock has also been turned on on the same date 8 minutes later.

### Smart Locks Challenge: Your Task
Create an app that is able to receive this 👆 generated report, coming from our company servers and stores this information in a database (PostgreSQL recommended). Only our company servers should be authorized to contact this endpoint.

The servers have already a codename and It’s your job to provide an accesstoken they can use to access your app. The server code_name is: llamas_in_pijamas. To handle authentication, you need an access_token. You have to generate this.
