#ifndef __HEADERS__
#define __HEADERS__

header ethernet_t {
    bit<48> dst_addr;
    bit<48> src_addr;
    bit<16> ether_type;
}
const bit<8> ETH_HEADER_LEN = 14; // 1 for 8bits

header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<6>  dscp;
    bit<2>  ecn;
    bit<16> len;
    bit<16> identification;
    bit<3>  flags;
    bit<13> frag_offset;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> hdr_checksum;
    bit<32> src_addr;
    bit<32> dst_addr;
}
const bit<8> IPV4_MIN_HEAD_LEN = 20;

header tcp_t {
    bit<16> src_port; //2
    bit<16> dst_port; //2
    bit<32> seq_no; //4
    bit<32> ack_no; //4
    bit<4>  data_offset; 
    bit<3>  res;
    bit<3>  ecn;
    bit<6>  ctrl; //2
    bit<16> window; //2
    bit<16> checksum; //2
    bit<16> urgent_ptr; //2
    // bit<16> length_; //2_Chanbin_add for QINT
}

const bit<8> TCP_HEADER_LEN = 20;

header udp_t {
    bit<16> src_port;
    bit<16> dst_port;
    bit<16> length_;
    bit<16> checksum;
}
const bit<8> UDP_HEADER_LEN = 8;

#endif
