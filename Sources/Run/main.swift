import App
import Vapor

var env = try Environment.detect()
//try LoggingSystem.bootstrap(from: &env)
print("See env \(env)")
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
