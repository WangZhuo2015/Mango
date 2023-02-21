import NetworkExtension
import XrayKit

class PacketTunnelProvider: NEPacketTunnelProvider {
    
    override func startTunnel(options: [String : NSObject]? = nil) async throws {
        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "254.1.1.1")
        settings.mtu = 1500
        settings.ipv4Settings = {
            let settings = NEIPv4Settings(addresses: ["198.18.0.1"], subnetMasks: ["255.255.0.0"])
            settings.includedRoutes = [NEIPv4Route.default()]
            return settings
        }()
        settings.proxySettings = {
            let settings = NEProxySettings()
            settings.httpEnabled = true
            settings.httpServer = NEProxyServer(address: "127.0.0.1", port: 9090)
            settings.httpsEnabled = true
            settings.httpsServer = NEProxyServer(address: "127.0.0.1", port: 9090)
            settings.matchDomains = [""]
            return settings
        }()
        settings.dnsSettings = NEDNSSettings(servers: ["114.114.114.114"])
        try await self.setTunnelNetworkSettings(settings)
        do {
            var error: NSError? = nil
            let json: String = """
            {
                "log": {
                    "loglevel": "debug",
                    "dnsLog": true
                },
                "inbounds": [
                    {
                        "port": 9090,
                        "listen": "127.0.0.1",
                        "protocol": "http",
                        "settings": {
                            "udp": true
                        }
                    }
                ],
                "outbounds": [
                    {
                        "protocol": "freedom",
                        "tag": "direct",
                        "settings": {}
                    }
                ]
            }
            """
            XrayRun(json, self, &error)
            try error.flatMap { throw $0 }
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason) async {
        
    }
    
    override func handleAppMessage(_ messageData: Data) async -> Data? {
        return nil
    }
}

extension PacketTunnelProvider: XrayLoggerProtocol {
    
    func onLog(_ msg: String?) {
        msg.flatMap { NSLog($0) }
    }
}
