import SwiftUI
import CoreData
import SpriteKit
import Combine

// Enumeration that defines each section of buttons
enum GameSection {
    case main, finances, job, relationships, education, assets, city, casino, blackjack, bank, loans, buy_stocks
}

struct GameView: View, Hashable {
    
    // Observes changes to PlayerData instance
    @ObservedObject var player: PlayerData
    // Initializes current game section to being in the main section
    @State private var currentSection: GameSection = .main
    @State private var showPlayerData = false
    @StateObject private var blackjackScene = BlackjackScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    @State private var betAmount: Int = 0
    @State private var loanMessage: String = ""
    
   
    var body: some View {
        VStack(spacing: 0) {
            
            ///#======= HEADER CONTENT CONTAINER ============
            ZStack {
                Color.red
                    .ignoresSafeArea()
                Text("LifeSim")
                    .font(.custom("AvenirNext-Bold", size: 42))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding(.top)
            }
            .zIndex(1)
            .frame(height: UIScreen.main.bounds.height * 0.15)
            
            ///#======= SPRITEKIT CONTENT CONTAINER ============
            ZStack {
                VStack {
                    if currentSection == .blackjack {
                        SpriteView(scene: blackjackScene)
                            .onAppear {
                                blackjackScene.scaleMode = .resizeFill
                            }
                    } else {
                        SpriteView(scene: GameScene(size: CGSize(width: 300, height: 300), playerName: player.playerName ?? "Unknown", gender: player.gender ?? "Male"))
                    }
                }
                
            }
            .frame(height: UIScreen.main.bounds.height * 0.40)
            
            ///#======= BUTTON NAVIGATION CONTAINER ============
            ZStack {
                Color.blue
                // Content Goes Here
                if currentSection == .main {
                    mainButtons()
                } else {
                    navigationButtons()
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.45)
        }
        .sheet(isPresented: $showPlayerData, content: {
            AssetView(player: player)
        })
        // Disables navigation back to HomeView
        .navigationBarBackButtonHidden(true)
    }
    
    
    
    
    
    
    ///# ============= PROTOCOL CONFORMING =============

    // Conforms to Equatable Protocol
    static func == (lhs: GameView, rhs: GameView) -> Bool {
        return lhs.player.objectID == rhs.player.objectID
    }
    // Conforms to Hashable Protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(player.objectID)
    }
    
    func savePlayerBalance(context: NSManagedObjectContext, player: PlayerData) {
        let fetchRequest: NSFetchRequest<PlayerData> = PlayerData.fetchRequest()
        
        do {
            let players = try context.fetch(fetchRequest)
            if let currentPlayer = players.first {
                
                currentPlayer.playerBalance = player.playerBalance
                currentPlayer.stockBalance = player.stockBalance
                currentPlayer.hasStock = player.hasStock
                
                // Save the context
                try context.save()
                print("\nPlayer balance saved: \(player.playerBalance)")
                print("Player stock balance saved: \(player.stockBalance)")
                print("Player hasStock saved: \(player.hasStock)")
                print("Player debt balance saved: \(player.debt)")
                
                
            } else {
                print("Player not found in Core Data")
            }
        } catch {
            print("Failed to fetch or save player: \(error.localizedDescription)")
        }
    }




    
    ///# ============= DEFINES BUTTON NAVIGATION =============
    func navigationButtons() -> some View {
        VStack {
            if currentSection == .finances {
                financeButtons()
            } else if currentSection == .job {
                careerButtons()
            } else if currentSection == .relationships {
                relationshipsButtons()
            } else if currentSection == .education {
                educationButtons()
            } else if currentSection == .assets {
                assetsButtons()
            } else if currentSection == .city {
                cityButtons()
            } else if currentSection == .casino {
                casinoButtons()
            } else if currentSection == .blackjack {
                blackjackButtons()
            } else if currentSection == .bank {
                bankButtons(player: player)
            } else if currentSection == .loans {
                loanButtons(player: player)
            } else if currentSection == .buy_stocks {
                buyStockButtons(player: player)
            }
        }
    }
    ///# ============= DEFINES MAIN BUTTON SET =============
    func mainButtons() -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        return LazyVGrid(columns: columns, spacing: 20) {
            ForEach(["Career", "Finances", "Relationships", "Education", "Assets", "City"], id: \.self) { title in
                Button(action: {
                    switch title {
                    case "Career":
                        currentSection = .job
                    case "Finances":
                        currentSection = .finances
                    case "Relationships":
                        currentSection = .relationships
                    case "Education":
                        currentSection = .education
                    case "Assets":
                        currentSection = .assets
                    case "City":
                        currentSection = .city
                    default:
                        break
                    }
                }) {
                    Text(title)
                        .font(.custom("AvenirNext-Bold", size: 22))
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .background(Color.cyan)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .frame(maxWidth: .infinity) // Ensure the button spans the width
            }
        }
        .padding()
    }
    
