import SwiftUI

class CustomiseViewModel: ObservableObject {
    @Published var editMode = EditMode.inactive
    @Published var categoriesCopy = categories
    @Published var path = NavigationPath()
    
    func addNewCategory() {
        let category = Category()
        categoriesCopy.append(category)
        path.append(category)
    }
}
