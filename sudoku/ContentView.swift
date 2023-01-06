//
//  ContentView.swift
//  sudoku
//
//  Created by Dalveer singh on 14/12/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var board = BoardClass()
    @State var isSolved:Bool = false
    @State var selectedVal:Int = 0
    @State var undoStack:[(from:Int,index:Int,value:Int)] = []
    @State var redoStack:[(from:Int,index:Int,value:Int)] = []
    func getButtonColor(currentVal:Int ,selectedVal:Int)->Color{
        if(selectedVal==currentVal)
        {
            return Color.blue.opacity(0.8)
        }
        else
        {
            return Color.blue.opacity(0.5)
        }
    }
    func setSelectedVal(selected:Int)
    {
        selectedVal = selected
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Sudoku")
                .bold()
                .padding([.bottom],30)
                .font(.title3)
            ForEach(0..<board.items.count/9) { row in
                HStack(spacing: 0) {
                    ForEach(0..<9) { col in
                        let index = row*9+col
                        SquareView(data: board.items[index], onClick: {
                            if(self.board.items[index].cellValue==selectedVal)
                            {
                                return
                            }
                            self.undoStack.append((self.board.items[index].cellValue,index,selectedVal))
                            self.board.setSquare(index: index, newVal: selectedVal)
                        })
                    }
                }
            }
            
            VStack(spacing:2)
            {
                HStack(spacing:2)
                {
                    ForEach(-2..<4){ val in
                        Button {
                            if(val>=0){
                                self.setSelectedVal(selected: val)
                                self.redoStack.removeAll()
                            }
                            else if(val == -2){
                                if(undoStack.count==0) {return}
                                let lastAction = self.undoStack.removeLast()
                                self.redoStack.append(lastAction)
                                self.board.setSquare(index: lastAction.1, newVal: lastAction.0)
                            }
                            else if(val == -1)
                            {
                                if(redoStack.count==0) {return}
                                let lastAction = self.redoStack.removeLast()
                                self.undoStack.append(lastAction)
                                self.board.setSquare(index: lastAction.1, newVal: lastAction.2)
                            }
                            
                        } label: {
                            if(val==0)
                            {
                                Image(systemName: "eraser.fill")
                                    .foregroundColor(Color.white)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .border(Color.gray)
                                    .background(getButtonColor(currentVal: val, selectedVal: selectedVal))
                            }
                            else if (val == -1){
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.white)
                                    .frame(width: 40,height: 40,alignment: .center)
                                    .border(Color.gray)
                                    .background(getButtonColor(currentVal: val, selectedVal: selectedVal))
                            }
                            else if (val == -2)
                            {
                                Image(systemName: "arrow.counterclockwise")
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .border(Color.gray)
                                    .background(getButtonColor(currentVal: val, selectedVal: selectedVal))
                            }
                            else {
                                Text(String(val))
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .border(Color.gray)
                                    .background(getButtonColor(currentVal: val, selectedVal: selectedVal))
                                
                            }
                        }

                    }
                }
                HStack(spacing:2)
                {
                    ForEach(4..<10){val in
                        Button {
                            self.setSelectedVal(selected: val)
                        } label: {
                            Text(String(val))
                                .foregroundColor(Color.white)
                                .bold()
                                .frame(width: 40, height: 40, alignment: .center)
                                .border(Color.gray)
                                .background(getButtonColor(currentVal: val, selectedVal: selectedVal))
                        }

                    }
                }
            }
            .padding([.top,.bottom],20)
            Button {
                self.board.revealOne()
            } label: {
                Text("Reveal One")
                    .foregroundColor(Color.white)
                    .bold()
                    .frame(alignment:.center)
                    .padding(10)
                    .border(Color.gray)
                    .background(Color.gray)
                
            }
            .padding(.bottom,2)
            HStack(spacing:2)
            {
                Button {
                    self.board.makeNewBoard()
                } label: {
                    Text("New Game")
                        .foregroundColor(Color.white)
                        .bold()
                        .frame(alignment:.center)
                        .padding(10)
                        .border(Color.gray)
                        .background(Color.gray)
                }
                Button {
                    self.board.checkBoard()
                    self.board.numSteps = 0
                } label: {
                    Text("View Solution")
                        .foregroundColor(Color.white)
                        .bold()
                        .frame(alignment:.center)
                        .padding(10)
                        .border(Color.gray)
                        .background(Color.gray)
                }


            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
