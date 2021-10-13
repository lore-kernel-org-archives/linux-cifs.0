Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08019C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Oct 2021 08:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE2A260FDA
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Oct 2021 08:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhJMIKy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbhJMIKy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Oct 2021 04:10:54 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85396C061570
        for <linux-cifs@vger.kernel.org>; Wed, 13 Oct 2021 01:08:50 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id h19so2834207uax.5
        for <linux-cifs@vger.kernel.org>; Wed, 13 Oct 2021 01:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=86xTQSo/pKY2BTMt8+IdJQd+Y2AqHXA66quWI//azE4=;
        b=Er+KTcdzH2wQnXcdcChopNOdkwwlFABRioBDCL+FRS6hU52OsL9oZYTGNpx6rYDUsL
         4sgCWlEhrEIZZ8dQu4tpCipVWCYdKCWi7HcPNfclxKRlODqa8zXWnobYUosOqGc3riq2
         KthU+NQ4ArNzHNUSvB4gT5B3yygoG6AGl4bRzTIH7vY+oBYgfAJGJMtUvYVdYqHprgvd
         2tW+Dkw16bKoOV+fz4HJ3zeB/lf/Ksi/mKI+XEMiN5h8JStLNOf7WGRkhbrkptOkA1CI
         KiPaAlHkcctMOxjQKCkx2Crs1M2FNxEuVOvvnxIDHYKWQFMHbJsbmBEDk3vEGF55XfmS
         FZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=86xTQSo/pKY2BTMt8+IdJQd+Y2AqHXA66quWI//azE4=;
        b=mpnJ2x7CduNbE2g49VWNcb0zGUomBStP8c1MWcy151dSDftY27F/I7pQmy5SWV27KU
         MVnQ/Sa1clA5XBCwHaUSxSrZA7/IbNIFvApuTSSM3ASGU/cD5XsOOwfFuiTWxxM7oacr
         t42/SQbZ2LAovMErmS6yk6hwAXNCv/JQuw/5oLHpg0OMHUqi5sEUgYKPDMxIFyPDX0x8
         +3pr2HVdVIMRtkwFoTnev3Y7Y39AuHHpgvQed5EDadxf8K2vVPTd3mG0noNyKePaZK5S
         v2QBBg9nS4QmjG/40EqfPcxf7/LfRGTHF98JG6yn4H7TpS3oSKD+GYE4Zeki+WDGwwOi
         SAPQ==
X-Gm-Message-State: AOAM530LamLiFQNH3QHMY88tbLKCZsdJ/dY2z/NI8FQc7KVBrIGSWNUH
        kU7DWcrfp6FNCI7Cp5oKadDxKevpMt+jYsku1ibacDUlcds=
X-Google-Smtp-Source: ABdhPJz9vSJtsd/HqI4rzrUFgiwHm9gF53Y7KyZjMJwnvx/4cuGpsJ9uOL7SNqk8dPLBW3ReVoZwnOTelor29xLxJu0=
X-Received: by 2002:ab0:29da:: with SMTP id i26mr27586691uaq.129.1634112529486;
 Wed, 13 Oct 2021 01:08:49 -0700 (PDT)
MIME-Version: 1.0
From:   "Diederick C. Niehorster" <dcnieho@gmail.com>
Date:   Wed, 13 Oct 2021 10:08:31 +0200
Message-ID: <CABcAi1gfBefYh+2Qok5Z-=05TVGkgRMkog4HG4Pa_0+H7A22aw@mail.gmail.com>
Subject: [question] how to set up SMB direct connection with Windows server
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

I am running latest firmware on a QLogic/Cavium/Marvell QL41112HLRJ,
and inbox Linux drivers. I'm using Ubuntu 21.04, kernel
5.11.0-37-generic.

I am trying to connect to an SMB share on a Windows Server 2019
machine from the Ubuntu machine, but am unable to get an RDMA
connection going. After having recompiled the kernel with
CONFIG_CIFS_SMB_DIRECT=y (default is n), trying to connect with
$ sudo mount -t cifs --verbose -o
rdma,multichannel,vers=3.1.1,username=***,password=***
//10.0.1.45/scratch /mnt/test
i get:

$ dmesg:
[ 1484.306940] CIFS: Attempting to mount \\10.0.1.45\scratch
[ 1484.310637] CIFS: VFS: _smbd_get_connection:1556 warning: device
max_send_sge = 4 too small
[ 1484.310647] CIFS: VFS: _smbd_get_connection:1559 Queue Pair creation may fail
[ 1484.310651] CIFS: VFS: _smbd_get_connection:1562 warning: device
max_recv_sge = 4 too small
[ 1484.310655] CIFS: VFS: _smbd_get_connection:1565 Queue Pair creation may fail
[ 1484.310793] [qedr_check_qp_attrs:1230(qedr0)]create qp: unsupported
send_sge=0x10 requested (max_send_sge=0x4)
[ 1484.310799] CIFS: VFS: _smbd_get_connection:1602 rdma_create_qp failed -22

