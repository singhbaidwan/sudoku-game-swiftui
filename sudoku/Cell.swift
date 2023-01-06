//
//  Cell.swift
//  sudoku
//
//  Created by Dalveer singh on 14/12/22.
//

import SwiftUI
import Foundation

class Cell:ObservableObject{
    @Published var cellValue:Int
    @Published var index:Int
    @Published var row:Int
    @Published var col:Int
    @Published var isPermanent:Bool
    @Published var isHint:Bool
    @Published var isWrong:Bool
    init(cellValue: Int, index: Int, row: Int, col: Int, isPermanent: Bool, isHint: Bool, isWrong: Bool) {
        self.cellValue = cellValue
        self.index = index
        self.row = row
        self.col = col
        self.isPermanent = isPermanent
        self.isHint = isHint
        self.isWrong = isWrong
    }
    init(value:Int,index:Int,rowCol:[Int],isPermanent:Bool)
    {
        self.cellValue = value
        self.index = index
        self.row = rowCol[0]
        self.col = rowCol[1]
        self.isPermanent = isPermanent
        self.isHint = false
        self.isWrong = false
    }
    
}


struct SquareView:View{
    @ObservedObject var data:Cell
    var onClick:()->Void
    var squareColor: Color {
        
        if (((self.data.col > 5 || self.data.col < 3) && (self.data.row > 5 || self.data.row < 3)) ||
            ((self.data.col <= 5 && self.data.col >= 3) && (self.data.row <= 5 && self.data.row >= 3))) {
            return .blue.opacity(0.5)
        } else {
            return .blue.opacity(0.8)
        }
    }
    var squareWeight:Font.Weight{
        if(self.data.isHint)
        {
            return .bold
        }
        if(self.data.isWrong)
        {
            return .bold
        }
        return self.data.isPermanent ? .bold : .light
    }
    var squareTextColor:Color{
        if(self.data.isHint)
        {
            return .white
        }
        if(self.data.isWrong)
        {
            return .red
        }
        return .black
    }
    var body: some View{
        Button {
            onClick()
        } label: {
            Text(self.data.cellValue != 0 ? String(self.data.cellValue) : " ")
                .foregroundColor(squareTextColor)
                .fontWeight(squareWeight)
                .frame(width: 40,height: 40,alignment: .center)
                .border(Color.black.opacity(0.7))
                .background(squareColor)
        }

    }
}

