//
//  DateCell.swift
//  AJ
//
//  Created by Денис on 02.10.2023.
//

import SwiftUI

struct DateCell: View, Equatable {

    static func == (lhs: DateCell, rhs: DateCell) -> Bool {
        lhs.date == rhs.date
    }

    let date: Date

    var body: some View {
        HStack {
            Spacer()
            Text(date.day)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding(8)
            Spacer()
        }
    }
}

#Preview {
    DateCell(date: Date(timeIntervalSince1970: 300))
}
