import Foundation

final class TokenTree {
    var root: ASTNode

    init(root: ASTNode) {
        self.root = root
    }
}

extension TokenTree {
    func deepWalk(action: (ASTNode) -> Void) {

        var current: ASTNode?  = self.root
        var previous = [ASTNode]()

        while let node = current {
            action(node)

            guard let firstNext = node.next.first else {
                if previous.isEmpty {
                    break
                }
                current = previous.removeFirst()
                continue
            }

            let sliceWithoutFirstNext = node.next.dropFirst()

            previous.insert(contentsOf: sliceWithoutFirstNext, at: 0)

            current = firstNext
        }
    }
}
