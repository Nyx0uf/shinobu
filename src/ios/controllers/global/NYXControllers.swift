import UIKit

final class NYXNavigationController: UINavigationController, Themed {
	private var themedStatusBarStyle: UIStatusBarStyle?

	override var preferredStatusBarStyle: UIStatusBarStyle {
		if let presentedViewController = presentedViewController {
			return presentedViewController.preferredStatusBarStyle
		}

		if let themedStatusBarStyle = themedStatusBarStyle {
			return themedStatusBarStyle
		}

		return .lightContent
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		initializeTheming()
	}

	override var shouldAutorotate: Bool {
		if let topViewController = topViewController {
			return topViewController.shouldAutorotate
		}
		return true
	}

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		if let topViewController = topViewController {
			return topViewController.supportedInterfaceOrientations
		}
		return .all
	}

	override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
		if let topViewController = topViewController {
			return topViewController.preferredInterfaceOrientationForPresentation
		}
		return .portrait
	}

	func applyTheme(_ theme: Theme) {
		navigationBar.tintColor = theme.tintColor
		setNeedsStatusBarAppearanceUpdate()
	}
}

class NYXTableViewController: UITableViewController {
	// Navigation title
	private(set) var titleView = NYXNavigationTitleView(frame: CGRect(.zero, 160, 44))

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	override init(style: UITableView.Style) {
		super.init(style: style)
	}

	required init?(coder: NSCoder) { fatalError("no coder") }

	override func viewDidLoad() {
		super.viewDidLoad()

		titleView.isEnabled = false
		navigationItem.titleView = titleView
	}

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		[.portrait, .portraitUpsideDown]
	}

	func updateNavigationTitle() {

	}

	func heightForMiniPlayer() -> CGFloat {
		var miniHeight = CGFloat(64)
		if let bottom = UIApplication.shared.mainWindow?.safeAreaInsets.bottom {
			miniHeight += bottom
		}
		return miniHeight
	}
}

class NYXViewController: UIViewController {
	// Navigation title
	private(set) var titleView = NYXNavigationTitleView(frame: CGRect(.zero, 160, 44))

	override func viewDidLoad() {
		super.viewDidLoad()

		titleView.isEnabled = false
		navigationItem.titleView = titleView
	}

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		[.portrait, .portraitUpsideDown]
	}

	func updateNavigationTitle() {

	}

	func heightForMiniPlayer() -> CGFloat {
		var miniHeight = CGFloat(64)
		if let bottom = UIApplication.shared.mainWindow?.safeAreaInsets.bottom {
			miniHeight += bottom
		}
		return miniHeight
	}
}

class NYXAlertController: UIAlertController {
	private var themedStatusBarStyle: UIStatusBarStyle?

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		[.portrait, .portraitUpsideDown]
	}
}

public func NavigationBarHeight() -> CGFloat {
	let statusHeight: CGFloat
	if let top = UIApplication.shared.mainWindow?.safeAreaInsets.top {
		statusHeight = top < 20 ? 20 : top
	} else {
		statusHeight = 20
	}

	return statusHeight + 44
}

private func findShadowImage(under view: UIView) -> UIImageView? {
	if view is UIImageView && view.height <= 1 {
		return (view as! UIImageView)
	}

	for subview in view.subviews {
		if let imageView = findShadowImage(under: subview) {
			return imageView
		}
	}
	return nil
}
