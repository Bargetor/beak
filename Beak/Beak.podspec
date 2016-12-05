Pod::Spec.new do |spec|
spec.name = "Beak"
spec.version = "1.0.0"
spec.summary = "Bargetor ios swift framework"
spec.homepage = "https://github.com/Bargetor/beak"
spec.license = { type: 'MIT', file: 'LICENSE' }
spec.authors = { "Bargetor" => 'bargetor@gmail.com' }

spec.platform = :ios, "9.1"
spec.requires_arc = true
spec.source = { git: "https://github.com/Bargetor/beak.git", tag: "v#{spec.version}", submodules: true }
spec.source_files = "Beak/**/*.{h,swift}"

spec.dependency 'Alamofire', '~> 4.2.0'
spec.dependency 'ObjectMapper', '~> 2.2.1'
spec.dependency 'AlamofireObjectMapper', '~> 4.0.1'
end
