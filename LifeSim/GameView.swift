/**
 
#   GameView.swift
 
 */
import SwiftUI
import CoreData

// Enumeration that defines each section of buttons
enum GameSection {
    case main, finances, job, relationships, education, assets, city, casino, blackjack
}

struct GameView: View, Hashable {
    
    // Observes changes to PlayerData instance
    @ObservedObject var player: PlayerData
    // Initializes current game section to being in the main section
    @State private var currentSection: GameSection = .main
    
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
            .frame(height: UIScreen.main.bounds.height * 0.15)
            
            ///#======= SPRITEKIT CONTENT CONTAINER ============
            ZStack {
                
                if let playerName = player.playerName {
                    Text("[Test] Loaded Player's Name:\n \(playerName)")
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
        // Disables navigation back to HomeView
        .navigationBarBackButtonHidden(true)
    }
/**
     
     Most of the following code after this portion will be defining the buttons along with their
     navigation and actions.
     
*/
    
    
    
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

    ///# ============= DEFINES FINANCE BUTTON SET =============
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
            Button(action: { print("Go to Bank") }) {
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
    
    // Blackjack Button Set
    func blackjackButtons() -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: columns, spacing: 20) {
            Button(action: { currentSection = .casino }) {
                Text("Back")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { print("Hit") }) {
                Text("Hit")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { print("Stand") }) {
                Text("Stand")
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

    ///# ============= DEFINES CAREER BUTTON SET =============
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
            Button(action: { print("Assets Action 1") }) {
                Text("Assets Action 1")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { print("Assets Action 2") }) {
                Text("Assets Action 2")
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
            Button(action: { print("City Action 1") }) {
                Text("City Action 1")
                    .font(.custom("AvenirNext-Bold", size: 22))
                    .foregroundColor(Color.white)
                    .shadow(radius: 5)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 80, maxHeight:80)
                    .background(Color.cyan)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Button(action: { print("City Action 2") }) {
                Text("City Action 2")
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

    
    // Conforms to Equatable Protocol
    static func == (lhs: GameView, rhs: GameView) -> Bool {
        return lhs.player.objectID == rhs.player.objectID
    }

    // Conforms to Hashable Protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(player.objectID)
    }
}

// For XCode Preview Purposes only:
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let newPlayer = PlayerData(context: context)
        newPlayer.playerName = "Preview Player"
        newPlayer.saveDate = Date()

        return GameView(player: newPlayer)
            .environment(\.managedObjectContext, context)
    }
}
