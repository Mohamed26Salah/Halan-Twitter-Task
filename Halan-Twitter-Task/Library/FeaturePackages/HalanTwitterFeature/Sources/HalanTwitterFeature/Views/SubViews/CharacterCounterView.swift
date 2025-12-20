//
//  CharacterCounterView.swift
//  HalanTwitterFeature
//
//  Created by Mohamed Salah on 20/12/2025.
//

import SwiftUI

struct CharacterCounterView: View {
    let title: String
    @Binding var maxCount: Int
    @Binding var typedCount: Int?

    init(
        title: String,
        maxCount: Binding<Int>,
        typedCount: Binding<Int?>
    ) {
        self.title = title
        self._maxCount = maxCount
        self._typedCount = typedCount
    }
    
    var body: some View {
        VStack(spacing: Layout.containerSpacing) {
            // Header
            Text(title)
                .lineLimit(1)
                .font(.system(size: Typography.titleFontSize, weight: .medium))
                .foregroundColor(Colors.text)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Layout.headerVerticalPadding)
                .background(Colors.headerBackground)
            
            // Content
            VStack {
                counterText()
                    .font(.system(size: Typography.counterFontSize, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.vertical, Layout.contentVerticalPadding)
            }
            .frame(maxWidth: .infinity)
            .background(Colors.contentBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Layout.cornerRadius)
                .stroke(Colors.border, lineWidth: Layout.borderWidth)
        )
    }
    
    func counterText() -> some View {
        guard let typedCount else {
            return Text("\(maxCount)")
        }
        
        return Text("\(typedCount)/\(maxCount)")
    }
}

private extension CharacterCounterView {
    enum Layout {
        static let containerSpacing: CGFloat = 0
        static let headerVerticalPadding: CGFloat = 6
        static let contentVerticalPadding: CGFloat = 21
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 2
    }
    
    enum Typography {
        static let titleFontSize: CGFloat = 14
        static let counterFontSize: CGFloat = 36
    }
    
    enum Colors {
        static let text: Color = .black
        static let headerBackground: Color = Color.blue.opacity(0.12)
        static let contentBackground: Color = .white
        static let border: Color = Color.blue.opacity(0.2)
    }
}


#Preview {
    CharacterCounterView(
        title: "Salah",
        maxCount: .constant(280),
        typedCount: .constant(0),
    )
}
