//
//  ContentView.swift
//  MinuteerApp Watch App
//
//  Created by Gabriel Margonato on 2024-05-12.
//

import SwiftUI

struct ContentView: View {
    @State var timerMinutes: Timer?
    @State var timerSeconds: Timer?
    @State var timerMinutesValue: TimeInterval = 1
    @State var timerSecondsValue: TimeInterval = 60
    @State var timerStarted: Bool = false
    @State var timerPaused: Bool = false
    @State var showAlert: Bool = false

    var body: some View {
        VStack (spacing: 0) {
            ZStack {
                HStack{
                    Text("\(Int(timerMinutesValue))")
                        .font(.system(size: 50).bold())
                        .foregroundColor(!timerStarted || timerPaused ? Color.white : Color.orange)
                    Text(timerSecondsValue == 60 ? "" : timerSecondsValue.formatted()).font(.system(size: 10))
                }
                Circle()
                // Seconds inner circle
                    .trim(from: 0, to:CGFloat( timerSecondsValue / 60))
                    .stroke(lineWidth: 20.0)
                    .opacity(0.50)
                    .foregroundColor(Color.gray)
                    .rotationEffect(Angle(degrees: 270))
                    .animation(Animation.easeInOut(duration: 1.0),value: UUID())
                Circle()
                // Minutes outter circle
                    .trim(from: 0, to:CGFloat( timerMinutesValue / 60))
                    .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(timerStarted == false ? Color.white : Color.orange)
                    .rotationEffect(Angle(degrees: 270))
                    .animation(Animation.easeInOut(duration: 1.0),value: UUID())
            }
//            .padding(.top, -30)
            .focusable(!timerStarted)
            .digitalCrownRotation(
                $timerMinutesValue, from: 1, through: 60, by: 1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true
            )
            .onTapGesture(perform: TimerTapped)
        }
        .frame(width: 130, height: 130)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Timer Ended"), message: Text("Your timer has ended."), dismissButton: .default(Text("OK")))
        }

        // Restart Button
        Button(action: resetTimer) {
            Image(systemName: "arrow.circlepath")
        }
        .foregroundColor(timerStarted == false ? Color.white : Color.orange)
        .frame(width: 30, height: 30)
        .mask(Circle())
        .offset(x: 60, y: 0)
    
    }
        
    func TimerTapped(){
        if timerStarted == false {
            timerPaused = false
            timerStarted = true
            timerMinutesValue -= 1
            startTimerSeconds()
        } else {
            timerPaused.toggle()
        }
    }
        
    func UpdateTimerMinutes() {
        if timerMinutesValue == 0 {
            timerMinutes?.invalidate()
            timerMinutesValue = 1
            timerStarted = false
            showAlert = true
        } else {
            timerMinutesValue -= 1
            startTimerSeconds()
        }
    }
        
    func startTimerSeconds() {
        timerSeconds = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timerSecondsValue > 0 {
                if !timerPaused {
                    timerSecondsValue -= 1
                }
            } else {
                timerSeconds?.invalidate()
                timerSecondsValue = 60
                UpdateTimerMinutes()
            }
        }
    }
    
    func resetTimer(){
        timerStarted = false
        timerPaused = true
        timerMinutes?.invalidate()
        timerSeconds?.invalidate()
        timerMinutesValue = 1
        timerSecondsValue = 60
    }
    
}

#Preview {
    ContentView()
}
