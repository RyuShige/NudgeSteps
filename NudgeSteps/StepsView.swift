//
//  ContentView.swift
//  steps
//
//  Created by 重富 on 2023/01/05.
//

import SwiftUI
import HealthKit

struct StepsView: View {
    
    private var healthStore: HealthStore?
    @State private var steps: [Step] = [Step]()
    @State var todayStep: CGFloat = 0
    @State var steps2: [CGFloat] = Array(repeating : 0, count : 7)
    @State private var refresh: Bool = false
    @AppStorage("aimStep") var aimStep = 10000

    init() {
        healthStore = HealthStore()
    }
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection) {
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
            todayStep = CGFloat(step.count)
            steps2.append(CGFloat(step.count))
        }
        steps2.removeSubrange(0...6)
        steps2.reverse()
        steps.reverse()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    CircularProgressView(step: steps2[1], maxStep: CGFloat(aimStep), color: Color.orange)
                        .frame(width:250, height:350)
                    
                    CircularProgressView(step: steps2[0], maxStep: CGFloat(aimStep), color: Color.green)
                        .frame(width:200, height:300)
                    
                    
                    VStack {
                        Text("\(Int(steps2[0]))")
                            .animation(.default, value: steps2[0])
                            .font(.largeTitle)
                        
                        Text("Steps")
                            .foregroundColor(.secondary)
                    }
                }

                NavigationView {
                    List(steps, id: \.id) { step in
                        VStack(alignment: .leading) {
                            Text("\(step.count)")
                            Text(step.date, style: .date)
                                .opacity(0.5)
                        }
                    }
                    .navigationTitle("Your Steps")
                }
                .onAppear {
                    if let healthStore = healthStore {
                        healthStore.requestAuthorization { success in
                            if success {
                                healthStore.calculateSteps { statisticsCollection in
                                    if let statisticsCollection = statisticsCollection {
                                        updateUIFromStatistics(statisticsCollection)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .refreshable {
            if let healthStore = healthStore {
                healthStore.requestAuthorization { success in
                    if success {
                        healthStore.calculateSteps { statisticsCollection in
                            if let statisticsCollection = statisticsCollection {
                                updateUIFromStatistics(statisticsCollection)
                            }
                        }
                    }
                }
            }
        }

    }
    
    struct StepsView_Previews: PreviewProvider {
        static var previews: some View {
            StepsView()
        }
    }
}

