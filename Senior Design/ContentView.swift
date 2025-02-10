import SwiftUI
import Charts

struct DataPoint: Identifiable {
    let id = UUID()
    let time: Double
    let value: Double
}

struct ContentView: View {
    // temp placeholder data stuff
    let data: [DataPoint] = [
            // First heartbeat
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
                    
                    Button(action: {print("Lorem")}) {
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
            Text("Lorem ipsum dolor sit amet, qui minim labore adipisicing minim sint cillum sint consectetur cupidatat.")
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Saved")
                }
        }
    }
}

#Preview {
    ContentView()
}
