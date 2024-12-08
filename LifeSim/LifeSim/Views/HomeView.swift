import SwiftUI
import CoreData
struct HomeView: View {
    
    // Fetches CoreData context from environment
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        // Fetches PlayerData entity
        entity: PlayerData.entity(),
        // Sorts instances of PlayerData by save date
        sortDescriptors: [NSSortDescriptor(keyPath: \PlayerData.saveDate, ascending: false)],
        animation: .default)
    // Fetched Results stored in variable `players`
    private var players: FetchedResults<PlayerData>
    
    @State private var message: String = ""
    @State private var overwriteAlert = false
    @State private var noSaveGameAlert = false
    @State private var animateGradient: Bool = false
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                
                // Linear Gradient Background Animation
                LinearGradient(colors: [Color(red: 18/255, green: 32/255, blue: 47/255), Color.black], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .hueRotation(.degrees(animateGradient ? 45 : 0))
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            animateGradient.toggle()
                        }
                    }

                VStack {
                    
                    // Replace the Test Text Box with LifeSim
                    Text("LifeSim")
                        .font(.custom("AvenirNext-Bold", size: 48))
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)
                        .padding()

                    // Add the image under the LifeSim text
                    Image("earth_image")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 350)
                        .padding()
                        .opacity(0.7) // Adjust the opacity value as needed
                        .shadow(color: Color.white, radius: 10, x: 0, y: 0) // Add white shadow

                    HStack {
                        // New Game Button
                        Button(action: checkForExistingSave) {
                            Text("New Game")
                                .font(.custom("AvenirNext-Bold", size: 16))
                                .foregroundColor(Color.white)
                                .shadow(radius: 5)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)

                        // Load Game Button
                        Button(action: loadGame) {
                            Text("Load Game")
                                .font(.custom("AvenirNext-Bold", size: 16))
                                .foregroundColor(Color.white)
                                .shadow(radius: 5)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .onTapGesture {
                            // If there is no game save to load
                            if players.isEmpty {
                                noSaveGameAlert = true // No Saved Game Alert
                            } else { // Game save found
                                loadGame()
                            }
                        }
                        // Alerts player that they do not have a saved game
                        .alert(isPresented: $noSaveGameAlert) {
                            Alert(
                                title: Text("No Saved Games"),
                                message: Text("Choose the New Game Button."),
                                dismissButton: .default(Text("Ok"))
                            )
                        }
                    }
                    .padding()
                    
                    // Alerts player that they are about to Overwrite a saved game
                    .alert(isPresented: $overwriteAlert) {
                        Alert(
                            title: Text("Overwrite Save"),
                            message: Text("Creating New Game will Overwrite your Previous Save. Do you wish to Continue?"),
                            primaryButton: .destructive(Text("Yes")) {
                                showCharacterCreationView()
                                message.append("--[NEWGAME]--")
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .padding()
                .onAppear {
                    // TEST purposes only:
                    // Displays player's saved game data to test text box
                    if let firstPlayer = players.first {
                        // Formats date and stores formatted date into formattedDate
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .short
                        let formattedDate = dateFormatter.string(from: firstPlayer.saveDate ?? Date())
                        // Displays current Saved Game
                        message.append("Saved Game Data: \(firstPlayer.playerName ?? "") on \(formattedDate)")
                    } else {
                        // Displays that there are no saved games
                        message.append("No saved game data found")
                    }
                }

                // Navigation link to LeaderboardView
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: LeaderboardView()) {
                            Text("🏆")
                                .font(.largeTitle)
                                .padding()
                                .background(Color.white.opacity(0.5))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
            }
            // Defines destination view when navigating to CreateCharacterView
            .navigationDestination(for: CreateCharacterView.self) { destination in
                destination
            }
            // Defines destination view when navigating to GameView
            .navigationDestination(for: GameView.self) { destination in
                destination
            }
        }
    }




 // End of Body View

    // Function checks if game save exists
    func checkForExistingSave() {
        // If no game save
        if !players.isEmpty { // Display Alert
            overwriteAlert = true
        } else { // Else navigate to Character Creation
            showCharacterCreationView()
        }
    }
    
    // Function navigates user to CreateCharacterView
    func showCharacterCreationView() {
        path.append(CreateCharacterView(navigateToGame: .constant(false), startNewGame: startNewGame))
    }

    // Function loads saved game and navigates to main game UI
    func loadGame() {
        // If saved game exists
        if let firstPlayer = players.first {
            // Navigates to GameView with specified player data
            path.append(GameView(player: firstPlayer))
            
        } else { // Else no saved game exists
            noSaveGameAlert = true // Displays alert
        }
    }
    
    // Function creates a new saved game and PlayerData entity
    func startNewGame(playerName: String, gender: String?, intelligence: Int, charisma: Int, luck: Int) {
        // Defines instance of PlayerData entity
        let newPlayer = PlayerData(context: viewContext)
        
        // Sets Player's initial attributes
        newPlayer.playerName = playerName
        newPlayer.gender = gender
        newPlayer.intelligence = Int16(intelligence)
        newPlayer.charisma = Int16(charisma)
        newPlayer.luck = Int16(luck)
        newPlayer.saveDate = Date()
        newPlayer.playerBalance = 0
        newPlayer.health = 100
        newPlayer.stress = 0
        newPlayer.playerAge = 21
        newPlayer.debt = 0
        newPlayer.loanInterest = 0
        newPlayer.hasLoan = false
        newPlayer.hasStock = false
        newPlayer.stockBalance = 0
        
        // Sets Player's time attributes
        newPlayer.currentInterval = 0
        newPlayer.timeUsed = 0
        
        // Prints New Player Attributes to Console
        print("Player Name: \(playerName), Save Date: \(newPlayer.saveDate ?? Date()), Gender: \(gender ?? "Not selected"), Intelligence: \(intelligence), Charisma: \(charisma), Luck: \(luck), Player Balance: \(newPlayer.playerBalance), Health: \(newPlayer.health), Stress: \(newPlayer.stress), Player Age: \(newPlayer.playerAge)")
        
        // Error Handling for nsErrors
        do {
            // Saves newPlayer to CoreData context
            try viewContext.save()
            
            // Navigates player to GameView with initialized player data
            path.append(GameView(player: newPlayer))
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            let context = PersistenceController.preview.container.viewContext
     
            // Creates Sample Player
            let newPlayer = PlayerData(context: context)
            newPlayer.playerName = "Sample Player"
            newPlayer.saveDate = Date()

            return HomeView()
                .environment(\.managedObjectContext, context)
        }
    }
    
}
