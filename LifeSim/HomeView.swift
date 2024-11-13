/**
    #HomeView.swift
 
    Represents the home page UI of the application. Utilizes
    CoreData by fetching saved game data. Allows the player
    to create a new saved game or load a previously created
    save.  Utilizes a navigation stack to allow for seamless
    navigation between views across the application.
 */

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
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                
                // TESTING purposes only:
                // This text box displays saved game data loaded when app is initialized
                Text(message)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .border(Color.gray, width: 1)
                
                // New Game Button
                Button(action: checkForExistingSave) {
                    Text("New Game")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                // Alerts player that they are about to overwrite a saved game
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
                
                // Load Game Button
                Button(action: loadGame) {
                    Text("Load Game")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .onTapGesture { // User presses Load Game
                    
                    // If there is no game save to load
                    if players.isEmpty {
                        noSaveGameAlert = true // Display Alert
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
            .onAppear {
                
                //TEST purposes only:
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
    func startNewGame(playerName: String) {
        // Defines instance of PlayerData entity
        let newPlayer = PlayerData(context: viewContext)
        
        // Sets initial attributes
        newPlayer.playerName = playerName
        newPlayer.saveDate = Date()
        
        // Error Handling for nsErrors
        do {
            // Saves newPlayer to CoreData context
            try viewContext.save()
            print("New Game Started on \(newPlayer.saveDate ?? Date())")
            
            // Navigates player to GameView with initialized player data
            path.append(GameView(player: newPlayer))
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    /** Have not been able to get this preview to work properly. Use simulator to test.
     
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
    */
}
