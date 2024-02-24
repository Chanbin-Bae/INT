control process_int_transit (
    inout headers hdr,
    inout local_metadata_t local_metadata,
    inout standard_metadata_t standard_metadata) {

    

    action init_metadata(switch_id_t switch_id) {
        local_metadata.int_meta.transit = true;
        local_metadata.int_meta.switch_id = switch_id;
    }

    action int_set_header_0() { //switch_id
        hdr.int_switch_id.setValid();
        hdr.int_switch_id.switch_id = local_metadata.int_meta.switch_id;
    }
    
    action int_set_header_1() { //level1_port_id
        hdr.int_level1_port_ids.setValid();
        hdr.int_level1_port_ids.ingress_port_id = (bit<16>) standard_metadata.ingress_port;
        hdr.int_level1_port_ids.egress_port_id = (bit<16>) standard_metadata.egress_port;
    }
   
    action int_set_header_2() { //hop_latency
        hdr.int_hop_latency.setValid();
        hdr.int_hop_latency.hop_latency = (bit<32>) standard_metadata.egress_global_timestamp - (bit<32>) standard_metadata.ingress_global_timestamp;
    }
  
    action int_set_header_3() { //q_occupancy
        // TODO: Support egress queue ID
        hdr.int_q_occupancy.setValid();
        hdr.int_q_occupancy.q_id =0;
        // (bit<8>) standard_metadata.egress_qid;
        hdr.int_q_occupancy.q_occupancy = (bit<24>) standard_metadata.deq_qdepth;
    }
  
    action int_set_header_4() { //ingress_tstamp
        hdr.int_ingress_tstamp.setValid();
        hdr.int_ingress_tstamp.ingress_tstamp = (bit<64>)standard_metadata.ingress_global_timestamp;
    }
   
    action int_set_header_5() { //egress_timestamp
        hdr.int_egress_tstamp.setValid();
        hdr.int_egress_tstamp.egress_tstamp = (bit<64>)standard_metadata.egress_global_timestamp;
    }
   
    action int_set_header_6() { //level2_port_id
        hdr.int_level2_port_ids.setValid();
        // level2_port_id indicates Logical port ID
        hdr.int_level2_port_ids.ingress_port_id = (bit<32>) standard_metadata.ingress_port;
        hdr.int_level2_port_ids.egress_port_id = (bit<32>) standard_metadata.egress_port;
     }
   
    action int_set_header_7() { //egress_port_tx_utilization
        // TODO: implement tx utilization support in BMv2
        hdr.int_egress_tx_util.setValid();
        hdr.int_egress_tx_util.egress_port_tx_util =
        // (bit<32>) queueing_metadata.tx_utilization;
        0;
    }


    // Actions to keep track of the new metadata added.
   
    action add_1() {
        local_metadata.int_meta.new_words = local_metadata.int_meta.new_words + 1;
        local_metadata.int_meta.new_bytes = local_metadata.int_meta.new_bytes + 4;
    }

    
    action add_2() {
        local_metadata.int_meta.new_words = local_metadata.int_meta.new_words + 2;
        local_metadata.int_meta.new_bytes = local_metadata.int_meta.new_bytes + 8;
    }

    
    action add_3() {
        local_metadata.int_meta.new_words = local_metadata.int_meta.new_words + 3;
        local_metadata.int_meta.new_bytes = local_metadata.int_meta.new_bytes + 12;
    }

   
    action add_4() {
        local_metadata.int_meta.new_words = local_metadata.int_meta.new_words + 4;
       local_metadata.int_meta.new_bytes = local_metadata.int_meta.new_bytes + 16;
    }

    action add_5() {
        local_metadata.int_meta.new_words = local_metadata.int_meta.new_words + 5;
        local_metadata.int_meta.new_bytes = local_metadata.int_meta.new_bytes + 20;
    }

    action add_6() {
        local_metadata.int_meta.new_words = local_metadata.int_meta.new_words + 6;
        local_metadata.int_meta.new_bytes = local_metadata.int_meta.new_bytes + 24;
    }

    action add_7() {
        local_metadata.int_meta.new_words = local_metadata.int_meta.new_words + 7;
        local_metadata.int_meta.new_bytes = local_metadata.int_meta.new_bytes + 28;
    }
     /* action function for bits 0-3 combinations, 0 is msb, 3 is lsb */
     /* Each bit set indicates that corresponding INT header should be added */
    
     action int_set_header_0003_i0() {
     }
    
     action int_set_header_0003_i1() {
        int_set_header_3();
        add_1();
    }
    
    action int_set_header_0003_i2() {
        int_set_header_2();
        add_1();
    }
    
    action int_set_header_0003_i3() {
        int_set_header_3();
        int_set_header_2();
        add_2();
    }
    
    action int_set_header_0003_i4() {
        int_set_header_1();
        add_1();
    }
   
    action int_set_header_0003_i5() {
        int_set_header_3();
        int_set_header_1();
        add_2();
    }
    
    action int_set_header_0003_i6() {
        int_set_header_2();
        int_set_header_1();
        add_2();
    }
    
    action int_set_header_0003_i7() {
        int_set_header_3();
        int_set_header_2();
        int_set_header_1();
        add_3();
    }
    
    action int_set_header_0003_i8() {
        int_set_header_0();
        add_1();
    }
    
    action int_set_header_0003_i9() {
        int_set_header_3();
        int_set_header_0();
        add_2();
    }
    
    action int_set_header_0003_i10() {
        int_set_header_2();
        int_set_header_0();
        add_2();
    }
    
    action int_set_header_0003_i11() {
        int_set_header_3();
        int_set_header_2();
        int_set_header_0();
        add_3();
    }
    
    action int_set_header_0003_i12() {
        int_set_header_1();
        int_set_header_0();
        add_2();
    }
   
    action int_set_header_0003_i13() {
        int_set_header_3();
        int_set_header_1();
        int_set_header_0();
        add_3();
    }
    
    action int_set_header_0003_i14() {
        int_set_header_2();
        int_set_header_1();
        int_set_header_0();
        add_3();
    }
    
    action int_set_header_0003_i15() {
        int_set_header_3();
        int_set_header_2();
        int_set_header_1();
        int_set_header_0();
        add_4();
    }

     /* action function for bits 4-7 combinations, 4 is msb, 7 is lsb */
    action int_set_header_0407_i0() {
    }
    
    action int_set_header_0407_i1() {
        int_set_header_7();
        add_1();
    }
    
    action int_set_header_0407_i2() {
        int_set_header_6();
        add_2();
    }
    
    action int_set_header_0407_i3() {
        int_set_header_7();
        int_set_header_6();
        add_3();
    }
    
    action int_set_header_0407_i4() {
        int_set_header_5();
        add_2();
    }
    
    action int_set_header_0407_i5() {
        int_set_header_7();
        int_set_header_5();
        add_3();
    }
    
    action int_set_header_0407_i6() {
        int_set_header_6();
        int_set_header_5();
        add_4();
    }
    
    action int_set_header_0407_i7() {
        int_set_header_7();
        int_set_header_6();
        int_set_header_5();
        add_5();
    }
    
    action int_set_header_0407_i8() {
        int_set_header_4();
        add_2();
    }
    
    action int_set_header_0407_i9() {
        int_set_header_7();
        int_set_header_4();
        add_3();
    }
    
    action int_set_header_0407_i10() {
        int_set_header_6();
        int_set_header_4();
        add_4();
    }
    
    action int_set_header_0407_i11() {
        int_set_header_7();
        int_set_header_6();
        int_set_header_4();
        add_5();
    }
    
    action int_set_header_0407_i12() {
        int_set_header_5();
        int_set_header_4();
        add_4();
    }
   
    action int_set_header_0407_i13() {
        int_set_header_7();
        int_set_header_5();
        int_set_header_4();
        add_5();
    }
    
    action int_set_header_0407_i14() {
        int_set_header_6();
        int_set_header_5();
        int_set_header_4();
        add_6();
    }
    
    action int_set_header_0407_i15() {
        int_set_header_7();
        int_set_header_6();
        int_set_header_5();
        int_set_header_4();
        add_7();
    }

    // Chanbin_QINT

    action add_1_QINT() {
        local_metadata.int_meta.new_words = local_metadata.int_meta.new_words + 1;
        local_metadata.int_meta.new_bytes = local_metadata.int_meta.new_bytes + 4;
    }

    action set_interval(bit<12> inter1_q, bit<12> inter2_q, bit<12> inter3_q,
                        bit<12> inter4_q, bit<12> inter5_q, bit<32> inter1_hop, 
                        bit<32> inter2_hop, bit<32> inter3_hop, bit<32> inter4_hop, bit<32> inter5_hop){
        // queue depth
        local_metadata.Qint_meta.interval1_q = inter1_q;
        local_metadata.Qint_meta.interval2_q = inter2_q;
        local_metadata.Qint_meta.interval3_q = inter3_q;
        local_metadata.Qint_meta.interval4_q = inter4_q;
        local_metadata.Qint_meta.interval5_q = inter5_q;

        // hop latency
        local_metadata.Qint_meta.interval1_hop = inter1_hop;
        local_metadata.Qint_meta.interval2_hop = inter2_hop;
        local_metadata.Qint_meta.interval3_hop = inter3_hop;
        local_metadata.Qint_meta.interval4_hop = inter4_hop;
        local_metadata.Qint_meta.interval5_hop = inter5_hop;
    }

    table tb_set_interval{
        key = {
            hdr.int_header.instruction_mask_0811 : exact;
        }
        actions = {
            set_interval;
            NoAction;
        }
        default_action = NoAction();
    }
    
    action insert_Qint1() {
        hdr.intl4_shim.quan_flag_q=2;
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header << (hdr.intl4_shim.quan_flag_q-1);
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header + 0b10;
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header << 1;
        
        local_metadata.Qint_meta.QINT_meta_q = hdr.QINT1.QINT_ttl_header;
    }
    action insert_Qint2() {
        hdr.intl4_shim.quan_flag_q=3;
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header << (hdr.intl4_shim.quan_flag_q-1);
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header + 0b111;
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header << 1;

        local_metadata.Qint_meta.QINT_meta_q = hdr.QINT1.QINT_ttl_header;
        // add_1_QINT();
    }
    action insert_Qint3() {
        // hdr.QINT1.setValid();
        // hdr.QINT1.QINT_ttl_header=0b11000;
        hdr.intl4_shim.quan_flag_q=4;
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header << (hdr.intl4_shim.quan_flag_q-1);
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header + 0b1100;
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header << 1;
        
        // hdr.QINT1.QINT_ttl_header=24;
        local_metadata.Qint_meta.QINT_meta_q = hdr.QINT1.QINT_ttl_header;
        // add_1_QINT();
    }
    action insert_Qint4() {
        // hdr.QINT1.setValid();
        // hdr.QINT1.QINT_ttl_header=0b110110;
        hdr.intl4_shim.quan_flag_q=5;
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header << (hdr.intl4_shim.quan_flag_q-1);
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header + 0b11011;
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header << 1;
        
        // hdr.QINT1.QINT_ttl_header=54;
        local_metadata.Qint_meta.QINT_meta_q = hdr.QINT1.QINT_ttl_header;
        // add_1_QINT();
    }
    action insert_Qint5() {
        // hdr.QINT1.setValid();
        // hdr.QINT1.QINT_ttl_header=0b1101000;
        hdr.intl4_shim.quan_flag_q=6;
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header << (hdr.intl4_shim.quan_flag_q-1);
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header + 0b110100;
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header << 1;
        
        // hdr.QINT1.QINT_ttl_header=104;
        local_metadata.Qint_meta.QINT_meta_q = hdr.QINT1.QINT_ttl_header;
        // add_1_QINT();
    }
    action insert_Qint6() {
        // hdr.QINT1.setValid();
        // hdr.QINT1.QINT_ttl_header=0b1101010;
        hdr.intl4_shim.quan_flag_q=6;
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header << (hdr.intl4_shim.quan_flag_q-1);
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header + 0b110101;
        hdr.QINT1.QINT_ttl_header = hdr.QINT1.QINT_ttl_header << 1;
        
        // hdr.QINT1.QINT_ttl_header=106;
        local_metadata.Qint_meta.QINT_meta_q = hdr.QINT1.QINT_ttl_header;
        // add_1_QINT();
    }

    action insert_Qint1_hop() {
        hdr.intl4_shim.quan_flag_hop=2;
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header << (hdr.intl4_shim.quan_flag_hop-1);
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header + 0b10;
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header << 1;
    }
    action insert_Qint2_hop() {
        hdr.intl4_shim.quan_flag_hop=3;
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header << (hdr.intl4_shim.quan_flag_hop-1);
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header + 0b111;
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header << 1;
    }
    action insert_Qint3_hop() {
        hdr.intl4_shim.quan_flag_hop=4;
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header << (hdr.intl4_shim.quan_flag_hop-1);
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header + 0b1100;
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header << 1;
    }
    
    action insert_Qint4_hop() {
        // hdr.QINT1_hop.setValid();
        // hdr.QINT1_hop.QINT_ttl_header=0b110110;
        hdr.intl4_shim.quan_flag_hop=5;
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header << (hdr.intl4_shim.quan_flag_hop-1);
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header + 0b11011;
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header << 1;
        
        // hdr.QINT1.QINT_ttl_header=54;
        // local_metadata.Qint_meta.QINT_meta_hop = hdr.QINT1_hop.QINT_ttl_header;
        // add_1_QINT();
    }
    action insert_Qint5_hop() {
        // hdr.QINT1_hop.setValid();
        // hdr.QINT1_hop.QINT_ttl_header=0b1101000;
        hdr.intl4_shim.quan_flag_hop=6;
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header << (hdr.intl4_shim.quan_flag_hop-1);
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header + 0b110100;
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header << 1;
        
        // hdr.QINT1.QINT_ttl_header=104;
        // local_metadata.Qint_meta.QINT_meta_hop = hdr.QINT1_hop.QINT_ttl_header;
        // add_1_QINT();
    }
    action insert_Qint6_hop() {
        // hdr.QINT1_hop.setValid();
        // hdr.QINT1_hop.QINT_ttl_header=0b1101010;
        hdr.intl4_shim.quan_flag_hop=6;
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header << (hdr.intl4_shim.quan_flag_hop-1);
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header + 0b110101;
        hdr.QINT1_hop.QINT_ttl_header = hdr.QINT1_hop.QINT_ttl_header << 1;
        
        // hdr.QINT1.QINT_ttl_header=106;
        // local_metadata.Qint_meta.QINT_meta_hop = hdr.QINT1_hop.QINT_ttl_header;
        // add_1_QINT();
    }

    // Default action used to set switch ID.
    table tb_int_insert {
        actions = {
            init_metadata;
            NoAction;
        }
        default_action = NoAction();
        size = 1;
    }

    /* Table to process instruction bits 0-3 */
    table tb_int_inst_0003 {
        key = {
            hdr.int_header.instruction_mask_0003 : exact;
        }
        actions = {
            int_set_header_0003_i0;
            int_set_header_0003_i1;
            int_set_header_0003_i2;
            int_set_header_0003_i3;
            int_set_header_0003_i4;
            int_set_header_0003_i5;
            int_set_header_0003_i6;
            int_set_header_0003_i7;
            int_set_header_0003_i8;
            int_set_header_0003_i9;
            int_set_header_0003_i10;
            int_set_header_0003_i11;
            int_set_header_0003_i12;
            int_set_header_0003_i13;
            int_set_header_0003_i14;
            int_set_header_0003_i15;
        }
        
        const entries = {
            (0x0) : int_set_header_0003_i0();
            (0x1) : int_set_header_0003_i1();
            (0x2) : int_set_header_0003_i2();
            (0x3) : int_set_header_0003_i3();
            (0x4) : int_set_header_0003_i4();
            (0x5) : int_set_header_0003_i5();
            (0x6) : int_set_header_0003_i6();
            (0x7) : int_set_header_0003_i7();
            (0x8) : int_set_header_0003_i8();
            (0x9) : int_set_header_0003_i9();
            (0xA) : int_set_header_0003_i10();
            (0xB) : int_set_header_0003_i11();
            (0xC) : int_set_header_0003_i12();
            (0xD) : int_set_header_0003_i13();
            (0xE) : int_set_header_0003_i14();
            (0xF) : int_set_header_0003_i15();
        }
    }

    /* Table to process instruction bits 4-7 */
     table tb_int_inst_0407 {
        key = {
            hdr.int_header.instruction_mask_0407 : exact;
        }
        actions = {
            int_set_header_0407_i0;
            int_set_header_0407_i1;
            int_set_header_0407_i2;
            int_set_header_0407_i3;
            int_set_header_0407_i4;
            int_set_header_0407_i5;
            int_set_header_0407_i6;
            int_set_header_0407_i7;
            int_set_header_0407_i8;
            int_set_header_0407_i9;
            int_set_header_0407_i10;
            int_set_header_0407_i11;
            int_set_header_0407_i12;
            int_set_header_0407_i13;
            int_set_header_0407_i14;
            int_set_header_0407_i15;
        }
        
        const entries = {
            (0x0) : int_set_header_0407_i0();
            (0x1) : int_set_header_0407_i1();
            (0x2) : int_set_header_0407_i2();
            (0x3) : int_set_header_0407_i3();
            (0x4) : int_set_header_0407_i4();
            (0x5) : int_set_header_0407_i5();
            (0x6) : int_set_header_0407_i6();
            (0x7) : int_set_header_0407_i7();
            (0x8) : int_set_header_0407_i8();
            (0x9) : int_set_header_0407_i9();
            (0xA) : int_set_header_0407_i10();
            (0xB) : int_set_header_0407_i11();
            (0xC) : int_set_header_0407_i12();
            (0xD) : int_set_header_0407_i13();
            (0xE) : int_set_header_0407_i14();
            (0xF) : int_set_header_0407_i15();
        }
    }


    apply {
        tb_int_insert.apply();
        if (local_metadata.int_meta.transit == false) {
            return;
        }
        if (local_metadata.int_meta.source == true){
            hdr.QINT1.setValid();
            hdr.QINT1_hop.setValid();
        }
        tb_int_inst_0003.apply();
        tb_int_inst_0407.apply();
        // Chanbin_QINT
        local_metadata.Qint_meta.QINT_meta_hop = (bit<32>) standard_metadata.egress_global_timestamp - (bit<32>) standard_metadata.ingress_global_timestamp;

        // Insert interval data from control plane
        tb_set_interval.apply();

        if ((bit<12>) standard_metadata.deq_qdepth==0){
            insert_Qint2();
        }
        if ((bit<12>) standard_metadata.deq_qdepth!=0 && 
            (bit<12>) standard_metadata.deq_qdepth < local_metadata.Qint_meta.interval1_q) {
            insert_Qint2();
        }
        if (local_metadata.Qint_meta.interval1_q <= (bit<12>) standard_metadata.deq_qdepth && 
            (bit<12>) standard_metadata.deq_qdepth < local_metadata.Qint_meta.interval2_q){
            insert_Qint1();
        }
        if (local_metadata.Qint_meta.interval2_q <= (bit<12>) standard_metadata.deq_qdepth && 
            (bit<12>) standard_metadata.deq_qdepth < local_metadata.Qint_meta.interval3_q){
            insert_Qint3();
        }
        if (local_metadata.Qint_meta.interval3_q <= (bit<12>) standard_metadata.deq_qdepth && 
            (bit<12>) standard_metadata.deq_qdepth < local_metadata.Qint_meta.interval4_q){
            insert_Qint4();
        }
        if (local_metadata.Qint_meta.interval4_q <= (bit<12>) standard_metadata.deq_qdepth && (bit<12>) standard_metadata.deq_qdepth < local_metadata.Qint_meta.interval5_q){
            insert_Qint5();
        }
        if (local_metadata.Qint_meta.interval5_q <= (bit<12>) standard_metadata.deq_qdepth){
            insert_Qint6();
        }

        //// for quantizing hop latency
        if (local_metadata.Qint_meta.QINT_meta_hop==0){
            insert_Qint3_hop();
        }
        if (local_metadata.Qint_meta.QINT_meta_hop!=0 && local_metadata.Qint_meta.QINT_meta_hop < local_metadata.Qint_meta.interval1_hop) {
            insert_Qint3_hop();
        }
        if (local_metadata.Qint_meta.interval1_hop <= local_metadata.Qint_meta.QINT_meta_hop && local_metadata.Qint_meta.QINT_meta_hop < local_metadata.Qint_meta.interval2_hop){
            insert_Qint1_hop();
        }
        if (local_metadata.Qint_meta.interval2_hop <= local_metadata.Qint_meta.QINT_meta_hop && local_metadata.Qint_meta.QINT_meta_hop < local_metadata.Qint_meta.interval3_hop){
            insert_Qint2_hop();
        }
        if (local_metadata.Qint_meta.interval3_hop <= local_metadata.Qint_meta.QINT_meta_hop && local_metadata.Qint_meta.QINT_meta_hop < local_metadata.Qint_meta.interval4_hop){
            insert_Qint4_hop();
        }
        if (local_metadata.Qint_meta.interval4_hop <= local_metadata.Qint_meta.QINT_meta_hop && local_metadata.Qint_meta.QINT_meta_hop < local_metadata.Qint_meta.interval5_hop){
            insert_Qint5_hop();
        }
        if (local_metadata.Qint_meta.interval5_hop <= local_metadata.Qint_meta.QINT_meta_hop){
            insert_Qint6_hop();
        }

        // Decrement remaining hop cnt
        hdr.int_header.remaining_hop_cnt = hdr.int_header.remaining_hop_cnt - 1;

        // Update headers lengths.
        if (hdr.ipv4.isValid()) {
            hdr.ipv4.len = hdr.ipv4.len + local_metadata.int_meta.new_bytes;
        }
        if (hdr.udp.isValid()) {
            hdr.udp.length_ = hdr.udp.length_ + local_metadata.int_meta.new_bytes;
        }
        if(hdr.tcp.isValid()){
            hdr.tcp_length_.length_ = hdr.tcp_length_.length_ + local_metadata.int_meta.new_bytes;
        }
        if (hdr.intl4_shim.isValid()) {
            hdr.intl4_shim.len = hdr.intl4_shim.len + local_metadata.int_meta.new_words;
        }
    }
}