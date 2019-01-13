import UIKit


extension UIView
{
	// MARK: - Shortcuts
	var x: CGFloat
	{
		get {return frame.origin.x}
		set {frame.origin.x = newValue}
	}

	var y: CGFloat
	{
		get {return frame.origin.y}
		set {frame.origin.y = newValue}
	}

	var width: CGFloat
	{
		get {return frame.width}
		set {frame.size.width = newValue}
	}

	var height: CGFloat
	{
		get {return frame.height}
		set {frame.size.height = newValue}
	}

	var origin: CGPoint
	{
		get {return frame.origin}
		set {frame.origin = newValue}
	}

	var size: CGSize
	{
		get {return frame.size}
		set {frame.size = newValue}
	}

	// MARK: - Edges
	public var left: CGFloat
	{
		get {return origin.x}
		set {origin.x = newValue}
	}

	public var right: CGFloat
	{
		get {return x + width}
		set {x = newValue - width}
	}

	public var top: CGFloat
	{
		get {return y}
		set {y = newValue}
	}

	public var bottom: CGFloat
	{
		get {return y + height}
		set {y = newValue - height}
	}
}
