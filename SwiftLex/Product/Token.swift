public struct Token: CustomStringConvertible {
    
    public var type: String
    public var content: String
    
    public var description: String { "\t" + type + "\t" + content }
    
}
