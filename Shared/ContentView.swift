//
//  ContentView.swift
//  Shared
//
//  Created by Brendan Reese on 12/29/21.
//

import SwiftUI
import BottomSheet

struct ContentView: View {
    
    @State private var selectedIndex = 1
    @State private var isPresented = false
    
    @State private var addTradeHeight:CGFloat = 0.75

    
    @Environment(\.colorScheme) var colorScheme
    
    let tabBarItemNames = ["chart.pie.fill", "chart.bar.fill", "plus.circle.fill", "arrow.counterclockwise.icloud.fill", "dollarsign.circle.fill"]
    
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                ZStack{
                    switch selectedIndex{
                    case 0:
                        NavigationView{
                            StatisticsView()
                                .navigationTitle("Statistics")
                        }
                    case 1:
                        NavigationView{
                            ActiveTradesView()
                                .navigationTitle("Active Trades")
                        }
                        
                    case 2:
                        Text("test")
                        
                    case 3:
                        NavigationView{
                            Text("Fourth")
                                .navigationTitle("Transaction History")
                        }
                        
                    case 4:
                        NavigationView{
                            CompoundView()
                                .navigationTitle("Calculate Compound")
                            
                        }
                    default:
                        Text("error")
                        
                    }
                }
                Spacer()
                HStack{
                    ForEach(0 ..< 5){ num in
                        Button(action: {
                            if num == 2{
                                isPresented = true
                                let haptic = UIImpactFeedbackGenerator(style: .heavy)
                                haptic.impactOccurred()
                            } else{
                                selectedIndex = num
                            }
                        }, label: {
                            Spacer()
                            
                            if num == 2{
                                Image(systemName: tabBarItemNames[num])
                                    .font(.system(size: 47, weight: .bold))
                                    .foregroundColor(Color(red: 1.00, green: 0.37, blue: 0.57))
                            } else {
                                Image(systemName: tabBarItemNames[num])
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(selectedIndex == num ? Color(red: 1.00, green: 0.37, blue: 0.57) : .init(white: 0.8))
                            }
                            
                            Spacer()
                        })
                    }
                }.padding()
            }
            
            .bottomSheet(
                isPresented: $isPresented,
                height: geo.size.height * addTradeHeight,
                topBarHeight: 16,
                topBarCornerRadius: 16,
                contentBackgroundColor: colorScheme == .dark ? Color.white : Color(.systemBackground),
                topBarBackgroundColor:  colorScheme == .dark ? Color.white : Color(.systemBackground),
                showTopIndicator: true
            ) {
                AddTradeView(isPresented: self.$isPresented, tradeViewHeight: self.$addTradeHeight)
            }.onTapGesture {
                self.endTextEditing()
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
