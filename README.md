# MSession

## MSession is a session and authentication solution written in Swift

### It is a simple and easy solution to build a security and modular app with latest apple biometry authentication.

MSessions uses `Keychain` to authenticate users and `NSKeyedArchiver` to save user's session. It's really flexible, easy and scalable use into your app.

## Requirements

- Xcode 10.0+
- Swift 5.0+

## Versioning

- *Swift 4.2*: 0.1.6
- *Swift 5.0*: 1*

## Installation

You can use each solution (Session/Auth) separately but by default these solutions are together.


### Cocoapods

```ruby
pod 'MSession'
```

The subspec if you want use App session solution

```ruby
pod 'MSession/Session'
```

The subspec if you want use App authentication solution 

```ruby
pod 'Mession/Auth'
```

### Manually

If you don't use any dependency managers, you can integrate MSession in your project manually just adding the files which contains: 

- [MSession Classes](https://github.com/vitormesquita/MSession/tree/master/Source). 
- [Session Classes](https://github.com/vitormesquita/MSession/tree/master/Source/Session).
- [Auth Classes](https://github.com/vitormesquita/MSession/tree/master/Source/Auth).

## Session

Session module contains all classes to manage an app session. 

All this module runs around the `SessionManager<T: AnyObject>` class. This class is in charge to deal with ***create, update, expire and logout*** app session. By default SessionManager needs a `AnyObject` to save on session. This object will be your "user" or "client" into application.

So basically to use this module you need to have a instance of this class or create your own extending `SessionManager`.

**Create a shared instante:**

```swift
static let shared = SessionManager<User>()
```


If you want improve more things inside your session, like put a expire time or others stuffs is more appropriate create your own class and implemente the methods.

**Create your own class:**

```swift
import MSession

class AppSessionManager: SessionManager<User> {

 static let shared = AppSessionManager()
 ...
 
}
```

*Create your own class is the most appropriate*


`SessionManager` by default has a `DataStore` implementation called `SessionDataStore`, this implementation is using `NSKeyedArchiver` and `UserDefaults` to save sassion. 

If you want create a local store with realm or core data you can use MSession as well. You just need to create your own DataStore and implement `SessionDataStore` protocol.

```swift
import MSession

class AppSessionDataStore: SessionDataStoreProtocol {
 // implemet all methods
}
```

And pass the new DataStore to your SessionManager

```swift
import MSession

class AppSessionManager: SessionManager<User> {

 static let shared = AppSessionManager(dataStore: AppSessionDataStore())
 ...
 
}
```

**OBS: If you are using default DataStore (SessionDataStore) you MUST do your `User` extends `NSObject & NSCoding`**

## Auth

Auth module contains all classes to manage authentication using `Biometry (FaceID)` and `Keychain` security.

All this module runs around the `AuthManager` class. This class contains all methods you will need to ensure a secury authentication in your app.
