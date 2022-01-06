//
//  ActiveTrades.swift
//  Trading Tracker
//
//  Created by Brendan Reese on 1/2/22.
//

import SwiftUI

struct ActiveTradesView: View {
    
    @FetchRequest(sortDescriptors: []) var trades: FetchedResults<OpenTrade>
    
    @State private var tradeColorType = 0
    
    var body: some View {
        
        ScrollView{
            ForEach(trades, id: \.self) { trade in
                TradesCardView(trade: trade, bindingColor: $tradeColorType)
            }
            //            Spacer()
        }
        
    }
}

struct ActiveTrades_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTradesView()
    }
}
