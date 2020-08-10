var https = require('https');
var util = require('util');

exports.handler = function(event, context) {
    console.log(JSON.stringify(event, null, 2));

    var eventMessage = JSON.parse(event.Records[0].Sns.Message);
    var alarmName = eventMessage.AlarmName;
    var alarmDescription = eventMessage.AlarmDescription;
    var newStateReason = eventMessage.NewStateReason;

    var comparisonOperator = eventMessage.Trigger.ComparisonOperator;
    var threshold = eventMessage.Trigger.Threshold;
    var metricName= eventMessage.Trigger.MetricName;



    var environment = alarmName.split("__")[0];
    var service = alarmName.split("__")[1];
    var metric = alarmName.split("__")[2];
    var severity = alarmName.split("__")[3];
    var severityText = severity;
    var currentDate = new Date();

    var currentDateMinusFiveMinutes = new Date();
    currentDateMinusFiveMinutes.setMinutes(currentDateMinusFiveMinutes.getMinutes()-5);

    var dateRangePlaceholder = "start_end_date_placeholder"
    var updatedAlarmDescription = alarmDescription
                                 .replace(dateRangePlaceholder,"start="+currentDateMinusFiveMinutes.toISOString().concat(";end=".concat(currentDate.toISOString())))

    if (eventMessage.NewStateValue == "OK") {
        severity="ok";
        severityText="ok (was "+severityText+")";
        if (eventMessage.OldStateValue =="INSUFFICIENT_DATA") {
            return 0;//do not want to generate alert simply moving from insufficient data to ok
            }
        }

    if (eventMessage.NewStateValue == "INSUFFICIENT_DATA")
        severity='insufficient data';


    var subChannelForEnvironment=(environment=='del-prod') ? "production" : "nonprod";

    var channel="delius-alerts-"+service+"-"+subChannelForEnvironment;


    var resolvers = "";


    if (severity=='fatal' || severity=='critical' && environment=='del-prod'){
            resolvers="\n\nNotified:"
            +"<@UEPGCM2UC> " //Semenu
            +"<@U6YSHKNBS> " //Paul
            +"<@U6CNGECSG> " //Mark
            +"<@URCECP8RX>" //Martin

    }

    var icon_emoji=":twisted_rightwards_arrows:";

    if (severity=='ok' )
        icon_emoji = ":ok:";


    if (severity=='warning' )
        icon_emoji = ":warning:";


    if (severity=='critical' )
        icon_emoji = ":siren:";

    if (severity=='fatal' )
       icon_emoji = ":alert:";



    console.log("Slack channel: " + channel);

    var debug="";
//    var debug="\n```"+JSON.stringify(eventMessage,null,'\t')+"```";

    var textMessage="**************************************************************************************************"
                            +"\nMetric: " + metric
                            +"\nCurrent timestamp: " + currentDate.toUTCString()
                            + "\nEnvironment: " + environment
                            + "\nSeverity: " +severity+"\n";


     if (severity=='warning' || severity=='critical' || severity=='fatal')

     { textMessage=textMessage
          + "\n"+icon_emoji
          + " *" + metricName + " is "
          +  comparisonOperator + " of "
          +  threshold +"*"
          + "\n\nAction: " + updatedAlarmDescription
          + resolvers;
     }
     else
     { textMessage=textMessage
                + "\n\n:ok: No Action Required :-)";

     }
    textMessage=textMessage+debug;



    //Make sure no servicemix log alarm is pushed to slack during out of hours and weekends;
    bypassServiceMixLogAlarmForOutOfHoursScenarios();

    var postData = {
        "channel": "# " + channel,
        "username": "AWS SNS via Lambda :: Alarm notification",
        "text": textMessage,
        "icon_emoji": icon_emoji,
        "link_names": "1"
    };



    var options = {
        method: 'POST',
        hostname: 'hooks.slack.com',
        port: 443,
        path: '/services/T02DYEB3A/BGJ1P95C3/f1MBtQ0GoI6kbGUztiSpkOut'
    };

    var req = https.request(options, function(res) {
      res.setEncoding('utf8');
      res.on('data', function (chunk) {
        context.done(null);
      });
    });

    req.on('error', function(e) {
      console.log('problem with request: ' + e.message);
    });

    req.write(util.format("%j", postData));
    req.end();

    function getSlackChannelName() {
        var subChannelForEnvironment = (environment == 'del-prod') ? "production" : "nonprod";

        if (metricName.includes("connection")) {
            return "delius-alerts-" + service + "-connection-" + subChannelForEnvironment;
        }
        return "delius-alerts-" + service + "-" + subChannelForEnvironment;
    }

    function generateAlarmDescription() {
        var alarmFilterText = alarmDescription.split('filter=').pop().split(';')[0];
        var dateRangePlaceholder = "start_end_date_placeholder"

        // We want to avoid description generation for non 'exception' alarms e.g. latency and un-healthy hosts
        if (alarmDescription.includes(dateRangePlaceholder)){
            return  alarmDescription
                .replace(alarmFilterText, encodeURIComponent(alarmFilterText))
                .replace(dateRangePlaceholder, "start=" + currentDateMinusFiveMinutes.toISOString().concat(";end=".concat(currentDate.toISOString())));
        }
        return alarmDescription;
    }
    
    function bypassServiceMixLogAlarmForOutOfHoursScenarios() {
        var isOutOfHours = currentDate.getHours() > 20 && currentDate.getHours() < 7;
        var isWeekend = (currentDate.getDay() === 6) || (currentDate.getDay() === 0);    // 6 = Saturday, 0 = Sunday
        var isCloudwatchAgentAlarmName = alarmName.includes("servicemix-logs");

        if ((isOutOfHours || isWeekend) && isCloudwatchAgentAlarmName){
            return;
        }
    }
};
