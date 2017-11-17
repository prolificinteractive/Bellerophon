# BELLEROPHON #

[![Travis build status](https://img.shields.io/travis/prolificinteractive/Bellerophon.svg?style=flat-square)](https://travis-ci.org/prolificinteractive/Bellerophon)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Bellerophon.svg?style=flat-square)](https://img.shields.io/cocoapods/v/Bellerophon.svg)
[![Platform](https://img.shields.io/cocoapods/p/Bellerophon.svg?style=flat-square)](http://cocoadocs.org/docsets/Bellerophon)
[![Docs](https://img.shields.io/cocoapods/metrics/doc-percent/Bellerophon.svg?style=flat-square)](http://cocoadocs.org/docsets/Bellerophon)

![Bellerophon fighting Chimera](Images/bellerophon.jpg)

Bellerophon is a hero of Greek mythology. He was *"the greatest hero and slayer of monsters, alongside Cadmus and Perseus, before the days of Heracles"*, and his greatest feat was killing the **Chimera**, a monster that Homer depicted with a lion's head, a goat's body, and a serpent's tail.

Sometimes in a development phase, it happens for different reasons that the app available in the store has to be killed. It could be because it contains a major issue (crash, security breach...) or for a business decision (killing the app before a Sale starts, so users are not buying before the others for example).

## Description ##

Bellerophon is a Swift implementation of a protocol and convenient methods that allow you to either kill your app or force the users to update using the App Store. By implementing Bellerophon, you will be able to easily add the logic to present a kill state view in your app, or force users to update.

## Requirements

* iOS 9.0+
* Xcode 8.0+

## Installation ##

To use in your projects, simply add the following line to your Podfile:

```bash
pod 'Bellerophon'
```

You can then use `Bellerophon` by importing it into your files:

```swift
import Bellerophon
```

### Configuration ###

In order to use Bellerophon, you'll have to follow these steps:

1 - In your AppDelegate implementation file, import the project and register to the `BellerophonManagerDelegate`.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate, BellerophonManagerDelegate {
	...
}
```

2 - Implement and configure the Bellerophon shared manager by setting the delegate property and the kill switch view.

```swift
let killSwitchManager = BellerophonManager(window: window)
killSwitchManager.delegate = self
killSwitchManager.killSwitchView = <YOUR_VIEW>
```

3 - Start the check the app status

```swift
killSwitchManager.checkAppStatus()
```

Here is for the Bellerophon basic implementation. Now you will need to create your own model that conforms to the Bellerophon status protocol, `BellerophonObservable`.

4 - Creates your model and make it conforms to `BellerophonObservable`.

```swift
class BellerophonModel: BellerophonObservable { }
```

5 - Implements the `BellerophonObservable` methods.

```swift
@objc func apiInactive() -> Bool {
	...
}

@objc func forceUpdate() -> Bool {
	...
}

@objc func retryInterval() -> NSTimeInterval {
	...
}

@objc func userMessage() -> String {
	...
}
```

6 - Now that you have your model, you are ready to implement the `BellerophonManagerDelegate` methods in your App Delegate.

```swift
func bellerophonStatus(_ manager: BellerophonManager,
                                  completion: @escaping (BellerophonObservable?, NSError?) -> ()) {
    // MAKE API CALL
    Alamofire.request(killSwitchURL,
                      method: .get,
                      parameters: nil,
                      encoding: JSONEncoding(),
                      headers: nil)
        .responseJSON { (response) in
            if let json = response.result.value as? JSON {
                let model = BellerophonModel(json: json)
                completion(model, nil)
            } else if let error = response.result.error as NSError? {
                completion(nil, error)
            }
    }
}

func shouldForceUpdate() {
	// A force update event should occur. An alert should be displayed to redirect to the App Store.
}
```

Your app is not ready to work with Bellerophon. If the status tells Bellerophon to kill the app, it will display a full screen view on top of everything and will keep it like that until the status API indicates that the app should work again. A timer is also starting based on the retry interval provided by the status object.

Similarily, `BellerophonManager` on init provides a `shouldPresentViewForForceUpdate` parameter that, if enabled, will display a full screen view as well instead of triggering `shouldForceUpdate`.

Your API and model should be able to indicate at least these informations :

* Is the API active or inactive?
* Should the app be forced to update?
* What is the retry interval?
* What is the user message to display on the kill view?

The specifications that we are using at Prolific Interactive are this one:

```
{
    "apiInactive": false,
    "forceUpdate": false,
    "retryInterval": 15,
    "userMessage": null
}
```

* `apiInactive`
    * Determines if the API is active or not. If it is `true` the App UI should be blocked until this is `false`.
    * Required, type: boolean
* `forceUpdate`
    * Determines if the App should force the user to update to the latest version. This should be used very sparingly.
    Only in emergencies or non supported app versions.
    * Required, type: boolean
* `retryInterval`
    * The time in seconds to wait to ping this endpoint until `apiInactive` is set to `false`.
    * Required, type: integer
* `userMessage`
    * A message to describe the issue that is going on.
    * Optional, type: string


### How to test? ###

Currently there is not an easy way to test Bellerophon. The best way is either to force the response model from the API to return an API inactive state so you can see the kill switch, or use a web debugging proxy like [Charles](http://www.charlesproxy.com) to set a breakpoint on the endpoint and change the API response to deactivate the API.

## Contributing ##

To report a bug or enhancement request, feel free to file an issue under the respective heading.

If you wish to contribute to the project, fork this repo and submit a pull request.

## License ##

Bellerophon is Copyright (c) 2015 Prolific Interactive. It may be redistributed under the terms specified in the [LICENSE](LICENSE) file.

## Maintainers ##

![prolific](https://s3.amazonaws.com/prolificsitestaging/logos/Prolific_Logo_Full_Color.png)

Bellerophon is maintained and funded by Prolific Interactive. The names and logos are trademarks of Prolific Interactive.