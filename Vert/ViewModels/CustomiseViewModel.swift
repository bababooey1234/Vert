import SwiftUI
import SwiftData

class CustomiseViewModel: ObservableObject {
    @Published var editMode = EditMode.inactive
    @Published var path = NavigationPath()
}
