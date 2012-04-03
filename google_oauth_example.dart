#import('dart:html');
#import('dart:json');
#import('uri.dart');

final redirect_uri="http://financeCoding.github.com/google_oauth_example/google_oauth_example.html";
//final redirect_uri="http://localhost/google_oauth_example.html";
final client_id="669612457208-voi2e4ecl89vvsbgf9qdbuptcdhv10gl.apps.googleusercontent.com";
final scope="https://www.googleapis.com/auth/userinfo.email+https://www.googleapis.com/auth/userinfo.profile";
final state="/profile";
final response_type="token";
final auth="https://accounts.google.com/o/oauth2/auth";

dataReceived(MessageEvent e) {
  var data = JSON.parse(e.data);
  print("data received");
  print("e.origin = ${e.origin}");
  print("e.source = ${e.source}");
  print("e.data = ${e.data}");
  //print(data['responseData']);
  /*
  email: "financecoding@gmail.com"
family_name: "Smith"
gender: "male"
given_name: "Adam"
id: "104569492481999771226"
link: "https://plus.google.com/104569492481999771226"
locale: "en-US"
name: "Adam Smith"
picture: "https://lh4.googleusercontent.com/-o-mQo2VxXso/AAAAAAAAAAI/AAAAAAAAixM/impYg6hnyOM/photo.jpg"
verified_email: true
  */
  print(data['picture']);
  if (data['picture']!=null) {
    var h = new Element.html("<h3>${data['name']}</h3>");
    document.body.elements.add(h);
  }
  if (data['picture']!=null) {
    var a = new Element.html("<a href='${data['link']}'><img src='${data['picture']}'></img></a>");
    document.body.elements.add(a);
  }
  

  
}

class google_oauth_example {

  google_oauth_example() {
  }

  
  void run() {
    var LoginUri="${auth}?scope=${scope}&state=${state}&redirect_uri=${redirect_uri}&response_type=${response_type}&client_id=${client_id}";
    
    //StringBuffer sb = new StringBuffer();
    
    var a = new Element.html("<a id='login' href='$LoginUri'>Login</a>");
    document.body.elements.add(a);
    
    //write("Hello World!");
    
    //write(window.location.href);
    Map queryArguments = {};
    Uri uri = new Uri.fromString(window.location.href);
    //print(uri.query);
    print(uri.fragment);
    uri.fragment.split('&').forEach((String s) {
      List arg = s.split('=');
      if (arg.length == 2 && !arg[0].isEmpty()) {
        queryArguments[arg[0]] = arg[1];
      }
    });
        
    queryArguments.forEach((var k, var v) {
      print('k=${k},v=${v}');
    });
    
    var access_token = queryArguments['access_token'];
    
    if (access_token!=null) {
      document.query('#login').remove();
      Element script = new Element.tag("script");
      script.src = 'https://www.googleapis.com/oauth2/v1/userinfo?access_token=$access_token&callback=callbackForJsonpApi';
      document.body.elements.add(script);
      
      
      //curl 'https://www.googleapis.com/oauth2/v1/userinfo?access_token=ya29.AHES6ZS_tYSbquuRb5r8MQqXhgZM5hiyw8yoVePdvhrP1Uiv2l-TPZA'
      /*
      sendRequest('https://www.googleapis.com/oauth2/v1/userinfo?access_token=$access_token&callback=callbackForJsonpApi', "", (data) {
        print(data);
      }, () {
        print("Error");
      });
     */      
    }
  }
  
  XMLHttpRequest sendRequest(String url, var data, var onSuccess, var onError) {
    XMLHttpRequest request = new XMLHttpRequest();
    request.on.readyStateChange.add((Event event) {
      if (request.readyState != 4) return;
      if (request.status == 200) {
        onSuccess(JSON.parse(request.responseText));
      } else {
        onError();
      }
    });
    
    request.open("GET", url, true);
    request.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
    //debugPrint('sendRequest '+ url+ " " + JSON.stringify(data));
    //request.send(JSON.stringify(data));   
    request.send();
    return request;
  } 

  void write(String message) {
    // the HTML library defines a global "document" variable
    document.query('#status').innerHTML = message;
  }
}

void main() {
  // load from server: sudo python -m SimpleHTTPServer 80
  //https://developer.mozilla.org/en/DOM/window.postMessage
// listen for the postMessage from the main page
  window.on.message.add(dataReceived);
  new google_oauth_example().run();
}
