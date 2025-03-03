import SwiftUI
import Charts

struct DataPoint: Identifiable {
    let id = UUID()
    let time: Double
    let value: Double
}

func formattedDate(from timestamp: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let formatter = DateFormatter()
    formatter.dateStyle = .medium  // Example: "Mar 2, 2025"
    formatter.timeStyle = .short   // Example: "3:45 PM"
    return formatter.string(from: date)
}

struct ContentView: View {
    @State private var savedEntries: [(key: String, data: [DataPoint])] = []
    @State private var savedKeys: [String] = []
    @State private var selectedData: [DataPoint] = []
    @State private var selectedKey: String? = nil
    
    
    let bluetoothManager = BluetoothManager()
    
    // temp placeholder data stuff
    @State var data: [DataPoint] = [
            DataPoint(time: 0, value: 0),
            DataPoint(time: 1, value: 0),
            DataPoint(time: 2, value: 1),
            DataPoint(time: 3, value: 0),
            DataPoint(time: 4, value: -1),
            DataPoint(time: 5, value: 4),
            DataPoint(time: 6, value: -1),
            DataPoint(time: 7, value: 0),
            DataPoint(time: 8, value: 1),
            DataPoint(time: 9, value: 0),
            DataPoint(time: 10, value: 0),
            DataPoint(time: 11, value: 0),
            DataPoint(time: 12, value: 1),
            DataPoint(time: 13, value: 0),
            DataPoint(time: 14, value: -1),
            DataPoint(time: 15, value: 4),
            DataPoint(time: 16, value: -1),
            DataPoint(time: 17, value: 0),
            DataPoint(time: 18, value: 1),
            DataPoint(time: 19, value: 0),
            DataPoint(time: 20, value: 0),
            DataPoint(time: 21, value: 0),
            DataPoint(time: 22, value: 1),
            DataPoint(time: 23, value: 0),
            DataPoint(time: 24, value: -1),
            DataPoint(time: 25, value: 4),
            DataPoint(time: 26, value: -1),
            DataPoint(time: 27, value: 0),
            DataPoint(time: 28, value: 1),
            DataPoint(time: 29, value: 0),
            DataPoint(time: 30, value: 0)
        ]
    
    func saveData(data: [DataPoint]) {
        let timestamp = Date().timeIntervalSince1970
        let key = "save_\(timestamp)"
        let nums = data.map(\.value)
        UserDefaults.standard.set(nums, forKey: key)

        var keys = UserDefaults.standard.array(forKey: "savedKeys") as? [String] ?? []
        keys.append(key)
        UserDefaults.standard.set(keys, forKey: "savedKeys")
        loadSavedKeys()
        print("Data saved with key: \(key)")
    }
    
    func deleteData(forKey key: String) {
            UserDefaults.standard.removeObject(forKey: key)

            var keys = UserDefaults.standard.array(forKey: "savedKeys") as? [String] ?? []
            keys.removeAll { $0 == key }  // Remove key from list
            UserDefaults.standard.set(keys, forKey: "savedKeys")

            loadSavedKeys()
            print("Deleted entry: \(key)")
        }
    
    func loadSavedKeys() {
        savedKeys =  UserDefaults.standard.array(forKey: "savedKeys") as? [String] ?? []
    }
    
    func loadData(forKey key: String) {
        if let savedNumbers = UserDefaults.standard.array(forKey: key) as? [Double] {
            selectedData = []
            for(i, num) in savedNumbers.enumerated() {
                selectedData.append(DataPoint(time: Double(i), value: Double(num)))
            }
            selectedKey = key
            print("Loaded \(key)")
        } else {
            print("No data found for key: \(key)")
        }
    }
    
    var body: some View {
        TabView {
            VStack{
                Text("Last ECG")
                Text("January 1, 2024")
                    .font(.caption)
                Chart {
                    ForEach(data) {
                        point in LineMark(
                            x: .value("Time", point.time),
                            y: .value("ECG Value", point.value)
                        )
                        .foregroundStyle(.green)
                        .interpolationMethod(.cardinal)
                    }
                }
                    .frame(height: 300)
                    .padding()
                
                HStack {
                    VStack{
                        Text("Lorem ipsum")
                        Text("dolor sit amet")
                    }
                    .padding(.trailing, 140.0)
                    
                    Button(action: {saveData(data: data)}) {
                        VStack{
                            Image(systemName: "square.and.arrow.down")
                            Text("Save")
                                .textScale(.secondary)
                        }
                    }
                    Button(action: {print("Ipsum")}) {
                        VStack{
                            Image(systemName: "square.and.arrow.up")
                            Text("Export")
                                .textScale(.secondary)
                        }
                    }
                }
            }
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            Text("Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.")
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Recent")
                }
            NavigationView { // saved data view
                List {
                    ForEach(savedKeys, id: \.self) { key in
                        HStack {
                            Button(action: {
                                loadData(forKey: key)
                            }) {
                            Text("Saved on \(formattedDate(from: Double(key.replacingOccurrences(of: "save_", with: "")) ?? 0))")
                            }
                            Spacer()
                            Button(action: {
                                deleteData(forKey: key)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle()) // Ensures button works in List
                        }
                    }
                }
                .navigationTitle("Saved Entries")
                .onAppear {
                    loadSavedKeys()
                }
                .sheet(isPresented: Binding<Bool>(
                            get: { !selectedData.isEmpty },
                            set: { if !$0 { selectedData = [] } }
                        )) {
                            DataDetailView(dataPoints: selectedData, key: selectedKey ?? "ECG")
                        }
            }
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Saved")
                }
        }
    }
}
struct DataDetailView: View {
    var dataPoints: [DataPoint]
    var key: String

    var body: some View {
        VStack{
            Text("\(formattedDate(from: Double(key.replacingOccurrences(of: "save_", with: "")) ?? 0))")
            Chart {
                ForEach(dataPoints) {
                    point in LineMark(
                        x: .value("Time", point.time),
                        y: .value("ECG Value", point.value)
                    )
                    .foregroundStyle(.green)
                    .interpolationMethod(.cardinal)
                }
            }
            .frame(height: 300)
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
