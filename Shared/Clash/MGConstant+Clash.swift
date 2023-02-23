import Foundation

extension MGConstant {
    @frozen public enum Clash {}
}

extension MGConstant.Clash {
    
    public static let tunnelMode            = "CLASH_TUNNEL_MODE"
    public static let logLevel              = "CLASH_LOGLEVEL"
    public static let extendAttributeKey    = "CLASH"
    public static let fileAttributeKey      = "NSFileExtendedAttributes"
    public static let trafficUp             = "CLASH_TRAFFIC_UP"
    public static let trafficDown           = "CLASH_TRAFFIC_DOWN"
    public static let ipv6Enable            = "CLASH_IPV6_ENABLE"

    public static let homeDirectory: URL = {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: MGConstant.suiteName) else {
            fatalError("无法加载共享文件路径")
        }
        let url = containerURL.appendingPathComponent("Library/Application Support/Clash")
        guard FileManager.default.fileExists(atPath: url.path) == false else {
            return url
        }
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        return url
    }()
}

extension FileAttributeKey {
    public static let extended = FileAttributeKey(rawValue: MGConstant.Clash.fileAttributeKey)
}