Pod::Spec.new do | s |
    s.name = "SHDrawingBoard"
    s.version = "1.0.0"

    s.summary = "涂鸦、画板"
    s.author = {"CCSH" => "624089195@qq.com"}
    s.homepage = "https://github.com/CCSH/#{s.name}.git"
    s.source = {:git => "https://github.com/CCSH/#{s.name}.git", :tag => s.version }
    s.platform = :ios, "9.0"
    s.requires_arc = true
    s.license = "MIT"

    s.source_files = "#{s.name}/*.{h,m}"
    s.frameworks = "UIKit"
end
