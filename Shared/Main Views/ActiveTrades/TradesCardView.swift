//
//  TradesCard.swift
//  Trading Tracker
//
//  Created by Brendan Reese on 1/3/22.
//

import SwiftUI

struct TradesCardView: View {
    
    var trade: OpenTrade
    @Binding var bindingColor: Int
    @State var stuckColor: Int = 0
    
    var body: some View {
        GeometryReader{ geo in
            ZStack(alignment: .top){
                Rectangle()
                    .frame(width: geo.size.width * 0.95, height: 105, alignment: .center)
                    .foregroundColor(getColor(stuckColor))
                    .border(getColor(stuckColor), width: 2)
                    .cornerRadius(15)
                
                Rectangle()
                    .frame(width: geo.size.width * 0.945, height: 95, alignment: .center)
                    .foregroundColor(Color.white)
                    .border(Color.white, width: 0)
                    .cornerRadius(15)
                    .offset(x: 0, y: 1)
                
                VStack{
                    HStack{
                        Text(trade.ticker ?? "Lost Data")
                            .offset(x: geo.size.width * 0.05, y: 0)
                            .font(.title2)
                        Spacer()
                        Text("\(trade.openDate?.month ?? "") \(trade.openDate?.get(.day, .month).day ?? -1)")
                            .offset(x: -geo.size.width * 0.05, y: 0)

                    }
                    Spacer()
                    HStack{
                        Text("\(String(format: "%.2f", trade.probability))% Probability")
                            .offset(x: geo.size.width * 0.1, y: 0)
                        Spacer()
                        Text("\(trade.expirationDate?.month ?? "") \(trade.expirationDate?.get(.day, .month).day ?? -1)")
                            .offset(x: -geo.size.width * 0.05, y: 0)
                    }.offset(x: 0, y: -10)
                }
                
            }.frame(maxWidth: .infinity, maxHeight: 105)
        }
        .frame(height: 105)
        .onAppear(perform: {
            stuckColor = bindingColor
            bindingColor += 1
        })
        .onTapGesture {
            print("expand \(trade.ticker ?? "LOST DATA")")
        }
    }
    
    func getColor(_ color: Int) -> Color {
        if color % 3 == 0 {
            return Color(red: 0.733333, green: 0.87, blue: 0.729)
        } else if color % 3 == 1 {
            return Color(red: 0.968, green: 0.804, blue: 0.46666)
        } else if color % 3 == 2 {
            return Color(red: 0.925, green: 0.745, blue: 0.902)
        }
        
        return Color(red: 0.733333, green: 0.87, blue: 0.729)
    }
}
