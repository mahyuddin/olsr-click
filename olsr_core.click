
/** OLSR Core Module **/

elementclass OLSR_Core {
	$my_ip0, $hello_period, $tc_period, $mid_period, $jitter, $n_hold, $t_hold, $m_hold, $d_hold | 

	forward::OLSRForward($d_hold, duplicate_set, neighbor_info, interface_info, interfaces, $my_ip0)
	interface_info::OLSRInterfaceInfoBase(routing_table, interfaces);
	interfaces::OLSRLocalIfInfoBase($my_ip0)

	MyName::OLSRAddPacketSeq($my_ip0);

	MyName
		-> UDPIPEncap($my_ip0 , 698, 255.255.255.255, 698)
//		-> EtherEncap(0x0800, my_ip0, ff:ff:ff:ff:ff:ff)
		-> [0]output;


	hello_generator0::OLSRHelloGenerator($hello_period, $n_hold, link_info, neighbor_info, interface_info, forward, $my_ip0, $my_ip0)
		-> MyName

	
	duplicate_set::OLSRDuplicateSet
	olsrclassifier::OLSRClassifier(duplicate_set, interfaces, $my_ip0)
	check_header::OLSRCheckPacketHeader(duplicate_set)

	// Input
	get_src_addr::GetIPAddress(12)

	input[0]
		-> get_src_addr
		-> Strip(28)
		-> check_header
		-> olsrclassifier

	check_header[1]
		-> Discard


	// olsr control message handling

	neighbor_info::OLSRNeighborInfoBase(routing_table, tc_generator, hello_generator0, link_info, interface_info, $my_ip0, ADDITIONAL_HELLO false);
	topology_info::OLSRTopologyInfoBase(routing_table);
	link_info::OLSRLinkInfoBase(neighbor_info, interface_info, duplicate_set, routing_table,tc_generator)

	association_info::OLSRAssociationInfoBase(routing_table);
	routing_table::OLSRRoutingTable(neighbor_info, link_info, topology_info, interface_info, interfaces, association_info, linear_ip_lookup, $my_ip0);
	process_hna::OLSRProcessHNA(association_info, neighbor_info, routing_table, $my_ip0);
	olsrclassifier[4]
		-> process_hna

	process_hna[1]
		-> Discard

	process_hna[0]
		-> [0]forward;
	
	process_hello::OLSRProcessHello($n_hold, link_info, neighbor_info, interface_info, routing_table, tc_generator, interfaces, $my_ip0);
	process_tc::OLSRProcessTC(topology_info, neighbor_info, interface_info, routing_table, $my_ip0);
	process_mid::OLSRProcessMID(interface_info, routing_table);


	olsrclassifier[0]
		-> Discard
	olsrclassifier[1]
//		-> AddARPEntry(arpq0)
		-> process_hello
		-> Discard

	olsrclassifier[2]
		-> process_tc

	olsrclassifier[3]
		-> process_mid

	olsrclassifier[5]
		-> [0]forward;

	process_tc[0]
		-> [0]forward;

	process_tc[1]
		-> Discard

	process_mid[0]
		-> [0]forward;

	process_mid[1]
		-> Discard

	forward[0]
		-> MyName

	forward[1]
		-> Discard

	
	mid_generator::OLSRMIDGenerator($mid_period, $m_hold,interfaces)
	tc_generator::OLSRTCGenerator($tc_period, $t_hold, neighbor_info, $my_ip0, ADDITIONAL_TC false)

	tc_generator
		-> [1]forward

	mid_generator
		-> [1]forward



	linear_ip_lookup::OLSRLinearIPLookup();

	input[1]
		-> linear_ip_lookup;

	linear_ip_lookup[0]
		-> [1]output;

	linear_ip_lookup[1]
		-> [2]output;

}


