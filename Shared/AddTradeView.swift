//
//  AddTradeView.swift
//  Trading Tracker
//
//  Created by Brendan Reese on 12/30/21.
//

import SwiftUI
import UIKit
import Combine

struct AddTradeView: View {
    
    @Binding var isPresented: Bool
    @Binding var tradeViewHeight: CGFloat
    @State private var calendarId: Int = 0
    @State private var expirationAlert: Bool = false
    @State private var tickerAlert: Bool = false
    @State private var sellStrikeAlert: Bool = false
    @State private var buyStrikeAlert: Bool = false
    @State private var probabilityAlert: Bool = false
    @State private var creditAlert: Bool = false
    @State private var contractAlert: Bool = false
    
    @State private var ticker: String = ""
    @State private var openDate: Date = Date()
    @State private var expirationDate: Date = Date()
    @State private var sellStrikeAsString: String = String()
    @State private var buyStrikeAsString: String = String()
    @State private var probabilityAsString: String = String()
    @State private var creditAsString: String = String()
    @State private var contractsAsString: String = String()
    
    @Environment(\.managedObjectContext) var moc
    
    
    var body: some View {
        
        let tickerBinding = Binding<String>(
            get: {
                self.ticker
            }, set: {
                self.ticker = $0.uppercased()
            })
        
        return ZStack{
            VStack{
                Spacer()
                HStack {
                    Text("Add Trade").font(.title).bold()
                    Spacer()
                    Button(action: {
                        isPresented = false
                        clearInputs()
                        self.endTextEditing()
                    }) {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.gray).font(.system(size: 26))
                    }
                }.padding(.horizontal)
                
                
                ScrollView{
                    
                    Section{
                        HStack{
                            Text("Ticker")
                                .bold()
                            TextField("Enter ticker", text: tickerBinding, onEditingChanged:{ focused in
                                if focused{
                                    self.tradeViewHeight = 1.00
                                } else {
                                    self.tradeViewHeight = 0.75
                                }
                            })
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onReceive(Just(ticker)) { newValue in
                                    let filtered = newValue.filter { "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains($0) }
                                    if filtered != newValue {
                                        ticker = filtered
                                    }
                                }
                        }
                        .padding(.horizontal)
                    }
                    
                    Section{
                        HStack{
                            Spacer()
                            VStack{
                                Text("Open Date")
                                    .bold()
                                DatePicker(selection: $openDate, displayedComponents: .date){}
                                .labelsHidden()
                                .accentColor(Color(red: 1.00, green: 0.37, blue: 0.57))
                            }
                            Spacer()
                            VStack{
                                Text("Expiration Date")
                                    .bold()
                                DatePicker(selection: $expirationDate, displayedComponents: .date){}
                                .labelsHidden()
                                .accentColor(Color(red: 1.00, green: 0.37, blue: 0.57))
                                
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    Section{
                        HStack{
                            Text("Sell Strike")
                                .bold()
                            TextField("Enter Sell Strike", text: $sellStrikeAsString, onEditingChanged:{ focused in
                                if focused{
                                    self.tradeViewHeight = 1.00
                                } else {
                                    self.tradeViewHeight = 0.75
                                }
                            })
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }.padding(.horizontal)
                    }
                    
                    Section{
                        HStack{
                            Text("Buy Strike")
                                .bold()
                            TextField("Enter Buy Strike", text: $buyStrikeAsString, onEditingChanged:{ focused in
                                if focused{
                                    self.tradeViewHeight = 1.00
                                } else {
                                    self.tradeViewHeight = 0.75
                                }
                            })
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }.padding(.horizontal)
                    }
                    
                    Section{
                        HStack{
                            Text("Probability")
                                .bold()
                            TextField("Enter Probability", text: $probabilityAsString, onEditingChanged:{ focused in
                                if focused{
                                    self.tradeViewHeight = 1.00
                                } else {
                                    self.tradeViewHeight = 0.75
                                }
                            })
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }.padding(.horizontal)
                    }
                    
                    Section{
                        HStack{
                            Text("Credit")
                                .bold()
                            TextField("Enter Credit", text: $creditAsString, onEditingChanged:{ focused in
                                if focused{
                                    self.tradeViewHeight = 1.00
                                } else {
                                    self.tradeViewHeight = 0.75
                                }
                            })
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }.padding(.horizontal)
                    }
                    
                    Section{
                        HStack{
                            Text("Contracts")
                                .bold()
                            TextField("Enter Number of Contracts", text: $contractsAsString, onEditingChanged:{ focused in
                                if focused{
                                    self.tradeViewHeight = 1.00
                                } else {
                                    self.tradeViewHeight = 0.75
                                }
                            })
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }.padding(.horizontal)
                    }
                    
                    Section{
                        Button(action: {
                            printInputs()
                            
                            if !validateInputs(){
                                return
                            }
                            
                            saveTrade()
                            
                        }) {
                            Text("Submit Trade")
                        }
                        .padding()
                        .background(Color(red: 1.00, green: 0.37, blue: 0.57))
                        .foregroundColor(.white)
                        .cornerRadius(10.0)
                    }.offset(x: 0, y: 10)
                }
            }
            
            VStack(spacing: 0){
                Text("")
                    .alert(isPresented: self.$expirationAlert) {
                        Alert(title: Text("Incorrect Dates"), message: Text("Entered open date is after the expiration date. Please confirm the correct dates."))
                    }
                    .frame(width: 0, height: 0, alignment: .center)
                Text("")
                    .alert(isPresented: self.$tickerAlert) {
                        Alert(title: Text("Ticker Field Empty"), message: Text("Please enter a ticker."))
                    }
                    .frame(width: 0, height: 0, alignment: .center)
                Text("")
                    .alert(isPresented: self.$sellStrikeAlert) {
                        Alert(title: Text("Sell Strike Empty"), message: Text("Please enter a sell strike."))
                    }
                    .frame(width: 0, height: 0, alignment: .center)
                Text("")
                    .alert(isPresented: self.$buyStrikeAlert) {
                        Alert(title: Text("Buy Strike Empty"), message: Text("Please enter a buy strike."))
                    }
                    .frame(width: 0, height: 0, alignment: .center)
                Text("")
                    .alert(isPresented: self.$probabilityAlert) {
                        Alert(title: Text("Probability Empty"), message: Text("Please enter a probability."))
                    }
                    .frame(width: 0, height: 0, alignment: .center)
                Text("")
                    .alert(isPresented: self.$creditAlert) {
                        Alert(title: Text("Credits Empty"), message: Text("Please enter a credit."))
                    }
                    .frame(width: 0, height: 0, alignment: .center)
                Text("")
                    .alert(isPresented: self.$contractAlert) {
                        Alert(title: Text("Contracts Empty"), message: Text("Please enter the number of contracts."))
                    }
                    .frame(width: 0, height: 0, alignment: .center)
            }
        }
    }
    
    
    func saveTrade(){
        let trade = OpenTrade(context: moc)
        trade.ticker = ticker
        trade.openDate = openDate
        trade.expirationDate = expirationDate
        trade.sellStrike = sellStrikeAsString.floatValue
        trade.buyStrike = buyStrikeAsString.floatValue
        trade.probability = probabilityAsString.floatValue
        trade.credit = NSDecimalNumber(floatLiteral: creditAsString.doubleValue)
        trade.contracts = Int16(contractsAsString) ?? -1
        trade.dateAdded = Date()
        
        
        try? moc.save()
        print("saved")
        clearInputs()
        isPresented = false
        self.endTextEditing()
    }
    
    func clearInputs(){
        print("ticker: \(ticker)")
        print("opendate: \(openDate)")
        print("expirationdate: \(expirationDate)")
        print("sellstrike: \(sellStrikeAsString)")
        print("buystrike: \(buyStrikeAsString)")
        print("probabiity: \(probabilityAsString)")
        print("credits: \(creditAsString)")
        print("contracts: \(contractsAsString)")
        
        ticker = ""
        openDate = Date()
        expirationDate = Date()
        sellStrikeAsString = ""
        buyStrikeAsString = ""
        probabilityAsString = ""
        creditAsString = ""
        contractsAsString = ""
        
    }
    
    func validateInputs() -> Bool{
        if ticker == "" {
            self.tickerAlert.toggle()
            return false
        }
        if expirationDate < openDate {
            self.expirationAlert.toggle()
            return false
        }
        if sellStrikeAsString == "" {
            self.sellStrikeAlert.toggle()
            return false
        }
        if buyStrikeAsString == "" {
            self.buyStrikeAlert.toggle()
            return false
        }
        if probabilityAsString == "" {
            self.probabilityAlert.toggle()
            return false
        }
        if creditAsString == "" {
            self.creditAlert.toggle()
            return false
        }
        if contractsAsString == "" {
            self.contractAlert.toggle()
            return false
        }
        
        
        return true
    }
    
    func printInputs(){
        print("ticker: \(ticker)")
        print("opendate: \(openDate)")
        print("expirationdate: \(expirationDate)")
        print("sellstrike: \(sellStrikeAsString)")
        print("buystrike: \(buyStrikeAsString)")
        print("probabiity: \(probabilityAsString)")
        print("credits: \(creditAsString)")
        print("contracts: \(contractsAsString)")
    }
}
