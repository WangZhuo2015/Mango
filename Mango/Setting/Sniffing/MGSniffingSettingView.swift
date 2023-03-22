import SwiftUI

struct MGSniffingSettingView: View {
    
    @EnvironmentObject  private var packetTunnelManager:    MGPacketTunnelManager
    @ObservedObject     private var sniffingViewModel:      MGSniffingViewModel
    
    init(sniffingViewModel: MGSniffingViewModel) {
        self._sniffingViewModel = ObservedObject(initialValue: sniffingViewModel)
    }
    
    var body: some View {
        List {
            Section {
                Toggle("状态", isOn: $sniffingViewModel.enabled)
            }
            Section {
                HStack {
                    MGToggleButton(title: "HTTP",      isOn: $sniffingViewModel.httpEnabled)
                    MGToggleButton(title: "TLS",       isOn: $sniffingViewModel.tlsEnabled)
                    MGToggleButton(title: "QUIC",      isOn: $sniffingViewModel.quicEnabled)
                    MGToggleButton(title: "FAKEDNS",   isOn: $sniffingViewModel.fakednsEnabled)
                }
                .padding(.vertical, 4)
            } header: {
                Text("流量类型")
            } footer: {
                Text("当流量为指定类型时，按其中包括的目标地址重置当前连接的目标")
            }
            Section {
                ForEach(sniffingViewModel.excludedDomains, id: \.self) { domain in
                    Text(domain)
                        .lineLimit(1)
                        .swipeActions {
                            Button("删除", role: .destructive) {
                                sniffingViewModel.delete(domain: domain)
                            }
                        }
                }
                TextField("请输入需要排除的域名", text: $sniffingViewModel.domain)
                    .onSubmit {
                        sniffingViewModel.submitDomain()
                    }
            } header: {
                Text("排除域名")
            } footer: {
                Text("如果流量嗅探结果在这个列表中时，将不会重置目标地址")
            }
            Section {
                Toggle("仅使用元数据", isOn: $sniffingViewModel.metadataOnly)
            } footer: {
                Text("将仅使用连接的元数据嗅探目标地址")
            }
            Section {
                Toggle("仅用于路由", isOn: $sniffingViewModel.routeOnly)
            } footer: {
                Text("将嗅探得到的域名仅用于路由，代理目标地址仍为 IP")
            }
        }
        .onDisappear {
            self.sniffingViewModel.save {
                guard let status = packetTunnelManager.status, status == .connected else {
                    return
                }
                packetTunnelManager.stop()
                Task(priority: .userInitiated) {
                    do {
                        try await Task.sleep(for: .milliseconds(500))
                        try await packetTunnelManager.start()
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                }
            }
        }
        .navigationTitle(Text("流量嗅探"))
    }
}
