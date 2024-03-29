
/** CLICK script for use with real linux systems **/


//require(package "AODV");
require(library local.click);
require(library olsr_core.click);
require(library olsr_ip.click);




elementclass ToDevice{
	input[0]
		-> Queue(2000)
		-> ToDevice(wlan0);
}

elementclass FromDevice{
	$myaddr_ethernet |
	FromDevice(wlan0)
		-> HostEtherFilter($myaddr_ethernet, DROP_OWN false, DROP_OTHER true)
		-> output;
}

tohost::ToHost(fake0);
fromhost::FromHost(fake0, fake, ETHER fake);



FromDevice(fake) -> olsr_ip::OLSR_IP(fake) -> output::ToDevice;

fromhost
	-> fromhost_cl :: Classifier(12/0806, 12/0800);
	fromhost_cl[0] 
		-> ARPResponder(0.0.0.0/0 1:1:1:1:1:1) 
		-> tohost;
	fromhost_cl[1]
		-> Strip(14)
		-> [1]olsr_ip;
		
olsr_ip[1] 
	-> EtherEncap(0x0800, 1:1:1:1:1:1, fake) // ensure ethernet for kernel
	-> tohost;


