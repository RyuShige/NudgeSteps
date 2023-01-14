//
//  SettingsView.swift
//  steps
//
//  Created by 重富 on 2023/01/13.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("aimStep") var aimStep = 10000
    @State var aimStepDisplay = 10000
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Button(action: {aimStepDisplay -= 500}) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .tint(.green)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                    }
                    
                    VStack {
                        Text("\(aimStepDisplay)")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 48, weight: .bold))
                    }
                    
                    Button(action: {aimStepDisplay += 500}) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .tint(.green)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                    }
                }
                
                Text("Step/day")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    aimStep = aimStepDisplay
                    // 画面遷移させたいけどこれではならない
                    StepsView()
                }) {
                    Text("change Step Goal")
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 48)
                        .padding(.vertical, 12)
                        .background(
                            Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1))
                        .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle("Step Goal")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

