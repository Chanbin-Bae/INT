/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

//Chanbin: FAT_INT
#define MAX_PORTS 511
#define INT 20 //FAT_INT

const bit<16> TYPE_IPV4 = 0x800;
const bit<16> L2_LEARN_ETHER_TYPE = 0x1234;

/*************************************************************************
*********************** H E A D E R S  ***********************************
*************************************************************************/

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;
const bit<32> BMV2_V1MODEL_INSTANCE_TYPE_REPLICATION   = 5;
#define IS_REPLICATED(std_meta) (std_meta.instance_type == BMV2_V1MODEL_INSTANCE_TYPE_REPLICATION)

header ethernet_t {
		macAddr_t dstAddr;
		macAddr_t srcAddr;
		bit<16>   etherType;
}

header ipv4_t {
		bit<4>    version;
		bit<4>    ihl;
		// bit<6>    dscp;
		// bit<2>    ecn;
		bit<8> dscp;
		bit<16>   totalLen;
		bit<16>   identification;
		bit<3>    flags;
		bit<13>   fragOffset;
		bit<8>    ttl;
		bit<8>    protocol;
		bit<16>   hdrChecksum;
		ip4Addr_t srcAddr;
		ip4Addr_t dstAddr;
}

header switch_to_cpu_header_t {
		bit<32> word0;
		bit<32> word1;
}

// Chanbin: FAT_INT
header fat_int_q_occupancy_t {
	bit<8> q_id;
	bit<24> q_occupancy;
	bit<8> switch_id;
} //5 bytes

header fat_int_hop_latency_t {
	bit<32> hop_latency;
	bit<8> switch_id;
} // 5 bytes

header fat_int_egress_timestamp_t {
	bit<64> egress_timestamp;
	bit<8> switch_id;
} // 9 bytes

struct headers {
		switch_to_cpu_header_t switch_to_cpu;
		ethernet_t   ethernet;
		ipv4_t       ipv4;
		// Chanbin: FAT_INT
		fat_int_q_occupancy_t fat_int_q_1;
		fat_int_q_occupancy_t fat_int_q_2;
		fat_int_q_occupancy_t fat_int_q_3;
		fat_int_hop_latency_t fat_int_hop_latency_1;
		fat_int_hop_latency_t fat_int_hop_latency_2;
		fat_int_egress_timestamp_t fat_int_egress_timestamp_1;
}

struct learn_t{
		bit<48> global_hash;
		bit<48> digest;
		bit<48> approximation;
		bit<32> switch_id;
		bit<16> packet_id;
		bit<8> ttl;
		bit<1> decision;
}

struct metadata {
		bit<9> ingress_port;
		bit<48> approximation;
		bit<48> global_hash;

		bit<48> digest_1;
		bit<48> digest_2;
		bit<48> digest_3;

		bit<32> switch_id;
		bit<32> decider_hash_pint;
		bit<32> decider_hash_asm;
		bit<13> asm_hash_1;
		bit<13> asm_hash_2;
		bit<13> asm_hash_3;
		bit<13> asm_hash_4;
		bit<13> asm_hash_5;
		bit<13> asm_hash_6;
		bit<13> asm_hash_7;
		bit<13> asm_hash_8;

		bit<32> xor_hash;
		learn_t learn_data;
		bit<8> ttl;
		bit<32> b_value;
	
		// Chanbin: FAT_INT
		bit<32> count;
		bit<32> sampling_space_q;
		bit<32> sampling_space_hop;
		bit<32> sampling_space_egress_tst;
		bit<8> switch_count;
		bit<32> quotient_q;
		bit<32> remainder_q;
		bit<32> quotient_hop;
		bit<32> remainder_hop;
		bit<32> quotient_egress;
		bit<32> remainder_egress;
		bool  source;
    	bool  sink;
		bit<48> approximation_q;
		bit<48> approximation_hop;
		bit<48> approximation_egress;
		bit<48> global_hash1;
}


/*************************************************************************
*********************** P A R S E R  ***********************************
*************************************************************************/

