import Foundation

extension String {
    
    subscript(index: Int) -> Character? {
        
        if (index >= count) {
            return nil
        }
        
        let a = self.index(startIndex, offsetBy: index)
        return self[a]
        
    }
    
}
