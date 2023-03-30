import Foundation

extension MGConfiguration {    
    public struct Outbound: Codable {
        public enum ProtocolType: String, Identifiable, CaseIterable, CustomStringConvertible, Codable {
            public var id: Self { self }
            case vless, vmess, trojan, shadowsocks
            public var description: String {
                switch self {
                case .vless:
                    return "VLESS"
                case .vmess:
                    return "VMess"
                case .trojan:
                    return "Trojan"
                case .shadowsocks:
                    return "Shadowsocks"
                }
            }
        }
        public enum Encryption: String, Identifiable, CustomStringConvertible, Codable {
            public var id: Self { self }
            case aes_128_gcm        = "aes-128-gcm"
            case chacha20_poly1305  = "chacha20-poly1305"
            case auto               = "auto"
            case none               = "none"
            case zero               = "zero"
            public var description: String {
                switch self {
                case .aes_128_gcm:
                    return "AES-128-GCM"
                case .chacha20_poly1305:
                    return "Chacha20-Poly1305"
                case .auto:
                    return "Auto"
                case .none:
                    return "None"
                case .zero:
                    return "Zero"
                }
            }
            public static let vmess: [Encryption] = [.chacha20_poly1305, .aes_128_gcm, .auto, .none, .zero]
            public static let quic:  [Encryption] = [.chacha20_poly1305, .aes_128_gcm, .none]
        }
        public struct StreamSettings: Codable {
            public enum Transport: String, Identifiable, CaseIterable, CustomStringConvertible, Codable {
                public var id: Self { self }
                case tcp, kcp, ws, http, quic, grpc
                public var description: String {
                    switch self {
                    case .tcp:
                        return "TCP"
                    case .kcp:
                        return "mKCP"
                    case .ws:
                        return "WebSocket"
                    case .http:
                        return "HTTP/2"
                    case .quic:
                        return "QUIC"
                    case .grpc:
                        return "gRPC"
                    }
                }
            }
            public enum Security: String, Identifiable, CaseIterable, CustomStringConvertible, Codable {
                public var id: Self { self }
                case none, tls, reality
                public var description: String {
                    switch self {
                    case .none:
                        return "None"
                    case .tls:
                        return "TLS"
                    case .reality:
                        return "Reality"
                    }
                }
            }
            public enum HeaderType: String, Identifiable, CaseIterable, CustomStringConvertible, Codable {
                public var id: Self { self }
                case none           = "none"
                case srtp           = "srtp"
                case utp            = "utp"
                case wechat_video   = "wechat-video"
                case dtls           = "dtls"
                case wireguard      = "wireguard"
                public var description: String {
                    switch self {
                    case .none:
                        return "None"
                    case .srtp:
                        return "SRTP"
                    case .utp:
                        return "UTP"
                    case .wechat_video:
                        return "Wecaht Video"
                    case .dtls:
                        return "DTLS"
                    case .wireguard:
                        return "Wireguard"
                    }
                }
            }
            public enum Fingerprint: String, Identifiable, CaseIterable, CustomStringConvertible, Codable {
                public var id: Self { self }
                case chrome     = "chrome"
                case firefox    = "firefox"
                case safari     = "safari"
                case ios        = "ios"
                case android    = "android"
                case edge       = "edge"
                case _360       = "360"
                case qq         = "qq"
                case random     = "random"
                case randomized = "randomized"
                public var description: String {
                    switch self {
                    case .chrome:
                        return "Chrome"
                    case .firefox:
                        return "Firefox"
                    case .safari:
                        return "Safari"
                    case .ios:
                        return "iOS"
                    case .android:
                        return "Android"
                    case .edge:
                        return "Edge"
                    case ._360:
                        return "360"
                    case .qq:
                        return "QQ"
                    case .random:
                        return "Random"
                    case .randomized:
                        return "Randomized"
                    }
                }
            }
            public enum ALPN: String, Identifiable, CaseIterable, CustomStringConvertible, Codable {
                public var id: Self { self }
                case h2         = "h2"
                case http1_1    = "http/1.1"
                public var description: String {
                    switch self {
                    case .h2:
                        return "H2"
                    case .http1_1:
                        return "HTTP/1.1"
                    }
                }
            }
            public struct TLS: Codable {
                public var serverName: String = ""
                public var allowInsecure: Bool = false
                public var alpn: [ALPN] = ALPN.allCases
                public var fingerprint: Fingerprint = .chrome
            }
            public struct Reality: Codable {
                public var show: Bool = false
                public var fingerprint: Fingerprint = .chrome
                public var serverName: String = ""
                public var publicKey: String = ""
                public var shortId: String = ""
                public var spiderX: String = ""
            }
            public struct TCP: Codable {
                public struct Header: Codable {
                    public var type: HeaderType = .none
                }
                public var header = Header()
            }
            public struct KCP: Codable {
                public struct Header: Codable {
                    public var type: HeaderType = .none
                }
                public var mtu: Int = 1350
                public var tti: Int = 20
                public var uplinkCapacity: Int = 5
                public var downlinkCapacity: Int = 20
                public var congestion: Bool = false
                public var readBufferSize: Int = 1
                public var writeBufferSize: Int = 1
                public var header = Header()
                public var seed: String = ""
            }
            public struct WS: Codable {
                public var path: String = "/"
                public var headers: [String: String] = [:]
            }
            public struct HTTP: Codable {
                public var host: [String] = []
                public var path: String = "/"
            }
            public struct QUIC: Codable {
                public struct Header: Codable {
                    public var type: HeaderType = .none
                }
                public var security = Encryption.none
                public var key: String = ""
                public var header = Header()
            }
            public struct GRPC: Codable {
                public var serviceName: String = ""
                public var multiMode: Bool = false
            }
            public var security = Security.none
            public var tlsSettings = TLS()
            public var realitySettings = Reality()
            public var transport = Transport.tcp
            public var tcpSettings = TCP()
            public var kcpSettings = KCP()
            public var wsSettings = WS()
            public var httpSettings = HTTP()
            public var quicSettings = QUIC()
            public var grpcSettings = GRPC()
            private enum CodingKeys: String, CodingKey {
                case security
                case tlsSettings
                case realitySettings
                case transport = "network"
                case tcpSettings
                case kcpSettings
                case wsSettings
                case httpSettings
                case quicSettings
                case grpcSettings
            }
            public init() {}
            public init(from decoder: Decoder) throws {
                let container: KeyedDecodingContainer = try decoder.container(keyedBy: CodingKeys.self)
                self.security = try container.decode(Security.self, forKey: .security)
                switch self.security {
                case .none:
                    break
                case .tls:
                    self.tlsSettings = try container.decode(TLS.self, forKey: .tlsSettings)
                case .reality:
                    self.realitySettings = try container.decode(Reality.self, forKey: .realitySettings)
                }
                self.transport = try container.decode(Transport.self, forKey: .transport)
                switch self.transport {
                case .tcp:
                    self.tcpSettings = try container.decode(TCP.self, forKey: .tcpSettings)
                case .kcp:
                    self.kcpSettings = try container.decode(KCP.self, forKey: .kcpSettings)
                case .ws:
                    self.wsSettings = try container.decode(WS.self, forKey: .wsSettings)
                case .http:
                    self.httpSettings = try container.decode(HTTP.self, forKey: .httpSettings)
                case .quic:
                    self.quicSettings = try container.decode(QUIC.self, forKey: .quicSettings)
                case .grpc:
                    self.grpcSettings = try container.decode(GRPC.self, forKey: .grpcSettings)
                }
            }
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(self.security, forKey: .security)
                switch self.security {
                case .none:
                    break
                case .tls:
                    try container.encode(self.tlsSettings, forKey: .tlsSettings)
                case .reality:
                    try container.encode(self.realitySettings, forKey: .realitySettings)
                }
                try container.encode(self.transport, forKey: .transport)
                switch self.transport {
                case .tcp:
                    try container.encode(self.tcpSettings, forKey: .tcpSettings)
                case .kcp:
                    try container.encode(self.kcpSettings, forKey: .kcpSettings)
                case .ws:
                    try container.encode(self.wsSettings, forKey: .wsSettings)
                case .http:
                    try container.encode(self.httpSettings, forKey: .httpSettings)
                case .quic:
                    try container.encode(self.quicSettings, forKey: .quicSettings)
                case .grpc:
                    try container.encode(self.grpcSettings, forKey: .grpcSettings)
                }
            }
        }
        public struct VLESS: Codable {
            public enum Flow: String, Identifiable, CaseIterable, CustomStringConvertible, Codable {
                public var id: Self { self }
                case none                       = "none"
                case xtls_rprx_vision           = "xtls-rprx-vision"
                case xtls_rprx_vision_udp443    = "xtls-rprx-vision-udp443"
                public var description: String {
                    switch self {
                    case .none:
                        return "None"
                    case .xtls_rprx_vision:
                        return "XTLS-RPRX-Vision"
                    case .xtls_rprx_vision_udp443:
                        return "XTLS-RPRX-Vision-UDP443"
                    }
                }
            }
            public struct User: Codable {
                public var id: String = ""
                public var encryption: String = "none"
                public var flow = Flow.none
            }
            public var address: String = ""
            public var port: Int = 443
            public var users: [User] = [User()]
        }
        public struct VMess: Codable {
            public struct User: Codable {
                public var id: String = ""
                public var alterId: Int = 0
                public var security = Encryption.auto
            }
            public var address: String = ""
            public var port: Int = 443
            public var users: [User] = [User()]
        }
        public struct Trojan: Codable {
            public var address: String = ""
            public var port: Int = 443
            public var password: String = ""
            public var email: String = ""
        }
        public struct Shadowsocks: Codable {
            public enum Method: String, Identifiable, CustomStringConvertible, Codable, CaseIterable {
                public var id: Self { self }
                case _2022_blake3_aes_128_gcm       = "2022-blake3-aes-128-gcm"
                case _2022_blake3_aes_256_gcm       = "2022-blake3-aes-256-gcm"
                case _2022_blake3_chacha20_poly1305 = "2022-blake3-chacha20-poly1305"
                case aes_256_gcm                    = "aes-256-gcm"
                case aes_128_gcm                    = "aes-128-gcm"
                case chacha20_poly1305              = "chacha20-poly1305"
                case chacha20_ietf_poly1305         = "chacha20-ietf-poly1305"
                case plain                          = "plain"
                case none                           = "none"
                public var description: String {
                    switch self {
                    case ._2022_blake3_aes_128_gcm:
                        return "2022-Blake3-AES-128-GCM"
                    case ._2022_blake3_aes_256_gcm:
                        return "2022-Blake3-AES-256-GCM"
                    case ._2022_blake3_chacha20_poly1305:
                        return "2022-Blake3-Chacha20-Poly1305"
                    case .aes_256_gcm:
                        return "AES-256-GCM"
                    case .aes_128_gcm:
                        return "AES-128-GCM"
                    case .chacha20_poly1305:
                        return "Chacha20-Poly1305"
                    case .chacha20_ietf_poly1305:
                        return "Chacha20-ietf-Poly1305"
                    case .none:
                        return "None"
                    case .plain:
                        return "Plain"
                    }
                }
            }
            public var address: String = ""
            public var port: Int = 443
            public var password: String = ""
            public var email: String = ""
            public var method = Method.none
            public var uot: Bool = false
            public var level: Int = 0
        }
        public var protocolType: ProtocolType
        public var vless = VLESS()
        public var vmess = VMess()
        public var trojan = Trojan()
        public var shadowsocks = Shadowsocks()
        public var streamSettings = StreamSettings()
        private enum CodingKeys: String, CodingKey {
            case protocolType = "protocol"
            case streamSettings
            case settings
            case vnext
            case servers
            case tag
        }
        init(protocolType: ProtocolType) {
            self.protocolType = protocolType
        }
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.protocolType = try container.decode(ProtocolType.self, forKey: .protocolType)
            self.streamSettings = try container.decode(StreamSettings.self, forKey: .streamSettings)
            let settings = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .settings)
            switch self.protocolType {
            case .vless:
                self.vless = try settings.decode([VLESS].self, forKey: .vnext)[0]
            case .vmess:
                self.vmess = try settings.decode([VMess].self, forKey: .vnext)[0]
            case .trojan:
                self.trojan = try settings.decode([Trojan].self, forKey: .servers)[0]
            case .shadowsocks:
                self.shadowsocks = try settings.decode([Shadowsocks].self, forKey: .servers)[0]
            }
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.protocolType, forKey: .protocolType)
            var settings = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .settings)
            switch self.protocolType {
            case .vless:
                try settings.encode([self.vless], forKey: .vnext)
            case .vmess:
                try settings.encode([self.vmess], forKey: .vnext)
            case .trojan:
                try settings.encode([self.trojan], forKey: .servers)
            case .shadowsocks:
                try settings.encode([self.shadowsocks], forKey: .servers)
            }
            try container.encode(self.streamSettings, forKey: .streamSettings)
            try container.encode("proxy", forKey: .tag)
        }
    }
}
