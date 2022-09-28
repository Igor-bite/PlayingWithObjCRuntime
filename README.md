# Objective-C Runtime

## Summary
In this repo I am learning about some objc runtime hacks:
- 🔥 [Method Swizzling](#method-swizzling)
  

---

## Method Swizzling

Sometimes for convenience, sometimes to work around a bug in a framework, or sometimes because there’s just no other way, you need to modify the behavior of an existing class’s methods. 

-> **Method swizzling lets you swap the implementations of two methods**, essentially overriding an existing method with your own while keeping the original around.

😢 In Swift 5 methods `load()` and `initialize()` can't be used, so different solution was needed. Here is how it is implemeted:

The purpose is to provide a simple entry point for any class that you would like to imbue with initialize-like behaviour - this can now be done simply by conforming to `SelfAware`. It also provides a single function to initiate this behaviour for every conforming class.

```swift
protocol SelfAware: class {
    static func awake()
}

class NothingToSeeHere {

    static func harmlessFunction() {

        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let safeTypes = AutoreleasingUnsafeMutablePointer<AnyClass?>(types)
        objc_getClassList(safeTypes, Int32(typeCount))
        for index in 0 ..< typeCount { 
            (types[index] as? SelfAware.Type)?.awake()
        }
        types.deallocate(capacity: typeCount)

    }

}
```

We still need a way to run the function we defined, i.e. NothingToSeeHere.harmlessFunction(), on application startup. You could call the this from your application delegate method `didFinishLaunchingWithOptions`.

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        NothingToSeeHere.harmlessFunction()

        return true
    }

}

```

Now we can implement protocol `SelfAware` in `ViewController` and swizzle needed methods there. [In my particular example](PlayingWithObjCRuntime/SwizzlingExtension.swift) I have swizzled methods for getting background color and text for label.

### Swizzling example

```swift
extension ViewController: SelfAware {
    static func awake() {
        swizzleBgColor()
    }
    
    private static func swizzleBgColor() {
        swizzleMethod(#selector(getBgColor), withMethod: #selector(getNewBgColor))
    }

    private static func swizzleMethod(_ originalSelector: Selector, withMethod swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(self, originalSelector) else { return }
        guard let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else { return }

        let didAddMethod = class_addMethod(
            self,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )

        if didAddMethod {
            class_replaceMethod(
                self,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }

    @objc
    func getNewBgColor() -> UIColor {
        return .green
    }
}
```

### Useful materials to read:
- https://nshipster.com/method-swizzling/
- https://nshipster.com/swift-objc-runtime/
- https://jordansmith.io/handling-the-deprecation-of-initialize/