parser MyParser(packet_in packet,
								out headers hdr,
								inout metadata meta,
								inout standard_metadata_t standard_metadata) {

		state start {
				packet.extract(hdr.ethernet);
				packet.extract(hdr.ipv4);
				// Chanbin: FAT_INT
				transition select (hdr.ipv4.dscp){
					INT: fat_int1;
					INT +1: fat_int2;
					INT +2: fat_int3;
					default: accept;
				}
		}

		// Chanbin: FAT_INT
		state fat_int1 {
			packet.extract(hdr.fat_int_q_1);
			// packet.extract(hdr.fat_int_q_2);
			// packet.extract(hdr.fat_int_q_3);
			packet.extract(hdr.fat_int_hop_latency_1);
			// packet.extract(hdr.fat_int_hop_latency_2);
			packet.extract(hdr.fat_int_egress_timestamp_1);
			transition accept;
		}
		state fat_int2 {
			packet.extract(hdr.fat_int_q_1);
			packet.extract(hdr.fat_int_q_2);
			// packet.extract(hdr.fat_int_q_3);
			packet.extract(hdr.fat_int_hop_latency_1);
			packet.extract(hdr.fat_int_hop_latency_2);
			packet.extract(hdr.fat_int_egress_timestamp_1);
			transition accept;
		}
		state fat_int3 {
			packet.extract(hdr.fat_int_q_1);
			packet.extract(hdr.fat_int_q_2);
			packet.extract(hdr.fat_int_q_3);
			packet.extract(hdr.fat_int_hop_latency_1);
			packet.extract(hdr.fat_int_hop_latency_2);
			packet.extract(hdr.fat_int_egress_timestamp_1);
			transition accept;
		}
}


/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
		apply {  }
}


/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

/** To Do List for Chanbin **/
/** 1. For fixed sampling space (=3) with one item, approximated reservoir sampling **/
/** 1-1. Flexible sampling space (increasing sampling space unitl upperbound)**/
/** 2. for fixed sampling space with multiple items (queue: 3, hop: 2, egress: 1), approximated reservoir sampling **/
/** 3. Embed INT header within probabilistic manner **/

/** FYI **/
/** 1. Switch count = 64 - hdr.ipv4.ttl **/
/** 2. Index = k mod|space| ==> k = switch count, space = 3 (3 for queue, 2 for hop, 1 for egress) **/
/** 3. Probability = 1/(k/|Space|) **/
/** ==> Implement division (k/space) with Match Action table and rules **/
/** ==> Inverse(Quotient) = Prob // remainder * k = Index **/

