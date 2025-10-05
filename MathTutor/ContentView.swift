//
//  ContentView.swift
//  MathTutor
//
//  Created by Jeff Gutierrez on 10/5/25.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    @State private var firstNumberEmojis = ""
    @State private var secondNumberEmojis = ""
    @State private var answer = ""
    @FocusState private var isFocused:  Bool
    @State private var audioPlayer: AVAudioPlayer!
    @State private var textFieldIsDisabled = false
    @State private var buttondIsDisabled = false
    @State private var message = ""
    var body: some View {
        VStack {
            Group {
                Text(firstNumberEmojis)
                Text("+")
                Text(secondNumberEmojis)
            }
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .font(Font.system(size: 80))
            .animation(.default, value: message)
            
            Spacer()
            
            Text("\(firstNumber) + \(secondNumber) =")
                .font(.largeTitle)
            
            TextField("", text: $answer)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .frame(width: 60)
                .textFieldStyle(.roundedBorder)
                .overlay{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                }
                .keyboardType(.numberPad)
                .focused($isFocused)
                .disabled(textFieldIsDisabled)
                .animation(.default, value: message)
            
            Spacer()
            
            Button("Guess") {
                isFocused = false
                guard let answerValue = Int(answer) else {
                    return
                }
                if answerValue == firstNumber + secondNumber {
                    playSound(soundName: "correct")
                    message = "Correct!"
                } else {
                    playSound(soundName: "wrong")
                    message = "Sorry, the correct answer is \(firstNumber + secondNumber)."
                }
                textFieldIsDisabled = true
                buttondIsDisabled = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty || buttondIsDisabled)
            
            Spacer()
            
            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundStyle(message == "Correct!" ? .green : .red)
                .animation(.default, value: message)
            
            if message != "" {
                Button("Play Again?")
                {
                    message = ""
                    answer = ""
                    textFieldIsDisabled = false
                    buttondIsDisabled = false
                    generateEquation()
                }
            }
        }
        .onAppear{
            generateEquation()
        }
        .padding()
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("ERROR: Could not read file named \(soundName)")
            return
        }
        do{
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("ERROR: \(error.localizedDescription) creating audioPlayer")
        }
    }
    func generateEquation() {
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)
        firstNumberEmojis = String(repeating: emojis.randomElement()!, count: firstNumber)
        secondNumberEmojis = String(repeating: emojis.randomElement()!, count: secondNumber)
    }
}

#Preview {
    ContentView()
}
