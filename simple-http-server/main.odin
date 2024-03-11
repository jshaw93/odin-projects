package web

import "core:fmt"
import "core:log"
import "core:time"
import "core:net"

import http "../../odin-http"


main :: proc() {
    context.logger = log.create_console_logger(.Info)

    server : http.Server
    http.server_shutdown_on_interrupt(&server)

    router : http.Router
    http.router_init(&router)
    defer http.router_destroy(&router)

    // Create route for website, localhost:8000/ resolves to the index procedure
    http.route_get(&router, "/", http.handler(index))

    routed := http.router_handler(&router)

    log.info("Listening on http://localhost:8000")
    err := http.listen_and_serve(&server, routed, net.Endpoint{address = net.IP4_Loopback, port=8000})
    fmt.assertf(err == nil, "Server stopped with error: %v", err)
}

index :: proc(req: ^http.Request, res: ^http.Response) {
    http.respond_file(res, "static/index.html")
}