control MyIngress(inout headers hdr,
									inout metadata meta,
									inout standard_metadata_t standard_metadata) {

		// PINT
		// action drop() {
		// 		mark_to_drop();
		// }

		// action forward(bit<9> egress_port){
		// 		//Standard routing
		// 		standard_metadata.egress_spec=egress_port;

		// 		//Read the current TTL
		// 		bit <32> diff=256-(bit<32>)hdr.ipv4.ttl;


		// 		// extern void hash<O, T, D, M>(out O result, in HashAlgorithm algo, in T base, in D data, in M max);

		// 		//Decider hash
		// 		hash(meta.decider_hash_pint, HashAlgorithm.crc32, (bit<1>)0, {hdr.ipv4.identification},(bit<32>)100);

		// 		//XOR hash
		// 		hash(meta.xor_hash, HashAlgorithm.crc32, (bit<1>)0, {hdr.ipv4.identification,diff},(bit<32>)1000000);

		// 		//Hashing to understand if needs to copy digest
		// 		hash(meta.global_hash, HashAlgorithm.crc32, (bit<1>)0, {hdr.ipv4.identification,diff},(bit<48>)1000000);

		// 		/*Creating digest of the switch:
		// 		Using 48 bits of the destination MAC address to accomodate PINT8, PINT4 and PINT1
		// 		Speeds up evaluation.
		// 		*/
		// 		hash(meta.digest_1, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id,hdr.ipv4.identification},(bit<16>)255);
		// 		hash(meta.digest_2, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id,hdr.ipv4.identification},(bit<16>)7);
		// 		hash(meta.digest_3, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id,hdr.ipv4.identification},(bit<16>)1);

		// 		//Combining PINT8, PINT4 and PINT1 into the final digest.
		// 		bit <48> final_digest=(meta.digest_1 << 32) + (meta.digest_2 << 16) + (meta.digest_3);

		// 		//Estimating the XOR of switch ID
		// 		bit<48> xor_extract=1;
		// 		bit<48> dstAddr_1=((xor_extract << 16) - 1) & (hdr.ethernet.dstAddr >> 0); // 1st 16 bits(from right) of ether.dstAddr
		// 		bit<48> dstAddr_2=((xor_extract << 16) - 1) & (hdr.ethernet.dstAddr >> 16); // 2nd 16 bits(from right) of ether.dstAddr
		// 		bit<48> dstAddr_3=((xor_extract << 16) - 1) & (hdr.ethernet.dstAddr >> 32); // 3rd 16 bits(from right) of ether.dstAddr

		// 		dstAddr_1=dstAddr_1^(bit<48>)meta.switch_id;
		// 		dstAddr_2=dstAddr_2^(bit<48>)meta.switch_id;
		// 		dstAddr_3=dstAddr_3^(bit<48>)meta.switch_id;


		// 		bit<8> dstAddr_1_final=(bit<8>)dstAddr_1;
		// 		bit<4> dstAddr_2_final=(bit<4>)dstAddr_2;
		// 		bit<1> dstAddr_3_final=(bit<1>)dstAddr_3;

		// 		bit <48> final_xor_digest=((bit<48>)dstAddr_1_final << 32) + ((bit<48>)dstAddr_2_final << 16) + ((bit<48>)dstAddr_3_final);

		// 		/*Copying the digest to the destination MAC for
		// 		some packets.
		// 		*/
		// 		if (meta.decider_hash_pint<50){
		// 				if (meta.global_hash<meta.approximation){
		// 						//Copying the digest to Destination MAC
		// 						hdr.ethernet.dstAddr=final_digest;

		// 						//Copying the switch ID to source MAC. Used only for verification
		// 						hdr.ipv4.hdrChecksum=(bit<16>)meta.switch_id;
		// 				}
		// 		}

		// 		/*Copying the XOR digest to the destination MAC for
		// 		some packets.
		// 		*/
		// 		if (meta.decider_hash_pint>=50){
		// 				if (meta.xor_hash<=100000){
		// 						//Copying the digest to Destination MAC
		// 						hdr.ethernet.dstAddr=final_xor_digest;

		// 						//Copying the switch ID to source MAC. Used only for verification
		// 						hdr.ipv4.hdrChecksum=(bit<16>)meta.switch_id;
		// 				}
		// 		}
		// 		//Decider hash ASM
		// 		hash(meta.decider_hash_asm, HashAlgorithm.crc32, (bit<1>)0, {hdr.ipv4.identification},(bit<32>)7);

		// 		hash(meta.asm_hash_1, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+1},(bit<48>)100);
		// 		hash(meta.asm_hash_2, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+2},(bit<48>)100);
		// 		hash(meta.asm_hash_3, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+3},(bit<48>)100);
		// 		hash(meta.asm_hash_4, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+4},(bit<48>)100);
		// 		hash(meta.asm_hash_5, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+5},(bit<48>)100);
		// 		hash(meta.asm_hash_6, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+6},(bit<48>)100);
		// 		hash(meta.asm_hash_7, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+7},(bit<48>)100);
		// 		hash(meta.asm_hash_8, HashAlgorithm.crc32, (bit<32>)0, {meta.switch_id+8},(bit<48>)100);

		// 		if (meta.global_hash<meta.approximation){
		// 			hdr.ipv4.hdrChecksum=(bit<16>)meta.switch_id;
		// 			if (meta.decider_hash_asm==0){
		// 				bit<16> final_asm_hash=((bit<16>)meta.asm_hash_1<<3)+((bit<16>)meta.decider_hash_asm);
		// 				hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
		// 			}
		// 			if (meta.decider_hash_asm==1){
		// 				bit<16> final_asm_hash=((bit<16>)meta.asm_hash_2<<3)+((bit<16>) meta.decider_hash_asm);
		// 				hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
		// 			}
		// 			if (meta.decider_hash_asm==2){
		// 				bit<16> final_asm_hash=((bit<16>)meta.asm_hash_3<<3)+((bit<16>) meta.decider_hash_asm);
		// 				hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
		// 			}
		// 			if (meta.decider_hash_asm==3){
		// 				bit<16> final_asm_hash=((bit<16>)meta.asm_hash_4<<3)+((bit<16>) meta.decider_hash_asm);
		// 				hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
		// 			}
		// 			if (meta.decider_hash_asm==4){
		// 				bit<16> final_asm_hash=((bit<16>)meta.asm_hash_5<<3)+((bit<16>) meta.decider_hash_asm);
		// 				hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
		// 			}
		// 			if (meta.decider_hash_asm==5){
		// 				bit<16> final_asm_hash=((bit<16>)meta.asm_hash_6<<3)+((bit<16>) meta.decider_hash_asm);
		// 				hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
		// 			}
		// 			if (meta.decider_hash_asm==6){
		// 				bit<16> final_asm_hash=((bit<16>)meta.asm_hash_7<<3)+((bit<16>) meta.decider_hash_asm);
		// 				hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
		// 			}
		// 			if (meta.decider_hash_asm==7){
		// 				bit<16> final_asm_hash=((bit<16>)meta.asm_hash_8<<3)+((bit<16>) meta.decider_hash_asm);
		// 				hdr.ethernet.srcAddr=(bit<48>)final_asm_hash;
		// 			}
		// 		}

		// 		hdr.ipv4.ttl=hdr.ipv4.ttl-1;

		// }

		// action copy_to_metadata(bit<48> approximation, bit<32> switch_id, bit<32> b_value){
		// 		meta.approximation=approximation;
		// 		meta.switch_id=switch_id;
		// 		meta.b_value=b_value;
		// }

		// Chanbin: FAT_INT
		action set_param(bit<32> quotient_q, bit<32> remainder_q,
				 		 bit<32> quotient_hop, bit<32> remainder_hop,
						 bit<32> quotient_egress, bit<32> remainder_egress,
						 bit<48> approximation_q, bit<48> approximation_hop, bit<48> approximation_egress) {
				meta.quotient_q = quotient_q + 1;
				meta.remainder_q = remainder_q;
				meta.quotient_hop = quotient_hop + 1;
				meta.remainder_hop = remainder_hop;
				meta.quotient_egress = quotient_egress; // Do not add 1, cuase egress' space = 1
				meta.remainder_egress = remainder_egress;
				// approximation = 1,000,000 / quotient
				meta.approximation_q = approximation_q; // 1000000/quotient 
				meta.approximation_hop = approximation_hop;
				meta.approximation_egress = approximation_egress;
		}
		action int_set_source () {
    	    meta.source = true;
			hdr.ipv4.dscp = INT;
		}	

		action int_param() {
			meta.switch_count = 64 - hdr.ipv4.ttl + 1;
			meta.sampling_space_q = 3;
			meta.sampling_space_hop = 2;
			meta.sampling_space_egress_tst = 1;
		}

		action set_egress_port(bit<9> port) {
	        standard_metadata.egress_spec = port;
			hdr.ipv4.ttl=hdr.ipv4.ttl-1;
    	}

		action drop(){
			mark_to_drop(standard_metadata);
		}

		// // PINT
		// table dmac{
		// 		key={
		// 				hdr.ipv4.dstAddr: exact;
		// 		}
		// 		actions={
		// 				forward;
		// 				NoAction;
		// 		}
		// 		size=256;
		// 		default_action=NoAction;
		// }

		// table ttl_rules{
		// 		key={
		// 				hdr.ipv4.ttl: exact;
		// 		}
		// 		actions={
		// 				copy_to_metadata;
		// 				NoAction;
		// 		}
		// 		size=256;
		// 		default_action=NoAction;
		// }

		// Chanbin: FAT_INT
		table tb_set_param {
			key={
				meta.switch_count : exact;
				meta.sampling_space_q : exact;
				meta.sampling_space_hop : exact;
				meta.sampling_space_egress_tst : exact;
			}
			actions={
				set_param;
				NoAction();
			}
			size=256;
			default_action=NoAction;
		}

		table tb_set_source {
        	key = {
				hdr.ipv4.dscp : exact; // test for FAT-INT
            	// update with source node characteristic 
        	}
        	actions = {
	            int_set_source;
    	        NoAction();
        	}
        	const default_action = NoAction();
        	size = MAX_PORTS;
   		}

		table tb_forward {
			key = {
				standard_metadata.ingress_port: exact;
			}
			actions = {
				set_egress_port;
				drop;
			}
			const default_action = drop();
		}

		apply {
				// Chanbin: FAT_INT
				tb_set_source.apply();
				
				// Chanbin: FAT_INT
				hash(meta.global_hash1, HashAlgorithm.crc32, (bit<1>)0, {hdr.ipv4.identification,meta.switch_count},(bit<48>)1000000);

				if (meta.source && meta.global_hash1 <= 100000){
					hdr.fat_int_q_1.setValid();
					// hdr.fat_int_q_2.setValid();
					// hdr.fat_int_q_3.setValid();
					hdr.fat_int_hop_latency_1.setValid();
					// hdr.fat_int_hop_latency_2.setValid();
					hdr.fat_int_egress_timestamp_1.setValid();
					hdr.ipv4.totalLen = hdr.ipv4.totalLen + 19;
					// hdr.ipv4.totalLen = hdr.ipv4.totalLen + 34;
				}
				if(!meta.source && hdr.fat_int_q_1.isValid()){
					if(!hdr.fat_int_q_2.isValid()){
						hdr.fat_int_q_2.setValid();
						hdr.fat_int_hop_latency_2.setValid();
						hdr.ipv4.totalLen = hdr.ipv4.totalLen + 10;
						hdr.ipv4.dscp = hdr.ipv4.dscp + 1;
					}
					if(hdr.fat_int_q_2.isValid() && !hdr.fat_int_q_3.isValid()){
						hdr.fat_int_q_3.setValid();
						hdr.ipv4.totalLen = hdr.ipv4.totalLen + 5;
						hdr.ipv4.dscp = hdr.ipv4.dscp + 1;
					}

				}
				int_param();
				tb_set_param.apply();

				tb_forward.apply();
				

				// PINT
				// ttl_rules.apply();
				// dmac.apply();
		}
}