Is there a way i can increase this max_send_sge under Linux, or is
there some other (e.g. cifs) configuration i should do? SMB Direct
works well Windows Server -> Windows Server.

Thanks and all the best,
Dee

Further info that may be relevant:

$ dmesg | grep qed
[   1.408266] QLogic FastLinQ 4xxxx Core Module qed 8.37.0.20
[   1.416589] qede_init: QLogic FastLinQ 4xxxx Ethernet Driver qede 8.37.0.20
[   1.768448] qede 0000:19:00.0: no suspend buffer for PTM
[   2.061021] qede 19:00.00: Storm FW 8.42.2.0, Management FW
8.55.43.0 [MBI 8.55.24] [eth0]
[   2.148912] qede 19:00.01: Storm FW 8.42.2.0, Management FW
8.55.43.0 [MBI 8.55.24] [eth1]
[   2.157843] qede 0000:19:00.0 enp25s0f0: renamed from eth0
[   2.188371] qede 0000:19:00.1 enp25s0f1: renamed from eth1
[   8.917308] [qede_link_update:2495(enp25s0f0)]Link is up
[   8.947363] [qede_link_update:2495(enp25s0f1)]Link is up
[ 1481.149961] qedr: discovered and registered 2 RDMA funcs

$ lsmod | grep qed
qedr 110592 0
ib_uverbs 151552 2 rdma_ucm,qedr
ib_core 364544 6 rdma_cm,iw_cm,rdma_ucm,ib_uverbs,qedr,ib_cm
qede 151552 1 qedr
qed 700416 2 qede,qedr
crc8 16384 1 qed

$ mount.cifs -V
mount.cifs version: 6.11

$ ibv_devinfo -d qedr0 -v
hca_id:   qedr0
   transport:         iWARP (1)
   fw_ver:            8.42.2.0
   node_guid:         f6e9:d4ff:fe73:6fec
   sys_image_guid:         f6e9:d4ff:fe73:6fec
   vendor_id:         0x1077
   vendor_part_id:         32880
   hw_ver:            0x0
   phys_port_cnt:         1
   max_mr_size:         0x10000000000
   page_size_cap:         0xfffff000
   max_qp:            7936
   max_qp_wr:         32767
   device_cap_flags:      0x00209080
               CURR_QP_STATE_MOD
               RC_RNR_NAK_GEN
               MEM_MGT_EXTENSIONS
               Unknown flags: 0x8000
   max_sge:         4
   max_sge_rd:         4
   max_cq:            7936
   max_cqe:         8388480
   max_mr:            131070
   max_pd:            65536
   max_qp_rd_atom:         32
   max_ee_rd_atom:         0
   max_res_rd_atom:      0
   max_qp_init_rd_atom:      32
   max_ee_init_rd_atom:      0
   atomic_cap:         ATOMIC_GLOB (2)
   max_ee:            0
   max_rdd:         0
   max_mw:            0
   max_raw_ipv6_qp:      0
   max_raw_ethy_qp:      0
   max_mcast_grp:         0
   max_mcast_qp_attach:      0
   max_total_mcast_qp_attach:   0
   max_ah:            8192
   max_fmr:         0
   max_srq:         8192
   max_srq_wr:         32767
   max_srq_sge:         0
   max_pkeys:         0
   local_ca_ack_delay:      15
   general_odp_caps:
   rc_odp_caps:
               NO SUPPORT
   uc_odp_caps:
               NO SUPPORT
   ud_odp_caps:
               NO SUPPORT
   xrc_odp_caps:
               NO SUPPORT
   completion_timestamp_mask not supported
   core clock not supported
   device_cap_flags_ex:      0x209080
   tso_caps:
      max_tso:         0
   rss_caps:
      max_rwq_indirection_tables:         0
      max_rwq_indirection_table_size:         0
      rx_hash_function:            0x0
      rx_hash_fields_mask:            0x0
   max_wq_type_rq:         0
   packet_pacing_caps:
      qp_rate_limit_min:   0kbps
      qp_rate_limit_max:   0kbps
   tag matching not supported
      port:   1
         state:         PORT_ACTIVE (4)
         max_mtu:      4096 (5)
         active_mtu:      1024 (3)
         sm_lid:         0
         port_lid:      0
         port_lmc:      0x00
         link_layer:      Ethernet
         max_msg_sz:      0x80000000
         port_cap_flags:      0x04000000
         port_cap_flags2:   0x0000
         max_vl_num:      8 (4)
         bad_pkey_cntr:      0x0
         qkey_viol_cntr:      0x0
         sm_sl:         0
         pkey_tbl_len:      0
         gid_tbl_len:      1
         subnet_timeout:      0
         init_type_reply:   0
         active_width:      1X (1)
         active_speed:      10.0 Gbps (4)
