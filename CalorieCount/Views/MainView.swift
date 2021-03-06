import SwiftUI
import CoreData

struct MainView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest (sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var food: FetchedResults<Food>
    
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView{
            VStack{
            ZStack{
                Circle()
                    .foregroundColor(.mint).opacity(0.3)
                    .frame(width: 40, height: 40)
                Text("\(Int(totalCaloriesToday())) Kcal (Today)")
                .foregroundColor(.black)}
                .padding(.horizontal)
                List {
                    ForEach(food) { food in
                        NavigationLink(destination: EditFoodView(food: food)) {
                            HStack{
                                VStack (alignment: .leading, spacing: 6) {
                                    Text(food.name!)
                                        .bold()
                                        .foregroundColor(.black)
                                    Text("\(Int(food.calories))") + Text(" calories").foregroundColor(.black)
                                }
                                Spacer()
                                Text(calcTimeSince(date: food.date!))
                            }
                        }
                    }
                    .onDelete(perform: deleteFood)
                }
                .listStyle(.plain)
            
            }
            .navigationTitle("Calories Counter")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add food", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddFoodView()
            }
        }
        .navigationViewStyle(.stack)
    }
    private func deleteFood(offsets: IndexSet) {
        withAnimation {
            offsets.map { food[$0] }.forEach(managedObjectContext.delete)
            
            DataController().save(context: managedObjectContext)
        }
    }
    
    private func totalCaloriesToday() -> Float {
        var caloriesToday: Float = 0
        for item in food {
            if Calendar.current.isDateInToday(item.date!) {
                caloriesToday += item.calories
            }
        }
        return caloriesToday
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

