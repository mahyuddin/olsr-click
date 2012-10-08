
/** CLICK script for use with NS-3 **/


require(library olsr_core.click);
require(library olsr_ip.click);


AddressInfo(fake eth0); /**for ns3 simulation**/


/** It is mandatory to use an IPRouteTable element with ns-3-click **/
rt :: StaticIPLookup(0.0.0.0/0 0);
Idle() -> rt -> Discard;


elementclass ToNetwork{
	input[0]
		-> Queue(64)
		-> ToSimDevice(eth0);
}

elementclass FromNetwork{
	$myaddr_ethernet |
	FromSimDevice(eth0)
		-> HostEtherFilter($myaddr_ethernet, DROP_OWN true, DROP_OTHER false)
		-> output;
}

tohost :: ToSimDevice(tap0,IP);
fromhost :: FromSimDevice(tap0);



FromNetwork(fake) -> olsr_ip::OLSR_IP(fake) -> output::ToNetwork;
fromhost -> [1]olsr_ip;
olsr_ip[1] -> tohost;


