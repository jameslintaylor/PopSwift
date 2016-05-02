# PopSwift - *a µframework wrapping facebook's pop framework for more pleasant use in Swift* 

[facebook/pop](https://github.com/facebook/pop) is awesome, and it could be even more awesome in Swift. PopSwift is all about making that happen ☺️.

# Usage

## Animating custom properties
One awesome thing about [facebook/pop](https://github.com/facebook/pop) is the ability to animate any `CGFloat` property on any `NSObject`.

These next few examples highlight how we might animate a custom `property` on a `PropertyOwner` object...

#### pop 

```swift

// Create a custom animatable property 
let animatableProperty = POPAnimatableProperty.propertyWithName("property") { property in

	// Specify how the property should be read
	property.readBlock = { object, values in
		values[0] = (object as! PropertyOwner).property
	}

	// Specify how the property should be written
	property.writeBlock = { object, values in
		(object as! PropertyOwner).property = values[0]
	}
}

// Create an animation 
let animation = POPBasicAnimation(propertyNamed: "property_animation")
animation.toValue = 1
animation.duration = 1
animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

// Execute this closure each animation frame
animation.animationDidApplyBlock = { _ in 
	print("property is now \(property)!") 
}

// Execute this closure when the animation completes        
animation.completionBlock = { _, completed in 
	print(completed ? "🐥" : "🐣")
}

// Link the animation to the property we just created
animation.property = animatableProperty

// Start the animation 
propertyOwner.pop_addAnimation(animation, forKey: "🔑")

```

#### PopSwift 

```swift

let property = ReadWriteProperty(in: propertyOwner)

	// Specify how the property should be read
	.read { owner, value in 
		value = owner.property
	}

	// Specify how the property should be written
	.write { owner, value in 
		owner.property = value
	}

// Create an animation
property.newAnimation(.basic(toValue: 1, duration: 1, timingFunction: .easeOut))

	// Execute this closure each animation frame
	.onApply { 
		print("property is now \(property)!")	
	}

	// Execute this closure when the animation completes
	.onComplete { completed in 
		print(completed ? "🐥" : "🐣")
	}

	// Start the animation
	.start()

```

---

***These two codeblocks were a bit unrealistically verbose due to all that commenting! Here's what a more realistic call site might look like:***

---

#### pop 

```swift

let animatableProperty = POPAnimatableProperty.propertyWithName("property") { property in
	property.readBlock = { $1[0] = ($0 as! PropertyOwner).property }
	property.writeBlock = { ($0 as! PropertyOwner).property = $1[0] }
}

let animation = POPBasicAnimation(propertyNamed: "property_animation")
animation.toValue = 1
animation.duration = 1
animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

animation.animationDidApplyBlock = { _ in print("property is now \(property)!") }
animation.completionBlock = { _, completed in print(completed ? "🐥" : "🐣") }

animation.property = animatableProperty
propertyOwner.pop_addAnimation(animation, forKey: "🔑")

```

#### PopSwift

```swift

let property = ReadWriteProperty(in: propertyOwner)
	.read {  $1 = $0.property }
	.write { $0.property = $1 }

property.newAnimation(.basic(toValue: 1, duration: 1, timingFunction: .easeOut))
	.onApply { print("property is now \(property)!") }
	.onComplete { completed in print(completed ? "🐥" : "🐣") }
	.start()

```

# Installation (Carthage)
Add this to your Cartfile:

```
github "jameslintaylor/PopSwift"
```

