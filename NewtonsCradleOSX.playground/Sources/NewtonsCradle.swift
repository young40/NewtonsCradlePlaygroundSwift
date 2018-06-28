import AppKit

public class NewtonsCradle: NSView {
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    public override func draw(_ dirtyRect: NSRect) {
        NSColor.gray.setFill()
        dirtyRect.fill()
    }
}
