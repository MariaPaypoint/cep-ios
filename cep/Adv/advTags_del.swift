//
//  advTags.swift
//  cep
//
//  Created by Maria Novikova on 31.12.2022.
//

import SwiftUI

struct advTags: View {
    
    //@StateObject var model = ContentViewModel()
    
    var body: some View {
        ScrollView {
            
            FlexibleView(
                data: [
                    "Here’s", "to", "the", "crazy", "ones", "the", "misfits", "the", "rebels", "the", "troublemakers", "the", "round", "pegs", "in", "the", "square", "holes", "the", "ones", "who", "see", "things", "differently", "they’re", "not", "fond", "of", "rules"
                ],
                spacing: 15,
                alignment: .leading
            ) { item in
                Text(verbatim: item)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                    )
            }
            .padding(.horizontal, 10)
        }
    }
}

/*
class ContentViewModel: ObservableObject {
    
    @Published var originalItems = [
        "Here’s", "to", "the", "crazy", "ones", "the", "misfits", "the", "rebels", "the", "troublemakers", "the", "round", "pegs", "in", "the", "square", "holes", "the", "ones", "who", "see", "things", "differently", "they’re", "not", "fond", "of", "rules", "You", "can", "quote", "them", "disagree", "with", "them", "glorify", "or", "vilify", "them", "but", "the", "only", "thing", "you", "can’t", "do", "is", "ignore", "them", "because", "they", "change", "things", "they", "push", "the", "human", "race", "forward", "and", "while", "some", "may", "see", "them", "as", "the", "crazy", "ones", "we", "see", "genius", "because", "the", "ones", "who", "are", "crazy", "enough", "to", "think", "that", "they", "can", "change", "the", "world", "are", "the", "ones", "who", "do"
    ]
    
    @Published var spacing: CGFloat = 8
    @Published var padding: CGFloat = 8
    @Published var wordCount: Int = 75
    @Published var alignmentIndex = 0
    
    var words: [String] {
        Array(originalItems.prefix(wordCount))
    }
    
    let alignments: [HorizontalAlignment] = [.leading, .center, .trailing]
    
    var alignment: HorizontalAlignment {
        alignments[alignmentIndex]
    }
}
*/

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    // The initial width should not be `0`, otherwise all items will be layouted in one row,
    // and the actual layout width may exceed the value we desired.
    @State private var availableWidth: CGFloat = 10
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }
            
            _FlexibleView(
                availableWidth: availableWidth,
                data: data,
                spacing: spacing,
                alignment: alignment,
                content: content
            )
        }
    }
}

struct _FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State var elementsSize: [Data.Element: CGSize] = [:]
    
    var body : some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                elementsSize[element] = size
                            }
                    }
                }
            }
        }
    }
    
    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
        
        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]
            
            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow = currentRow + 1
                rows.append([element])
                remainingWidth = availableWidth
            }
            
            remainingWidth = remainingWidth - (elementSize.width + spacing)
        }
        
        return rows
    }
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct advTags_Previews: PreviewProvider {
    static var previews: some View {
        advTags()
    }
}