    ///# =====================================================
    ///# ============= DEFINES FINANCE BUTTON SET ============
    ///# =====================================================
    
    func financeButtons() -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 20) {
            Button(action: { currentSection = .main }) {
                Text("Back to Main")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { currentSection = .casino }) {
                Text("Go to Casino")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { currentSection = .bank }) {
                Text("Go to Bank")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { currentSection = .buy_stocks }) {
                Text("Invest")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
    }
    
    @State private var showLoanAlert = false
    @State private var loanAmount: Double = 0
    @State private var interestRate: Double = 0

    func determineLoanAmount(playerBalance: Double) {
        if playerBalance < 1000 {
            loanAmount = 500
            interestRate = 0.12
        } else if playerBalance >= 1000 && playerBalance < 5000 {
            loanAmount = playerBalance * 3
            interestRate = 0.10
        } else if playerBalance >= 5000 && playerBalance < 20000 {
            loanAmount = playerBalance * 2.5
            interestRate = 0.08
        } else if playerBalance >= 20000 && playerBalance < 50000 {
            loanAmount = playerBalance * 2
            interestRate = 0.07
        } else if playerBalance >= 50000 {
            loanAmount = playerBalance * 1.5
            interestRate = 0.06
        }
        showLoanAlert = true
    }



    func bankButtons(player: PlayerData) -> some View {
        let columns = [GridItem(.flexible())]
        return VStack {
            // Balance Display Container
            HStack {
                Text("Balance: $\(Int(player.playerBalance))")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .padding()
            }
            .frame(maxWidth: 250, minHeight: 30)
            .background(Color(red: 40 / 255, green: 40 / 255, blue: 40 / 255))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // LazyVGrid for Bank Buttons
            LazyVGrid(columns: columns, spacing: 20) {
                Button(action: { currentSection = .finances }) {
                    Text("Back to Finances")
                        .font(.custom("AvenirNext-Bold", size: 22))
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)
                        .padding()
                        .frame(maxWidth: 250, minHeight: 80, maxHeight: 80)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                Button(action: { determineLoanAmount(playerBalance: player.playerBalance)
                    if player.hasLoan {
                        loanMessage = "Ready to pay your $\(Int(player.debt).formatted()) debt?"
                    } else {
                        loanMessage = "You qualify for a loan of $\(Int(loanAmount).formatted()). Would you like to claim it?\nReturn in 12 months\nInterest Rate: \(Int(interestRate * 100))%"
                    }

                    currentSection = .loans
                }) {
                    Text("Bank Loan")
                        .font(.custom("AvenirNext-Bold", size: 22))
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)
                        .padding()
                        .frame(maxWidth: 250, minHeight: 80, maxHeight: 80)
                        .background(Color.cyan)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
        }
    }

    @State private var disableLoanButtons: Bool = false

    func loanButtons(player: PlayerData) -> some View {
        
        return VStack(spacing: 20) {
            HStack {
                Text(loanMessage)
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .padding()
            }
            .frame(maxWidth: 400, minHeight: 200, maxHeight:200)
            .background(Color(red: 40 / 255, green: 40 / 255, blue: 40 / 255))
            .cornerRadius(10)
            .padding(.horizontal)

            // HStack for Loan Buttons
            HStack(spacing: 65) { // Add spacing between buttons
                Button(action: {
                    
                    loanMessage = "Thank you for coming! Hope to see you again."
                    disableLoanButtons = true
                    if(player.hasLoan && player.debt <= player.playerBalance){
                        // Player has loan and can pay it off
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                            disableLoanButtons = false
                            player.playerBalance -= player.debt
                            player.loanInterest = 0
                            player.debt = 0
                            player.hasLoan = false
                            savePlayerBalance(context: viewContext, player: player)
                            currentSection = .bank
                        }
                    } else if(player.hasLoan && player.debt > player.playerBalance) {
                        // Player has loan but does not have enough money to pay if off
                        loanMessage = "You do not have sufficient funds. Please come again later"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                            disableLoanButtons = false
                            currentSection = .bank
                        }
                    } else if(!player.hasLoan){
                        // Player does not have loan and accepts loan
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                            disableLoanButtons = false
                            player.loanInterest = interestRate
                            player.debt += loanAmount
                            player.playerBalance += loanAmount
                            player.hasLoan = true
                            savePlayerBalance(context: viewContext, player: player)
                            currentSection = .bank
                        }
                    }
                }) {
                    Text("Yes")
                        .font(.custom("AvenirNext-Bold", size: 22))
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)
                        .padding()
                        .frame(maxWidth: 125, minHeight: 80, maxHeight: 80)
                        .background(Color.green)
                        .opacity(disableLoanButtons ? 0.5 : 1)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .disabled(disableLoanButtons)
                
                Button(action: {
                    currentSection = .bank
                }) {
                    Text("No")
                        .font(.custom("AvenirNext-Bold", size: 22))
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)
                        .padding()
                        .frame(maxWidth: 125, minHeight: 80, maxHeight: 80)
                        .background(Color.red)
                        .opacity(disableLoanButtons ? 0.5 : 1)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .disabled(disableLoanButtons)
                
            }
        }
    }
    
    @State var percentageChange: Double = 0

    func determineStock(player: PlayerData) {
        var successRate: Double
        
        switch player.intelligence {
        case 10:
            successRate = 0.90 // Max Success Rate
        case 7...9:
            successRate = 0.8 // High Success Rate
        case 4...6:
            successRate = 0.70 // Moderate Success Rate
        case 1...3:
            successRate = 0.45 // Low Success Rate
        default:
            successRate = 0.0
        }
        print(successRate)

        let randomOutcome = Double.random(in: 0...1)
        
        if randomOutcome < successRate {
            percentageChange = Double.random(in: 0.01...0.10) // Random increase of 1% to 10%
            player.stockBalance *= (1 + percentageChange)
        } else {
            // Unsuccessful period: Decrease stock balance by a random percentage
            percentageChange = -Double.random(in: 0.01...0.10) // Random decrease of 1% to 10% // Random decrease of 1% to 10%
            player.stockBalance *= (1 + percentageChange)
        }
    }


    @State private var stockAmount: Double = 0

    func buyStockButtons(player: PlayerData) -> some View {
        var chosenStock: String
        var stockMessage: String
        
        switch player.intelligence {
        case 10:
            chosenStock = "AAPL"
            stockMessage = "You have decided to invest in Apple! This tech giant will not let you down."
        case 7...9:
            chosenStock = "TSLA"
            stockMessage = "You have decided to invest in Tesla! You have put your faith in the future of EVs."
        case 4...6:
            chosenStock = "BTC"
            stockMessage = "You have decided to invest in Bitcoin! You fully believe in the pioneer of cryptocurrency."
        case 1...3:
            chosenStock = "DOGE"
            stockMessage = "You have decided to invest in DOGE coin! You are willing to risk it all for the meme!"
        default:
            chosenStock = "N/A"
            stockMessage = "No valid stock."
        }
        
        return VStack(spacing: 20) {
            if player.hasStock {
                VStack {
                    VStack {
                        HStack {
                            Text(chosenStock)
                                .font(.custom("AvenirNext-Bold", size: 24))
                                .foregroundColor(Color.white)
                            if(percentageChange > 0){
                                Text("(\(String(format: "%.2f", percentageChange))%)")
                                    .font(.custom("AvenirNext-Bold", size: 18))
                                    .foregroundColor(Color.green)
                            } else {
                                Text("(\(String(format: "%.2f", percentageChange))%)")
                                    .font(.custom("AvenirNext-Bold", size: 18))
                                    .foregroundColor(Color.red)
                            }
                            
                        }
                        Text("Investment: $\(Int(player.stockBalance))")
                            .font(.custom("AvenirNext-Bold", size: 22))
                            .foregroundColor(Color.white)
                        
                        Text("\(stockMessage)")
                            .font(.custom("AvenirNext-Bold", size: 18))
                            .foregroundColor(Color.white)
                            .padding()
                    }
                    .frame(minWidth: 350, maxWidth: 350, minHeight: 200, maxHeight: 200)
                    .background(Color(red: 40 / 255, green: 40 / 255, blue: 40 / 255))
                    .cornerRadius(10)
                    
                    
                    HStack {
                        Button(action: {
                            // Action to navigate back to finances
                            currentSection = .finances
                        }) {
                            Text("Hold")
                                .font(.custom("AvenirNext-Bold", size: 22))
                                .foregroundColor(Color.white)
                                .shadow(radius: 5)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        }
                        .frame(maxWidth: 100, minHeight: 60, maxHeight: 60)
                        
                        Button(action: {
                            player.playerBalance += player.stockBalance
                            player.stockBalance = 0
                            player.hasStock = false
                            savePlayerBalance(context: viewContext, player: player)
                        }) {
                            Text("Sell")
                                .font(.custom("AvenirNext-Bold", size: 22))
                                .foregroundColor(Color.white)
                                .shadow(radius: 5)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        }
                        .frame(minWidth: 100, minHeight: 60, maxHeight: 60)
                    }
                }
            } else {
                HStack {
                    Text("Invest")
                        .font(.custom("AvenirNext-Bold", size: 28))
                        .foregroundColor(Color.white)
                        .shadow(radius: 10)
                }
                HStack {
                    Text("Balance: \(Int(player.playerBalance))")
                        .font(.custom("AvenirNext-Bold", size: 22))
                        .foregroundColor(Color.white)
                }
                .frame(minWidth: 350, maxWidth: 350, minHeight: 70)
                .background(Color(red: 40 / 255, green: 40 / 255, blue: 40 / 255))
                .cornerRadius(10)
                
                // Amount Selection
                HStack {
                    Button(action: {
                        // Decrease stock amount, only reduce from 100 to 0
                        if stockAmount == 100 {
                            stockAmount = 0
                        } else {
                            stockAmount /= 10
                        }
                    }) {
                        Text("<")
                            .font(.custom("AvenirNext-Bold", size: 32))
                            .shadow(radius: 5)
                            .padding()
                            .foregroundColor(stockAmount == 0 ? Color.white.opacity(0.5) : Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .disabled(stockAmount == 0)
                    
                    Text("$\(Int(stockAmount))")
                        .font(.custom("AvenirNext-Bold", size: 22))
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 24)  // Adjust padding to ensure centering
                        .frame(minWidth: 50, alignment: .center)  // Ensure minimum width for centering
                    
                    Button(action: {
                        // Increase stock amount
                        if stockAmount == 0 {
                            stockAmount = 100
                        } else {
                            stockAmount = min(stockAmount * 10, 1_000_000)
                        }
                    }) {
                        Text(">")
                            .font(.custom("AvenirNext-Bold", size: 32))
                            .shadow(radius: 5)
                            .padding()
                            .foregroundColor(((stockAmount == 0 ? 100 : stockAmount * 10) > player.playerBalance || stockAmount >= 1_000_000) ? Color.gray.opacity(0.5) : Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .disabled((stockAmount == 0 ? 100 : stockAmount * 10) > player.playerBalance || stockAmount >= 1_000_000)
                }
                .frame(minWidth: 350, maxWidth: 350, minHeight: 75)
                .background(Color(red: 40 / 255, green: 40 / 255, blue: 40 / 255))
                .cornerRadius(10)
                .padding(.horizontal)

                // LazyVGrid for Buttons
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    // Back Button
                    Button(action: {
                        // Action to navigate back to finances
                        currentSection = .finances
                        stockAmount = 0
                    }) {
                        Text("Back")
                            .font(.custom("AvenirNext-Bold", size: 22))
                            .foregroundColor(Color.white)
                            .shadow(radius: 5)
                            .padding()
                            .frame(maxWidth: 150, minHeight: 60, maxHeight: 60)
                            .background(Color.red)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    
                    // Buy Stocks Button
                    Button(action: {
                        // Action to buy stocks
                        player.stockBalance += stockAmount
                        player.playerBalance -= stockAmount
                        player.hasStock = true
                        savePlayerBalance(context: viewContext, player: player)
                    }) {
                        Text("Invest")
                            .font(.custom("AvenirNext-Bold", size: 22))
                            .shadow(radius: 5)
                            .padding()
                            .frame(maxWidth: 150, minHeight: 60, maxHeight: 60)
                            .background((stockAmount == 0 || stockAmount > player.playerBalance) ? Color.cyan.opacity(0.5) : Color.cyan)
                            .foregroundColor((stockAmount == 0 || stockAmount > player.playerBalance) ? Color.white.opacity(0.5) : Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .disabled(stockAmount == 0 || stockAmount > player.playerBalance)
                    
                }
            }
        }
    }








    
    // Casino Button Set
    func casinoButtons() -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 20) {
            Button(action: { currentSection = .finances }) {
                Text("Back to Finances")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            
            Button(action: {
                print("Play Blackjack")
                currentSection = .blackjack
            }) {
                Text("Play Blackjack")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
    }
    
    @State private var hitPressed: Bool = false
    @State private var hitDisabled: Bool = false
    @State private var backDisabled: Bool = false
    @State private var standDisabled: Bool = false
    @State private var betButtonsDisabled: Bool = false
    @State private var shouldUpdate: Bool = false
    @Environment(\.managedObjectContext) private var viewContext


    func blackjackButtons() -> some View {
        VStack(spacing: 20) {
            // Bet Display Container
            HStack {
                Text("Bet: \(betAmount)             Balance: \(Int(player.playerBalance))")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .padding()
            }
            .frame(maxWidth: .infinity, minHeight: 30)
            .background(Color(red: 40 / 255, green: 40 / 255, blue: 40 / 255))
            .cornerRadius(10)
            .padding(.horizontal)

            // Increment and Cancel Buttons Container
            HStack(spacing: 20) {
                // 10 Button
                Button(action: { betAmount += 10 }) {
                    Text("10")
                        .font(.custom("AvenirNext-Bold", size: 22))
                        .foregroundColor(Color.black)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(radius: 10)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.cyan, lineWidth: 10)
                        )
                        .shadow(radius: 10)
                }
                .disabled(player.playerBalance < Double(betAmount + 10) || betButtonsDisabled)
                .opacity(player.playerBalance < Double(betAmount + 10) || betButtonsDisabled ? 0.5 : 1.0)

                // 50 Button
                Button(action: { betAmount += 50 }) {
                    Text("50")
                        .font(.custom("AvenirNext-Bold", size: 22))
                        .foregroundColor(Color.black)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(radius: 10)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.green, lineWidth: 10)
                        )
                        .shadow(radius: 10)
                }
                .disabled(player.playerBalance < Double(betAmount + 50) || betButtonsDisabled)
                .opacity(player.playerBalance < Double(betAmount + 50) || betButtonsDisabled ? 0.5 : 1.0)

                // 100 Button
                Button(action: { betAmount += 100 }) {
                    Text("100")
                        .font(.custom("AvenirNext-Bold", size: 22))
                        .foregroundColor(Color.black)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(radius: 10)
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 10)
                            )
                        .shadow(radius: 10)
                }
                .disabled(player.playerBalance < Double(betAmount + 100) || betButtonsDisabled)
                .opacity(player.playerBalance < Double(betAmount + 100) || betButtonsDisabled ? 0.5 : 1.0)

                // Cancel Button
                Button(action: { betAmount = 0 }) {
                    Text("X")
                        .font(.custom("AvenirNext-Bold", size: 22))
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)
                        .padding()
                        .frame(minWidth: 40, maxHeight: 40)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            .padding(.horizontal)
            
            // Existing Buttons
            let columns = [GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: columns, spacing: 20) {
                
                
                Button(action: {
                    currentSection = .casino
                }) {
                    Text("Back")
                        .font(.custom("AvenirNext-Bold", size: 18))
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)
                        .padding()
                        .frame(maxWidth: 150, minHeight: 50, maxHeight: 50)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .disabled(backDisabled)
                .opacity(backDisabled ? 0.5 : 1.0)


                Button(action: {
                    var updateRequired = false
                    blackjackScene.hit(betAmount: betAmount, player: player, shouldUpdate: &updateRequired)
                    hitPressed = true
                    backDisabled = true
                    standDisabled = false
                    betButtonsDisabled = true

                    if updateRequired {
                        standDisabled = true
                        hitDisabled = true
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                            betButtonsDisabled = false
                            hitDisabled = false
                            backDisabled = false
                            betAmount = 0
                            updateRequired = false
                        }
                    }
                }) {
                    Text("Hit")
                        .font(.custom("AvenirNext-Bold", size: 18))
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)
                        .padding()
                        .frame(maxWidth: 150, minHeight: 50, maxHeight: 50)
                        .background(Color.cyan)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .disabled(betAmount == 0)
                .disabled(betAmount == 0 || hitDisabled)
                .opacity(betAmount == 0 || hitDisabled ? 0.5 : 1.0)

                Button(action: {
                    blackjackScene.stand(betAmount: betAmount, player: player)
                    betAmount = 0
                    standDisabled = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                        savePlayerBalance(context: viewContext, player: player)
                        betButtonsDisabled = false
                        hitDisabled = false
                        backDisabled = false
                        
                    }
                }) {
                    Text("Stand")
                        .font(.custom("AvenirNext-Bold", size: 18))
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)
                        .padding()
                        .frame(maxWidth: 150, minHeight: 50, maxHeight: 50)
                        .background(Color.cyan)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .disabled(!hitPressed || standDisabled)
                .opacity(!hitPressed || standDisabled ? 0.5 : 1.0)
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    ///# =====================================================
    ///# ============= DEFINES CAREER BUTTON SET =============
    ///# =====================================================
    
    func careerButtons() -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 20) {
            Button(action: { currentSection = .main }) {
                Text("Back to Main")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { print("Career Action 1") }) {
                Text("Career Action 1")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { print("Career Action 2") }) {
                Text("Career Action 2")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
    }
    
    ///# ============= DEFINES RELATIONSHIPS BUTTON SET =============
    func relationshipsButtons() -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 20) {
            Button(action: { currentSection = .main }) {
                Text("Back to Main")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { print("Relationships Action 1") }) {
                Text("Relationships Action 1")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { print("Relationships Action 2") }) {
                Text("Relationships Action 2")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
    }
    
    ///# ============= DEFINES EDUCATION BUTTON SET =============
    func educationButtons() -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 20) {
            Button(action: { currentSection = .main }) {
                Text("Back to Main")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { print("Education Action 1") }) {
                Text("Education Action 1")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { print("Education Action 2") }) {
                Text("Education Action 2")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
    }
    
    ///# ============= DEFINES ASSETS BUTTON SET =============
    func assetsButtons() -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 20) {
            Button(action: { currentSection = .main }) {
                Text("Back to Main")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: {
             showPlayerData = true
            }) {
                Text("Player Data")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
    }
    ///# ============= DEFINES CITY BUTTON SET =============
    func cityButtons() -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 20) {
            Button(action: { currentSection = .main }) {
                Text("Back to Main")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            
            NavigationLink {
                GymView(player: player)
            } label: { 
                Text("Gym")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }

            NavigationLink {
                DoctorsView(player: player)
            } label: {
                Text("Doctors")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            NavigationLink {
                VacationView(player: player)
            } label: {
                Text("Vacation")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
    }
}///# ============= END OF BUTTON NAVIGATION =============




// Assuming GameView is the main view you want to preview
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        // Creating a sample PlayerData instance for preview purposes
        let newPlayer = PlayerData(context: context)
        newPlayer.playerName = "Jane"
        newPlayer.gender = "Female"
        newPlayer.intelligence = 8
        newPlayer.playerBalance = 100
        newPlayer.saveDate = Date()
        newPlayer.hasLoan = false
        newPlayer.debt = 0
        newPlayer.hasStock = false
        newPlayer.stockBalance = 0
        
        
        return GameView(
            player: newPlayer
        )
            .environment(\.managedObjectContext, context)
    }
}
