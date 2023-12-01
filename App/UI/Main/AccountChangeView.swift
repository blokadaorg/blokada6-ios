//
//  This file is part of Blokada.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2023 Blocka AB. All rights reserved.
//
//  @author Kar
//

import SwiftUI
import CodeScanner
import Factory

struct AccountChangeView: View {
    @ObservedObject var vm = ViewModels.account
    @ObservedObject var contentVM = ViewModels.content
    @ObservedObject var homeVM = ViewModels.home
    
    @Environment(\.colorScheme) var colorScheme
    @Injected(\.commands) var commands
    
    @State var appear = false
    
    @State private var token: String = ""
    @State private var isShowingScanner = false

    func handleScan(result: Result<ScanResult, ScanError>) {
       self.isShowingScanner = false  // dismiss the scanner view
       
       switch result {
       case .success(let code):
           self.token = code.string
           self.commands.execute(CommandName.url, self.token)
       case .failure(let error):
           print("Scanning failed: \(error.localizedDescription)")
       }
   }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Attach device")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .padding([.top], 24)

                    Text("To link this device to the parent device, complete the setup process. Once linked, this device will be locked, allowing you to configure and monitor it from the parent device.")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .padding(.top, 24)
                    .padding(.bottom, 56)

                    HStack(spacing: 0) {
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                        .foregroundColor(Color.accentColor)
                        .padding(.trailing) 

                        VStack(alignment: .leading) {
                            Text("Scan QR code")
                            .fontWeight(.medium)
                            Text("Scan the QR code from the parent device, in order to initiate the linking process.")
                                .foregroundColor(.secondary)
                        }
                        .font(.subheadline)
                        .onTapGesture {
                            self.isShowingScanner = true
                        }
                        Spacer()
                    }
                    .padding(.bottom, 40)

                    Spacer()

                    VStack {
                        Button(action: {
                            self.isShowingScanner = true
                        }) {
                            ZStack {
                                ButtonView(enabled: .constant(true), plus: .constant(true))
                                    .frame(height: 44)
                                HStack {
                                    Image(systemName: "qrcode.viewfinder")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                    Text("Scan")
                                        .foregroundColor(.white)
                                        .bold()
                                }
                            }
                        }
                        .sheet(isPresented: self.$isShowingScanner) {
                            AccountChangeScanView(isShowingScanner: self.$isShowingScanner, handleScan: self.handleScan)
                        }
                    }
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: 500)
                .navigationBarItems(trailing:
                    Button(action: {
                        self.contentVM.stage.dismiss()
                    }) {
                        Text(L10n.universalActionDone)
                    }
                    .contentShape(Rectangle())
                )
            }
            .padding([.leading, .trailing], 40)
        }
        .opacity(self.appear ? 1 : 0)
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(Color.cAccent)
        .onAppear {
            self.appear = true
        }
    }
}

struct AccountChangeScanView: View {
    
    @Binding var isShowingScanner: Bool
    let handleScan: (Result<ScanResult, ScanError>) -> Void

    var body: some View {
        ZStack {
            CodeScannerView(codeTypes: [.qr], simulatedData: "mockedmocked", completion: self.handleScan)
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        self.isShowingScanner = false
                    }) {
                        ZStack {
                            Text(L10n.universalActionClose)
                                .foregroundColor(.cAccent)
                        }
                        .padding()
                    }
                }
                .background(Color.black.opacity(0.5))

                Spacer()
            }
            
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
                .foregroundColor(Color.black.opacity(0.5))
                .frame(width: 240, height: 240)
        }
    }
}

struct AccountChangeView_Previews: PreviewProvider {
    static var previews: some View {
        AccountChangeView()
        AccountChangeScanView(isShowingScanner: .constant(true), handleScan: {scan in })
    }
}