/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyEgress(inout headers hdr,
								 inout metadata meta,
								 inout standard_metadata_t standard_metadata) {
		apply {
				// Chanbin: FAT_INT
				hash(meta.global_hash, HashAlgorithm.crc32, (bit<1>)0, {hdr.ipv4.identification,meta.switch_count},(bit<48>)1000000);
				// q_depth
				if (!hdr.fat_int_q_3.isValid()){
					if(!hdr.fat_int_q_2.isValid()){
						if(!hdr.fat_int_q_1.isValid()){
							return;
						}
						hdr.fat_int_q_1.q_occupancy = (bit<24>)standard_metadata.deq_qdepth;
						hdr.fat_int_q_1.switch_id = (bit<8>) meta.switch_count;
					}
					else{
						hdr.fat_int_q_2.q_occupancy = (bit<24>)standard_metadata.deq_qdepth;
						hdr.fat_int_q_2.switch_id = (bit<8>) meta.switch_count;
					}
				}
				else {
					if(meta.switch_count == 3){
						hdr.fat_int_q_3.q_occupancy = (bit<24>)standard_metadata.deq_qdepth;
						hdr.fat_int_q_3.switch_id = (bit<8>) meta.switch_count;
					}
					else{
						if(meta.global_hash <= meta.approximation_q) {
							if (meta.remainder_q == 1) {
								hdr.fat_int_q_1.q_occupancy = (bit<24>)standard_metadata.deq_qdepth;
								hdr.fat_int_q_1.switch_id = (bit<8>) meta.switch_count;
							}
							if (meta.remainder_q == 2) {
								hdr.fat_int_q_2.q_occupancy = (bit<24>)standard_metadata.deq_qdepth;
								hdr.fat_int_q_2.switch_id = (bit<8>) meta.switch_count;
							}
							if (meta.remainder_q == 0) {
								hdr.fat_int_q_3.q_occupancy = (bit<24>)standard_metadata.deq_qdepth;
								hdr.fat_int_q_3.switch_id = (bit<8>) meta.switch_count;
							}
						}
					}
				}

				// Hop latency
				if(!hdr.fat_int_hop_latency_2.isValid()){
					hdr.fat_int_hop_latency_1.hop_latency = (bit<32>) standard_metadata.egress_global_timestamp - (bit<32>) standard_metadata.ingress_global_timestamp;
					hdr.fat_int_hop_latency_1.switch_id = (bit<8>) meta.switch_count;
				}
				else{
					if(meta.switch_count ==2){
						hdr.fat_int_hop_latency_2.hop_latency = (bit<32>) standard_metadata.egress_global_timestamp - (bit<32>) standard_metadata.ingress_global_timestamp;
						hdr.fat_int_hop_latency_2.switch_id = (bit<8>) meta.switch_count;						
					}
					else{
						if(meta.global_hash <= meta.approximation_hop){
							if (meta.remainder_hop == 1) {
								hdr.fat_int_hop_latency_1.hop_latency = (bit<32>) standard_metadata.egress_global_timestamp - (bit<32>) standard_metadata.ingress_global_timestamp;
								hdr.fat_int_hop_latency_1.switch_id = (bit<8>) meta.switch_count;
							}
							if (meta.remainder_hop == 0) {
								hdr.fat_int_hop_latency_2.hop_latency = (bit<32>) standard_metadata.egress_global_timestamp - (bit<32>) standard_metadata.ingress_global_timestamp;
								hdr.fat_int_hop_latency_2.switch_id = (bit<8>) meta.switch_count;
							}
						}
					}
					
				}
				

				//egress timestamp
				if (hdr.fat_int_egress_timestamp_1.isValid() && meta.switch_count == 1){
					hdr.fat_int_egress_timestamp_1.egress_timestamp = (bit<64>)standard_metadata.egress_global_timestamp;
					hdr.fat_int_egress_timestamp_1.switch_id = (bit<8>) meta.switch_count;
				}
				else{
					if(meta.global_hash <= meta.approximation_egress) {
						hdr.fat_int_egress_timestamp_1.egress_timestamp = (bit<64>)standard_metadata.egress_global_timestamp;
						hdr.fat_int_egress_timestamp_1.switch_id = (bit<8>) meta.switch_count;
					}
				}		

				// hdr.ipv4.ecn=1;
		}
}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers hdr, inout metadata meta) {
		apply {

		}
}

/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {
		apply {
				//parsed headers have to be added again into the packet.
				packet.emit(hdr.switch_to_cpu);
				packet.emit(hdr.ethernet);
				packet.emit(hdr.ipv4);
				packet.emit(hdr.fat_int_q_1);
				packet.emit(hdr.fat_int_q_2);
				packet.emit(hdr.fat_int_q_3);
				packet.emit(hdr.fat_int_hop_latency_1);
				packet.emit(hdr.fat_int_hop_latency_2);
				packet.emit(hdr.fat_int_egress_timestamp_1);
		}
}

/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/
//switch architecture
V1Switch(
		MyParser(),
		MyVerifyChecksum(),
		MyIngress(),
		MyEgress(),
		MyComputeChecksum(),
		MyDeparser()
) main;
