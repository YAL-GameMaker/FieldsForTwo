/**
	A perfectly normal TCP adapter.
	Host configuration: (port: number)
	Join configuration: (url: string, port: number)
**/
function TcpAdapter() : NetworkAdapter() constructor {
	kind = "TCP";
	/**
		For server, this is our "listen" socket.
		For client, this is the socket that we use to connect-communicate.
	**/
	socket = -1 /*#as network_socket*/;
	/**
		For server, this is the "client" socket that connects to us.
	**/
	client = -1 /*#as network_socket*/;
	
	static __NetworkAdapter_reset = reset;
	static reset = function() {
		__NetworkAdapter_reset();
		if (client != -1) {
			network_destroy(client);
			client = -1;
		}
		if (socket != -1) {
			network_destroy(socket);
			socket = -1;
		}
	}
	
	static __NetworkAdapter_host = host;
	static host = function(_config) {
		__NetworkAdapter_host(_config);
		socket = network_create_server(network_socket_tcp, _config.port, 1);
		client = -1;
		if (socket == -1) {
			call_soon(function() {
				handle_host(false);
			});
		} else {
			call_soon(function() {
				handle_host(true);
			});
		}
	}
	
	static __NetworkAdapter_join = join;
	static join = function(_endpoint) {
		__NetworkAdapter_join(_endpoint);
		socket = network_create_socket(network_socket_tcp);
		client = -1;
		network_connect_async(socket, _endpoint.url, _endpoint.port);
	}
	
	static send = function(_buf, _size) {
		if (!can_send()) return false;
		var _sent = network_send_packet(is_server ? client : socket, _buf, _size);
		if (_sent < _size) {
			trace("Send failed:", _sent, "/", _size, "bytes");
			return false;
		}
		return true;
	}
	
	static async_network = function() {
		var e = /*#cast*/ async_load /*#as async_load_network*/;
		switch (e[?"type"]) {
			case network_type_non_blocking_connect:
				if (e[?"id"] != socket) break;
				// we are client and we connected to a server
				handle_connect(e[?"succeeded"]);
				break;
			case network_type_connect:
				if (e[?"id"] != socket) break;
				// we are server and we got a connection
				client = e[?"socket"];
				handle_connect(true);
				break;
			case network_type_disconnect:
				if (e[?"id"] != socket) break;
				// "formal" disconnect (server-only)
				// there is a separate timeout check in {obj_net_control}
				handle_disconnect();
				break;
			case network_type_data:
				if (e[?"id"] != socket && e[?"id"] != client) break;
				handle_packet(e[?"buffer"], e[?"size"]);
				break;
		}
	}
}