import Foundation
import WatchKit

/**
 HybridCache supports storing all kinds of objects, as long as they conform to
 Cachable protocol. It's two layered cache (with front and back storages), as well as Cache.
 Subscribes to system notifications to clear expired cached objects.
 */
public class HybridCache: BasicHybridCache {
    
    // MARK: - Inititalization
    
    /**
     Creates a new instance of BasicHybridCache and subscribes to system notifications.
     
     - Parameter name: A name of the cache
     - Parameter config: Cache configuration
     */
    public override init(name: String, config: Config = Config.defaultConfig) {
        super.init(name: name, config: config)
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(HybridCache.applicationDidEnterBackground),
                                       name: Notification.Name.NSExtensionHostDidEnterBackground, object: nil)
    }
    
    /**
     Removes notification center observer.
     */
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notifications

    /**
     Clears expired cache items when the app enters background.
     */
    func applicationDidEnterBackground() {
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(), userInfo: nil) { [weak self] (error) in
            self?.backStorage.clearExpired(nil)
        }
    }

}
