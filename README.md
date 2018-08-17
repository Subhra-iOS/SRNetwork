# SRNetwork
A Custom network layer to GET, POST, DELETE data at remote server. You can use the network layer in your application for all type of network calls.
Note : URLSession with default configuration.

About Developer : 
Subhra Roy (INDIA),
You can check my linked in page also : https://www.linkedin.com/in/subhra-roy-582a4030/

Code Snippet : 

//------------Create operation---------------//

let networkManager : SRNetworkManager = SRNetworkManager.sharedManager
networkManager.serviceDataTaskManagerWith(httpMethodType: .post, url: baseUrl, headers: nil, encoding: .url, urlParameter: param, networkJobType: .dataTask) { (responseData, result) in

	let success = result.localizedDescription
	print("\(success)")

	switch result{
		case Result.success: break
		case Result.failure(let error) : print("\(error)")
	}

	let response : [String : Any]? = responseData as? [String : Any]
	print("\(String(describing: response))")
}
		
//--------------Start operation-----------//    


I hope it will help.

Cheers..........
