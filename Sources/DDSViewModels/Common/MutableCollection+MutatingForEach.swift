
extension MutableCollection {
	public mutating func mutatingForEach(_ body: (inout Element) throws -> Void) rethrows {
		for index in self.indices {
			try body(&self[index])
		}
	}
}
