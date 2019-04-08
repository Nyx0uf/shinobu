import UIKit


protocol ZeroConfBrowserVCDelegate: class
{
	func audioServerDidChange(with server: ShinobuServer)
}


final class ZeroConfBrowserVC: NYXTableViewController
{
	// MARK: - Public properties
	// Delegate
	weak var delegate: ZeroConfBrowserVCDelegate? = nil
	// Currently selectd server on the add vc
	var selectedServer: ShinobuServer? = nil

	// MARK: - Private properties
	// Zeroconf explorer
	private var zeroConfExplorer: ZeroConfExplorer! = nil
	// List of servers found
	private var servers = [ShinobuServer]()

	// MARK: - UIViewController
	override func viewDidLoad()
	{
		super.viewDidLoad()

		let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction(_:)))
		navigationItem.leftBarButtonItem = done

		// Navigation bar title
		titleView.setMainText(NYXLocalizedString("lbl_header_server_zeroconf"), detailText: nil)

		tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		tableView.separatorColor = .black
		tableView.rowHeight = 64

		zeroConfExplorer = ZeroConfExplorer()
		zeroConfExplorer.delegate = self
	}

	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		zeroConfExplorer.searchForServices(type: "_mpd._tcp.")
	}

	override func viewWillDisappear(_ animated: Bool)
	{
		super.viewWillDisappear(animated)
		zeroConfExplorer.stopSearch()
	}

	// MARK: - Buttons actions
	@objc private func doneAction(_ sender: Any?)
	{
		dismiss(animated: true, completion: nil)
	}
}

// MARK: - UITableViewDataSource
extension ZeroConfBrowserVC
{
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return servers.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "fr.whine.shinobu.cell.zeroconf")
		cell.backgroundColor = Colors.background
		cell.contentView.backgroundColor = Colors.background
		let backgroundView = UIView()
		backgroundView.backgroundColor = Colors.backgroundSelected
		cell.selectedBackgroundView = backgroundView

		let server = servers[indexPath.row]
		cell.textLabel?.text = server.name
		cell.textLabel?.textColor = Colors.mainText
		cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		cell.detailTextLabel?.text = server.mpd.hostname + ":" + String(server.mpd.port)
		cell.detailTextLabel?.textColor = Colors.placeholderText

		if let currentServer = selectedServer
		{
			if currentServer == server
			{
				cell.accessoryType = .checkmark
			}
			else
			{
				cell.accessoryType = .none
			}
		}
		else
		{
			cell.accessoryType = .none
		}

		return cell
	}
}

// MARK: - UITableViewDelegate
extension ZeroConfBrowserVC
{
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		// Check if same server
		let selected = servers[indexPath.row]
		if let currentServer = selectedServer
		{
			if selected == currentServer
			{
				return
			}
		}

		// Different server, update
		selectedServer = selected

		delegate?.audioServerDidChange(with: selected)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
			tableView.reloadData()
		})
	}
}

extension ZeroConfBrowserVC: ZeroConfExplorerDelegate
{
	internal func didFindServer(_ server: ShinobuServer)
	{
		servers = zeroConfExplorer.services.map { $0.value }
		tableView.reloadData()
	}
}
