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
import Factory

struct ShieldsView: View {
    @ObservedObject var vm = ViewModels.packs
    @ObservedObject var tabVM = ViewModels.tab

    @Injected(\.stage) private var stage

    var body: some View {
        List {
            Text(L10n.familyShieldsHeader)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .listRowSeparator(.hidden)
            .padding([.leading, .trailing, .bottom])

            // List of shields
            ForEach(self.vm.packs, id: \.self) { pack in
                ZStack {
                    ShieldCardView(packsVM: self.vm, vm: PackDetailViewModel(packId: pack.id))
                }
                .listRowSeparator(.hidden)
//                .background(
//                    NavigationLink("", value: pack.id).opacity(0)
//                )
            }
            
            // My shield (custom exceptions)
            ZStack(alignment: .topLeading) {
                // Background
                ZStack {
                    Rectangle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color(UIColor.systemGray5), Color(UIColor.systemGray3)]),
                            startPoint: .bottomTrailing, endPoint: .leading
                        ))
                        .overlay(Color.cPrimaryBackground.blendMode(.color))
                }
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 10, y: 10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)

                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("CUSTOM")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color.secondary)
                        }
                        .padding(.top, 8)
                        
                        Text(L10n.userdeniedSectionHeader)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text(L10n.familyShieldsCustomSlug)
                            .font(.body)
                            .padding(.bottom, 16)
                            .foregroundColor(.primary)
                    }
                    .padding([.top, .leading, .trailing])

                    VStack {
                        Button(action: {
                            self.stage.showModal(.custom)
                        }) {
                            ZStack {
                                ButtonView(enabled: .constant(true), plus: .constant(true))
                                    .frame(height: 44)
                                Text(L10n.userdefinedActionOpen)
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                        .padding()
                    }
                    .background(.regularMaterial)
                    .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
                }
            }
            .listRowSeparator(.hidden)
            .padding(.bottom, 64)
            .fixedSize(horizontal: false, vertical: true)
        }
        .listStyle(PlainListStyle())
        .alert(isPresented: self.$vm.showError) {
            Alert(title: Text(L10n.alertErrorHeader), message: Text(L10n.errorPackInstall), dismissButton: .default(Text(L10n.universalActionClose)))
        }
    }
}

struct ShieldsView_Previews: PreviewProvider {
    static var previews: some View {
        ShieldsView()
    }
}
