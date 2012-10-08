
require(library olsr_core.click);

elementclass OLSR_IP {
	$my_ip0 | 


	olsr_core::OLSR_Core($my_ip0, 2000, 5000, 5000, -1, 6000, 15000, 15000, 30);

	ip_classifier::IPClassifier(udp port 698,-);

	c0::Classifier(12/0806 20/0001, 12/0806 20/0002, 12/0800, -);

	input[0]
		-> c0;
	
	c0[0]	-> ar0::OLSRARPResponder($my_ip0 $my_ip0)
		-> [0]output;

	arpq0::OLSRARPQuerier($my_ip0, $my_ip0)
		-> [0]output;

	c0[1]	-> [1]arpq0;

	c0[2]	-> Paint(0)
		-> MarkEtherHeader
		-> Strip(14)
		-> CheckIPHeader
		-> ip_classifier

	c0[3]	-> Discard;


	ip_classifier[0]
		-> [0]olsr_core;


	//handling of other ip packets

	dst_classifier::IPClassifier(dst $my_ip0, -);
	
	ttl::DecIPTTL

	input[1]
		-> MarkIPHeader
		-> dst_classifier

	ip_classifier[1]
		-> dst_classifier

	dst_classifier[0]
		-> CheckIPHeader
		-> MarkIPHeader
		-> [1]output;

	dst_classifier[1]
		-> ttl;

	get_dst_addr::GetIPAddress(16);

	ttl[0]	-> get_dst_addr
		-> [1]olsr_core;

	ttl[1]	-> Discard

	
	olsr_core[1]
		-> Discard;

	olsr_core[2]
		-> [0]arpq0;

	olsr_core[0]
		-> EtherEncap(0x0800, $my_ip0 , ff:ff:ff:ff:ff:ff)
		-> [0]output;

}




