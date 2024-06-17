enum PacketType {
	/// [sc] Used to figure out network latency and connection timeout
	Ping = 1,
	
	/// [sc][Lobby]
	Ready,
	
	/// [s][Lobby] [time:int] Updates the "starting in" timer
	StartIn,
	
	/// [s][Lobby] Starting now!
	Start,
	
	/// [sc][Game] [json:string]
	Turn,
}