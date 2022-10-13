import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi{
   final String url = 'https://admin.bahrainunique.com';

    //final String url = 'http://10.0.2.2:8000';

    postData(data, apiUrl) async {
        var fullUrl = url + apiUrl;
        print(fullUrl);
        return await http.post(
            fullUrl, 
            body: jsonEncode(data), 
            headers: await _setHeaders()
        );
            
    }
    editData(data, apiUrl) async {
        var fullUrl = url + apiUrl;
        return await http.put(
            fullUrl, 
            body: jsonEncode(data), 
            headers: await _setHeaders()
        );                   
        
    }
                
                                                                    
    getData(apiUrl) async {
       var fullUrl = url + apiUrl; 
       print(fullUrl);
       return await http.get(
         fullUrl, 
         headers:  await _setHeaders()
       );
    }


    _setHeaders() async => {
       "Authorization" : 'Bearer ' + await _getToken(),
        'Content-type' : 'application/json',
        'Accept' : 'application/json',        
    };

    

    _getToken() async {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        var token = localStorage.getString('token');
        return '$token';
    }
}
