Return-Path: <SRS0=ymiT=25=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5489FC282DD
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 17:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD37320692
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jan 2020 17:46:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="s556KwjA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgAHRqp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Jan 2020 12:46:45 -0500
Received: from mx.cjr.nz ([51.158.111.142]:47752 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727237AbgAHRqo (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 8 Jan 2020 12:46:44 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 494E2808C0;
        Wed,  8 Jan 2020 17:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1578505600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3QylBbRfWDCbMsYCvZkm3Vtu5HUQDbvJK1JENBcGXeA=;
        b=s556KwjAziocQTAnMqWgvMVcESMHZYnpW4wRTQhsHAuhMdOcICn/ZdP+i4PYL+TuWLkENy
        WODRAif3/J1oA9yxOr2EVzdvbG/39rcsqKxRItNn7ouYsuXbOjcwVMogEV1+0fgwBRUhZG
        Q6zKqr3HuYzEbiydZyO6jAUlkFHQ9X7vivEgLUshnaz9mmRt0FFghAF7+DJPSMpfmkxnkY
        EJerhgmah7vETfNGNRmsFZS7g2LvOloMMHwR1V+ZY9KPAL/4/1poiOPPd/NBskwGRtrxq+
        K5fTgBnSUv5cQK315qx6AEOQLklt2l9mWXszMuo5zvX0BHKQR88HrW5/s8WENA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: cifs.upcall requests ticket for wrong host when using dfs
In-Reply-To: <VE1PR02MB55502AA359141C1D29B2AB82F53F0@VE1PR02MB5550.eurprd02.prod.outlook.com>
References: <39643d7d-2abb-14d3-ced6-c394fab9a777@prodrive-technologies.com>
 <87png0boej.fsf@cjr.nz>
 <5260c45c-0a31-168d-f9db-83bb6bd4a2cf@prodrive-technologies.com>
 <878smoqouf.fsf@cjr.nz>
 <VE1PR02MB55503665681374E805CA7815F53C0@VE1PR02MB5550.eurprd02.prod.outlook.com>
 <87k16417ud.fsf@cjr.nz>
 <VE1PR02MB55502AA359141C1D29B2AB82F53F0@VE1PR02MB5550.eurprd02.prod.outlook.com>
Date:   Wed, 08 Jan 2020 14:46:35 -0300
Message-ID: <87y2uh264k.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Martijn,

Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:

> I applied your patch to 5.4.6 and it seems to work. I attached
> the logs.
>
> Regards, Martijn
> [  136.127704] fs/cifs/cifsfs.c: Devname: //prodrive.nl/product flags: 0
> [  136.127730] fs/cifs/connect.c: Username: mdg
> [  136.127732] fs/cifs/connect.c: file mode: 0x180  dir mode: 0x1c0
> [  136.127733] fs/cifs/connect.c: CIFS VFS: in mount_get_conns as Xid: 0 with uid: 0
> [  136.127734] fs/cifs/connect.c: UNC: \\prodrive.nl\product
> [  136.127738] fs/cifs/connect.c: Socket created
> [  136.127739] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo 0x6d6
> [  136.218000] fs/cifs/fscache.c: cifs_fscache_get_client_cookie: (0x000000002e5e09ad/0x00000000a24dc876)
> [  136.218003] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1 with uid: 0
> [  136.218004] fs/cifs/connect.c: Existing smb sess not found
> [  136.218006] fs/cifs/smb2pdu.c: Negotiate protocol
> [  136.218053] fs/cifs/transport.c: Sending smb: smb_len=106
> [  136.218092] fs/cifs/connect.c: Demultiplex PID: 997
> [  136.308600] fs/cifs/connect.c: RFC1002 header 0xf8
> [  136.308606] fs/cifs/smb2misc.c: SMB2 data length 120 offset 128
> [  136.308606] fs/cifs/smb2misc.c: SMB2 len 248
> [  136.308615] fs/cifs/transport.c: cifs_sync_mid_result: cmd=0 mid=0 state=4
> [  136.308618] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [  136.308620] fs/cifs/smb2pdu.c: mode 0x3
> [  136.308620] fs/cifs/smb2pdu.c: negotiated smb3.0 dialect
> [  136.308623] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
> [  136.308624] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
> [  136.308625] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
> [  136.308625] fs/cifs/asn1.c: OID len = 8 oid = 0x1 0x2 0x348 0x1bb92
> [  136.308626] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
> [  136.308628] fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x300067 TimeAdjust: 0
> [  136.308628] fs/cifs/smb2pdu.c: Session Setup
> [  136.308629] fs/cifs/smb2pdu.c: sess setup type 5
> [  136.308632] fs/cifs/cifs_spnego.c: key description = ver=0x2;host=prodrive.nl;ip4=10.122.0.2;sec=krb5;uid=0x2713;creduid=0x2713;user=mdg;pid=0x3e3
> [  136.350435] fs/cifs/transport.c: Sending smb: smb_len=6934
> [  136.445159] fs/cifs/connect.c: RFC1002 header 0x5e
> [  136.445164] fs/cifs/smb2misc.c: SMB2 data length 22 offset 72
> [  136.445165] fs/cifs/smb2misc.c: SMB2 len 94
> [  136.445174] fs/cifs/transport.c: cifs_sync_mid_result: cmd=1 mid=1 state=4
> [  136.445176] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [  136.445447] fs/cifs/smb2pdu.c: SMB2/3 session established successfully
> [  136.445468] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1) rc = 0
> [  136.445471] fs/cifs/connect.c: CIFS VFS: in cifs_setup_ipc as Xid: 2 with uid: 0
> [  136.445471] fs/cifs/smb2pdu.c: TCON
> [  136.445549] fs/cifs/transport.c: Sending smb: smb_len=114
> [  136.534452] fs/cifs/connect.c: RFC1002 header 0x50
> [  136.534457] fs/cifs/smb2misc.c: SMB2 len 80
> [  136.534459] fs/cifs/smb2ops.c: add 64 credits total=193
> [  136.534467] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3 mid=2 state=4
> [  136.534471] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [  136.534473] fs/cifs/smb2pdu.c: connection to pipe share
> [  136.534474] fs/cifs/smb2pdu.c: validate negotiate
> [  136.534475] fs/cifs/smb2pdu.c: SMB2 IOCTL
> [  136.534483] fs/cifs/transport.c: Sending smb: smb_len=152
> [  136.623924] fs/cifs/connect.c: RFC1002 header 0x88
> [  136.623929] fs/cifs/smb2misc.c: SMB2 data length 24 offset 112
> [  136.623930] fs/cifs/smb2misc.c: SMB2 len 136
> [  136.623931] fs/cifs/smb2ops.c: add 10 credits total=202
> [  136.623940] fs/cifs/transport.c: cifs_sync_mid_result: cmd=11 mid=3 state=4
> [  136.623944] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [  136.623946] fs/cifs/smb2pdu.c: validate negotiate info successful
> [  136.623947] fs/cifs/connect.c: CIFS VFS: leaving cifs_setup_ipc (xid = 2) rc = 0
> [  136.623948] fs/cifs/connect.c: IPC tcon rc = 0 ipc tid = 1
> [  136.623951] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 3 with uid: 0
> [  136.623951] fs/cifs/smb2pdu.c: TCON
> [  136.623958] fs/cifs/transport.c: Sending smb: smb_len=120
> [  136.713129] fs/cifs/connect.c: RFC1002 header 0x48
> [  136.713134] fs/cifs/smb2misc.c: SMB2 len 73
> [  136.713135] fs/cifs/smb2misc.c: Calculated size 73 length 72 mismatch mid 4
> [  136.713137] fs/cifs/smb2ops.c: add 64 credits total=265
> [  136.713145] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3 mid=4 state=4
> [  136.713150] Status code returned 0xc00000cc STATUS_BAD_NETWORK_NAME
> [  136.713152] fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc00000cc to POSIX err -2
> [  136.713153] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [  136.713155] CIFS VFS:  BAD_NETWORK_NAME: \\prodrive.nl\product
> [  136.713158] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 3) rc = -2
> [  136.713158] fs/cifs/connect.c: Tcon rc = -2
> [  136.713160] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\prodrive.nl\product
> [  136.713161] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\prodrive.nl\product
> [  136.713161] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\prodrive.nl\product
> [  136.713162] fs/cifs/dfs_cache.c: do_dfs_cache_find: search path: \prodrive.nl\product
> [  136.713163] fs/cifs/dfs_cache.c: do_dfs_cache_find: cache miss
> [  136.713164] fs/cifs/dfs_cache.c: do_dfs_cache_find: DFS referral request for \prodrive.nl\product
> [  136.713165] fs/cifs/smb2ops.c: smb2_get_dfs_refer: path: \prodrive.nl\product
> [  136.713167] fs/cifs/smb2pdu.c: SMB2 IOCTL
> [  136.713175] fs/cifs/transport.c: Sending smb: smb_len=168
> [  136.808067] fs/cifs/connect.c: RFC1002 header 0x48
> [  136.808072] fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
> [  136.808073] fs/cifs/smb2misc.c: SMB2 len 73
> [  136.808074] fs/cifs/smb2misc.c: Calculated size 73 length 72 mismatch mid 5
> [  136.849885] fs/cifs/connect.c: RFC1002 header 0x178
> [  136.849890] fs/cifs/smb2misc.c: SMB2 data length 264 offset 112
> [  136.849890] fs/cifs/smb2misc.c: SMB2 len 376
> [  136.849892] fs/cifs/smb2ops.c: add 0 credits total=274
> [  136.849900] fs/cifs/transport.c: cifs_sync_mid_result: cmd=11 mid=5 state=4
> [  136.849904] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [  136.849907] fs/cifs/misc.c: num_referrals: 2 dfs flags: 0x3 ...
> [  136.849971] fs/cifs/dfs_cache.c: do_dfs_cache_find: new cache entry
> [  136.849973] fs/cifs/dfs_cache.c: setup_ref: set up new ref
> [  136.854069] fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: DC03.Prodrive.nl to 10.1.1.3
> [  136.854096] fs/cifs/connect.c: Username: mdg
> [  136.854098] fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
> [  136.854099] fs/cifs/connect.c: CIFS VFS: in cifs_free_ipc as Xid: 4 with uid: 0
> [  136.854100] fs/cifs/smb2pdu.c: Tree Disconnect
> [  136.854100] fs/cifs/connect.c: CIFS VFS: leaving cifs_free_ipc (xid = 4) rc = -5
> [  136.854101] fs/cifs/connect.c: failed to disconnect IPC tcon (rc=-5)
> [  136.854102] fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 5 with uid: 0
> [  136.854103] fs/cifs/smb2pdu.c: disconnect session 000000006a8935cd
> [  136.854113] fs/cifs/transport.c: Sending smb: smb_len=72
> [  136.943308] fs/cifs/connect.c: RFC1002 header 0x44
> [  136.943334] fs/cifs/smb2misc.c: SMB2 len 68
> [  136.943336] fs/cifs/smb2ops.c: add 2 credits total=275
> [  136.943346] fs/cifs/transport.c: cifs_sync_mid_result: cmd=2 mid=6 state=4
> [  136.943357] fs/cifs/fscache.c: cifs_fscache_release_client_cookie: (0x000000002e5e09ad/0x00000000a24dc876)
> [  136.943360] fs/cifs/connect.c: CIFS VFS: leaving mount_put_conns (xid = 0) rc = 0
> [  136.943361] fs/cifs/connect.c: CIFS VFS: in mount_get_conns as Xid: 6 with uid: 0
> [  136.943362] fs/cifs/connect.c: UNC: \\DC03.Prodrive.nl\product
> [  136.943397] fs/cifs/connect.c: Socket created
> [  136.943398] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo 0x6d6
> [  136.944679] fs/cifs/fscache.c: cifs_fscache_get_client_cookie: (0x00000000a8a74f56/0x00000000f19082dc)
> [  136.944681] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 7 with uid: 0
> [  136.944682] fs/cifs/connect.c: Existing smb sess not found
> [  136.944684] fs/cifs/smb2pdu.c: Negotiate protocol
> [  136.944742] fs/cifs/transport.c: Sending smb: smb_len=106
> [  136.944797] fs/cifs/connect.c: Demultiplex PID: 1006
> [  136.946353] fs/cifs/connect.c: RFC1002 header 0xf8
> [  136.946357] fs/cifs/smb2misc.c: SMB2 data length 120 offset 128
> [  136.946357] fs/cifs/smb2misc.c: SMB2 len 248
> [  136.946361] fs/cifs/transport.c: cifs_sync_mid_result: cmd=0 mid=0 state=4
> [  136.946365] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [  136.946366] fs/cifs/smb2pdu.c: mode 0x3
> [  136.946366] fs/cifs/smb2pdu.c: negotiated smb3.0 dialect
> [  136.946368] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
> [  136.946369] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
> [  136.946370] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
> [  136.946370] fs/cifs/asn1.c: OID len = 8 oid = 0x1 0x2 0x348 0x1bb92
> [  136.946371] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
> [  136.946372] fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x300067 TimeAdjust: 0
> [  136.946373] fs/cifs/smb2pdu.c: Session Setup
> [  136.946374] fs/cifs/smb2pdu.c: sess setup type 5
> [  136.946376] fs/cifs/cifs_spnego.c: key description = ver=0x2;host=DC03.Prodrive.nl;ip4=10.1.1.3;sec=krb5;uid=0x2713;creduid=0x2713;user=mdg;pid=0x3e3
> [  136.970808] fs/cifs/transport.c: Sending smb: smb_len=6932
> [  136.974794] fs/cifs/connect.c: RFC1002 header 0x5e
> [  136.974799] fs/cifs/smb2misc.c: SMB2 data length 22 offset 72
> [  136.974799] fs/cifs/smb2misc.c: SMB2 len 94
> [  136.974807] fs/cifs/transport.c: cifs_sync_mid_result: cmd=1 mid=1 state=4
> [  136.974808] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [  136.974817] fs/cifs/smb2pdu.c: SMB2/3 session established successfully
> [  136.974820] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 7) rc = 0
> [  136.974822] fs/cifs/connect.c: CIFS VFS: in cifs_setup_ipc as Xid: 8 with uid: 0
> [  136.974823] fs/cifs/smb2pdu.c: TCON
> [  136.974918] fs/cifs/transport.c: Sending smb: smb_len=124
> [  136.975758] fs/cifs/smb2ops.c: add 64 credits total=193
> [  136.975763] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3 mid=2 state=4
> [  136.975765] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [  136.975766] fs/cifs/smb2pdu.c: connection to pipe share
> [  136.975766] fs/cifs/smb2pdu.c: validate negotiate
> [  136.975767] fs/cifs/smb2pdu.c: SMB2 IOCTL
> [  136.976540] fs/cifs/smb2misc.c: SMB2 data length 24 offset 112
> [  136.976541] fs/cifs/smb2ops.c: add 10 credits total=202
> [  136.976547] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [  136.976548] fs/cifs/smb2pdu.c: validate negotiate info successful
> [  136.976549] fs/cifs/connect.c: CIFS VFS: leaving cifs_setup_ipc (xid = 8) rc = 0
> [  136.976550] fs/cifs/connect.c: IPC tcon rc = 0 ipc tid = 1
> [  136.976552] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 9 with uid: 0
> [  136.976552] fs/cifs/smb2pdu.c: TCON
> [  136.977343] fs/cifs/smb2ops.c: add 64 credits total=265
> [  136.977349] fs/cifs/smb2pdu.c: connection to disk share
> [  136.977350] fs/cifs/smb2pdu.c: validate negotiate
> [  136.977350] fs/cifs/smb2pdu.c: SMB2 IOCTL
> [  136.978933] fs/cifs/smb2misc.c: SMB2 data length 24 offset 112
> [  136.978935] fs/cifs/smb2ops.c: add 10 credits total=274
> [  136.978941] fs/cifs/smb2pdu.c: validate negotiate info successful
> [  136.978942] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 9) rc = 0
> [  136.978942] fs/cifs/connect.c: Tcon rc = 0
> [  136.978945] fs/cifs/fscache.c: cifs_fscache_get_super_cookie: (0x00000000f19082dc/0x00000000655aa9a5)
> [  136.978946] fs/cifs/smb2pdu.c: create/open
> [  136.979795] fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
> [  136.979797] fs/cifs/smb2ops.c: add 10 credits total=283
> [  136.979825] fs/cifs/smb2pdu.c: SMB2 IOCTL
> [  136.980780] fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 0
> [  136.980781] fs/cifs/smb2ops.c: parse_server_interfaces: speed 10000000000 bps
> [  136.980782] fs/cifs/smb2ops.c: parse_server_interfaces: capabilities 0x00000000
> [  136.980782] fs/cifs/smb2ops.c: parse_server_interfaces: ipv6 fe80:0000:0000:0000:6142:6b8c:505e:61e3
> [  136.980783] fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 1
> [  136.980783] fs/cifs/smb2ops.c: parse_server_interfaces: speed 10000000000 bps
> [  136.980784] fs/cifs/smb2ops.c: parse_server_interfaces: capabilities 0x00000000
> [  136.980784] fs/cifs/smb2ops.c: parse_server_interfaces: ipv4 10.1.1.3
> [  136.980785] fs/cifs/smb2pdu.c: Query FSInfo level 5
> [  136.981679] fs/cifs/smb2pdu.c: Query FSInfo level 4
> [  136.982424] fs/cifs/smb2pdu.c: Query FSInfo level 1
> [  136.983120] fs/cifs/smb2pdu.c: Query FSInfo level 11
> [  136.983817] fs/cifs/smb2pdu.c: Close
> [  136.984520] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\DC03.Prodrive.nl\product
> [  136.984522] fs/cifs/dfs_cache.c: do_dfs_cache_find: search path: \DC03.Prodrive.nl\product
> [  136.984522] fs/cifs/dfs_cache.c: do_dfs_cache_find: cache miss
> [  136.984523] fs/cifs/dfs_cache.c: do_dfs_cache_find: DFS referral request for \DC03.Prodrive.nl\product
> [  136.984524] fs/cifs/smb2ops.c: smb2_get_dfs_refer: path: \DC03.Prodrive.nl\product
> [  136.984526] fs/cifs/smb2pdu.c: SMB2 IOCTL
> [  136.985285] fs/cifs/misc.c: num_referrals: 2 dfs flags: 0x3 ...
> [  136.985305] fs/cifs/dfs_cache.c: do_dfs_cache_find: new cache entry
> [  136.985308] fs/cifs/connect.c: is_path_remote: full_path: 
> [  136.985309] fs/cifs/smb2pdu.c: create/open
> [  136.986108] fs/cifs/smb2pdu.c: Close
> [  136.986899] fs/cifs/smb2pdu.c: create/open
> [  136.987694] fs/cifs/smb2pdu.c: Close
> [  136.988408] fs/cifs/connect.c: cifs_put_tcon: tc_count=2
> [  136.988410] fs/cifs/dfs_cache.c: dfs_cache_add_vol: fullpath: \\prodrive.nl\product
> [  136.988411] fs/cifs/dfs_cache.c: dup_vol: vol->UNC: \\DC03.Prodrive.nl\product
> [  136.988413] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 6) rc = 0
> [  136.988466] fs/cifs/inode.c: CIFS VFS: in cifs_root_iget as Xid: 10 with uid: 0
> [  136.988467] fs/cifs/inode.c: Getting info on 
> [  136.989266] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 20
> [  136.989277] fs/cifs/inode.c: looking for uniqueid=121
> [  136.989283] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 121
> [  136.989284] fs/cifs/inode.c: cifs_revalidate_cache: inode 121 is new
> [  136.989285] fs/cifs/inode.c: CIFS VFS: leaving cifs_root_iget (xid = 10) rc = 0
> [  136.989287] fs/cifs/cifsfs.c: Get root dentry for 
> [  136.989288] fs/cifs/cifsfs.c: dentry root is: 000000004f317897
> [  136.995007] fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 11 with uid: 0
> [  136.996207] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 23
> [  136.996217] fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 11) rc = 0
> [  136.996494] =========================================
> [  136.996585] fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 12 with uid: 10003
> [  136.996586] fs/cifs/dir.c: parent inode = 0x0000000074ab6cc8 name is: KAES6309 and dentry = 0x00000000f6dd221f
> [  136.996587] fs/cifs/dir.c: name: \KAES6309
> [  136.996588] fs/cifs/dir.c: NULL inode in lookup
> [  136.996588] fs/cifs/dir.c: Full path: \KAES6309 inode = 0x00000000a979baf8
> [  136.996590] fs/cifs/inode.c: Getting info on \KAES6309
> [  136.997333] fs/cifs/smb2misc.c: Calculated size 73 length 72 mismatch mid 24
> [  136.997336] fs/cifs/smb2misc.c: Calculated size 73 length 72 mismatch mid 25
> [  136.997337] fs/cifs/smb2misc.c: Calculated size 73 length 72 mismatch mid 26
> [  136.997344] Status code returned 0xc0000257 STATUS_PATH_NOT_COVERED
> [  136.997346] fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000257 to POSIX err -66
> [  136.997349] fs/cifs/inode.c: creating fake fattr for DFS referral
> [  136.997350] fs/cifs/inode.c: looking for uniqueid=122
> [  136.997354] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 122
> [  136.997354] fs/cifs/inode.c: cifs_revalidate_cache: inode 122 is new
> [  136.997356] fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid = 12) rc = 0
> [  136.997363] fs/cifs/cifs_dfs_ref.c: in cifs_dfs_d_automount
> [  136.997364] fs/cifs/cifs_dfs_ref.c: in cifs_dfs_do_automount
> [  136.997365] fs/cifs/dir.c: name: \KAES6309
> [  136.997365] fs/cifs/cifs_dfs_ref.c: cifs_dfs_do_automount: full_path: \\DC03.Prodrive.nl\product\KAES6309
> [  136.997366] fs/cifs/cifs_dfs_ref.c: cifs_dfs_do_automount: root path: \\DC03.Prodrive.nl\product
> [  136.997367] fs/cifs/cifs_dfs_ref.c: CIFS VFS: in cifs_dfs_do_automount as Xid: 13 with uid: 10003
> [  136.997368] fs/cifs/dfs_cache.c: do_dfs_cache_find: search path: \DC03.Prodrive.nl\product
> [  136.997369] fs/cifs/dfs_cache.c: do_dfs_cache_find: search path: \DC03.Prodrive.nl\product\KAES6309
> [  136.997369] fs/cifs/dfs_cache.c: do_dfs_cache_find: cache miss
> [  136.997370] fs/cifs/dfs_cache.c: do_dfs_cache_find: DFS referral request for \DC03.Prodrive.nl\product\KAES6309
> [  136.997371] fs/cifs/smb2ops.c: smb2_get_dfs_refer: path: \DC03.Prodrive.nl\product\KAES6309
> [  136.997374] fs/cifs/smb2pdu.c: SMB2 IOCTL
> [  136.998437] fs/cifs/misc.c: num_referrals: 1 dfs flags: 0x2 ...
> [  136.998444] fs/cifs/dfs_cache.c: do_dfs_cache_find: new cache entry
> [  136.998446] fs/cifs/cifs_dfs_ref.c: CIFS VFS: leaving cifs_dfs_do_automount (xid = 13) rc = 0
> [  136.998451] fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: DC03.Prodrive.nl to 10.1.1.3
> [  136.998456] fs/cifs/cifsfs.c: Devname: //DC03.Prodrive.nl/product/KAES6309 flags: 67108864
> [  136.998480] fs/cifs/connect.c: Username: mdg
> [  136.998481] fs/cifs/connect.c: file mode: 0x180  dir mode: 0x1c0
> [  136.998483] fs/cifs/connect.c: CIFS VFS: in mount_get_conns as Xid: 14 with uid: 10003
> [  136.998483] fs/cifs/connect.c: UNC: \\DC03.Prodrive.nl\product
> [  136.998484] fs/cifs/connect.c: Existing tcp session with server found
> [  136.998485] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 15 with uid: 10003
> [  136.998486] fs/cifs/connect.c: Existing smb sess found (status=1)
> [  136.998486] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 15) rc = 0
> [  136.998487] fs/cifs/connect.c: Found match on UNC path
> [  136.998488] fs/cifs/connect.c: cifs_put_smb_ses: ses_count=2
> [  136.998489] fs/cifs/smb2pdu.c: create/open
> [  136.999299] fs/cifs/smb2pdu.c: SMB2 IOCTL
> [  137.000037] fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 0
> [  137.000038] fs/cifs/smb2ops.c: parse_server_interfaces: speed 10000000000 bps
> [  137.000038] fs/cifs/smb2ops.c: parse_server_interfaces: capabilities 0x00000000
> [  137.000039] fs/cifs/smb2ops.c: parse_server_interfaces: ipv6 fe80:0000:0000:0000:6142:6b8c:505e:61e3
> [  137.000040] fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 1
> [  137.000040] fs/cifs/smb2ops.c: parse_server_interfaces: speed 10000000000 bps
> [  137.000041] fs/cifs/smb2ops.c: parse_server_interfaces: capabilities 0x00000000
> [  137.000042] fs/cifs/smb2ops.c: parse_server_interfaces: ipv4 10.1.1.3
> [  137.000043] fs/cifs/smb2pdu.c: Query FSInfo level 5
> [  137.000707] fs/cifs/smb2pdu.c: Query FSInfo level 4
> [  137.001283] fs/cifs/smb2pdu.c: Query FSInfo level 1
> [  137.002059] fs/cifs/smb2pdu.c: Query FSInfo level 11
> [  137.002769] fs/cifs/smb2pdu.c: Close
> [  137.003707] fs/cifs/dfs_cache.c: do_dfs_cache_find: search path: \DC03.Prodrive.nl\product
> [  137.003709] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\DC03.Prodrive.nl\product
> [  137.003710] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\DC03.Prodrive.nl\product\KAES6309
> [  137.003710] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\DC03.Prodrive.nl\product\KAES6309
> [  137.003711] fs/cifs/dfs_cache.c: do_dfs_cache_find: search path: \DC03.Prodrive.nl\product
> [  137.003712] fs/cifs/dfs_cache.c: setup_ref: set up new ref
> [  137.005919] fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: DC01.Prodrive.nl to 10.1.1.14
> [  137.005945] fs/cifs/connect.c: Username: mdg
> [  137.005947] fs/cifs/connect.c: cifs_put_tcon: tc_count=2
> [  137.005948] fs/cifs/connect.c: CIFS VFS: leaving mount_put_conns (xid = 14) rc = 0
> [  137.005949] fs/cifs/connect.c: CIFS VFS: in mount_get_conns as Xid: 16 with uid: 10003
> [  137.005949] fs/cifs/connect.c: UNC: \\DC01.Prodrive.nl\product
> [  137.005954] fs/cifs/connect.c: Socket created
> [  137.005955] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo 0x6d6
> [  137.006957] fs/cifs/fscache.c: cifs_fscache_get_client_cookie: (0x00000000a2b4dca0/0x00000000a7cf54d0)
> [  137.006959] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 17 with uid: 10003
> [  137.006960] fs/cifs/connect.c: Existing smb sess not found
> [  137.006961] fs/cifs/smb2pdu.c: Negotiate protocol
> [  137.007018] fs/cifs/connect.c: Demultiplex PID: 1009
> [  137.008087] fs/cifs/smb2pdu.c: mode 0x3
> [  137.008088] fs/cifs/smb2pdu.c: negotiated smb3.0 dialect
> [  137.008091] fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x300067 TimeAdjust: 0
> [  137.008092] fs/cifs/smb2pdu.c: Session Setup
> [  137.008092] fs/cifs/smb2pdu.c: sess setup type 5
> [  137.008095] fs/cifs/cifs_spnego.c: key description = ver=0x2;host=DC01.Prodrive.nl;ip4=10.1.1.14;sec=krb5;uid=0x2713;creduid=0x2713;user=mdg;pid=0x3c3
> [  137.035566] fs/cifs/smb2pdu.c: SMB2/3 session established successfully
> [  137.035569] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 17) rc = 0
> [  137.035572] fs/cifs/connect.c: CIFS VFS: in cifs_setup_ipc as Xid: 18 with uid: 10003
> [  137.035573] fs/cifs/smb2pdu.c: TCON
> [  137.036412] fs/cifs/smb2pdu.c: connection to pipe share
> [  137.036413] fs/cifs/smb2pdu.c: validate negotiate
> [  137.036414] fs/cifs/smb2pdu.c: SMB2 IOCTL
> [  137.037312] fs/cifs/smb2pdu.c: validate negotiate info successful
> [  137.037314] fs/cifs/connect.c: CIFS VFS: leaving cifs_setup_ipc (xid = 18) rc = 0
> [  137.037314] fs/cifs/connect.c: IPC tcon rc = 0 ipc tid = 1
> [  137.037316] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 19 with uid: 10003
> [  137.037316] fs/cifs/smb2pdu.c: TCON
> [  137.038118] fs/cifs/smb2pdu.c: connection to disk share
> [  137.038119] fs/cifs/smb2pdu.c: validate negotiate
> [  137.038119] fs/cifs/smb2pdu.c: SMB2 IOCTL
> [  137.038970] fs/cifs/smb2pdu.c: validate negotiate info successful
> [  137.038972] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 19) rc = 0
> [  137.038972] fs/cifs/connect.c: Tcon rc = 0
> [  137.038975] fs/cifs/fscache.c: cifs_fscache_get_super_cookie: (0x00000000a7cf54d0/0x000000001c0618fa)
> [  137.038976] fs/cifs/smb2pdu.c: create/open
> [  137.040589] fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 0
> [  137.040590] fs/cifs/smb2ops.c: parse_server_interfaces: speed 10000000000 bps
> [  137.040591] fs/cifs/smb2ops.c: parse_server_interfaces: capabilities 0x00000000
> [  137.040591] fs/cifs/smb2ops.c: parse_server_interfaces: ipv6 fe80:0000:0000:0000:7d2b:8e78:9c7c:fc51
> [  137.040592] fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 1
> [  137.040592] fs/cifs/smb2ops.c: parse_server_interfaces: speed 10000000000 bps
> [  137.040593] fs/cifs/smb2ops.c: parse_server_interfaces: capabilities 0x00000000
> [  137.040594] fs/cifs/smb2ops.c: parse_server_interfaces: ipv4 10.1.1.14
> [  137.040594] fs/cifs/smb2pdu.c: Query FSInfo level 5
> [  137.041182] fs/cifs/smb2pdu.c: Query FSInfo level 4
> [  137.043458] fs/cifs/smb2pdu.c: Close
> [  137.044105] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\DC01.Prodrive.nl\product
> [  137.044106] fs/cifs/dfs_cache.c: do_dfs_cache_find: search path: \DC01.Prodrive.nl\product
> [  137.044107] fs/cifs/dfs_cache.c: do_dfs_cache_find: cache miss
> [  137.044108] fs/cifs/dfs_cache.c: do_dfs_cache_find: DFS referral request for \DC01.Prodrive.nl\product
> [  137.044109] fs/cifs/smb2ops.c: smb2_get_dfs_refer: path: \DC01.Prodrive.nl\product
> [  137.044857] fs/cifs/misc.c: num_referrals: 2 dfs flags: 0x3 ...
> [  137.044866] fs/cifs/dfs_cache.c: do_dfs_cache_find: new cache entry
> [  137.044868] fs/cifs/connect.c: is_path_remote: full_path: \KAES6309
> [  137.044870] fs/cifs/smb2pdu.c: create/open
> [  137.045617] fs/cifs/smb2misc.c: Calculated size 73 length 72 mismatch mid 14
> [  137.045623] Status code returned 0xc0000257 STATUS_PATH_NOT_COVERED
> [  137.045626] fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000257 to POSIX err -66
> [  137.045628] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\DC01.Prodrive.nl\product\KAES6309
> [  137.045628] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\DC01.Prodrive.nl\product\KAES6309
> [  137.045629] fs/cifs/dfs_cache.c: do_dfs_cache_find: search path: \DC01.Prodrive.nl\product\KAES6309
> [  137.045630] fs/cifs/dfs_cache.c: do_dfs_cache_find: cache miss
> [  137.045630] fs/cifs/dfs_cache.c: do_dfs_cache_find: DFS referral request for \DC01.Prodrive.nl\product\KAES6309
> [  137.045631] fs/cifs/smb2ops.c: smb2_get_dfs_refer: path: \DC01.Prodrive.nl\product\KAES6309
> [  137.046663] fs/cifs/misc.c: num_referrals: 1 dfs flags: 0x2 ...
> [  137.046669] fs/cifs/dfs_cache.c: do_dfs_cache_find: new cache entry
> [  137.046671] fs/cifs/dfs_cache.c: setup_ref: set up new ref
> [  137.048545] fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: str02 to 10.1.1.6
> [  137.048570] fs/cifs/connect.c: Username: mdg
> [  137.048572] fs/cifs/connect.c: cifs_put_tcon: tc_count=2
> [  137.048573] fs/cifs/connect.c: CIFS VFS: leaving mount_put_conns (xid = 16) rc = 0
> [  137.048574] fs/cifs/connect.c: CIFS VFS: in mount_get_conns as Xid: 20 with uid: 10003
> [  137.048574] fs/cifs/connect.c: UNC: \\str02\product1$
> [  137.048579] fs/cifs/connect.c: Socket created
> [  137.048580] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo 0x6d6
> [  137.049376] fs/cifs/fscache.c: cifs_fscache_get_client_cookie: (0x000000002233b96e/0x000000008c18fd1d)
> [  137.049378] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 21 with uid: 10003
> [  137.049379] fs/cifs/connect.c: Existing smb sess not found
> [  137.049380] fs/cifs/smb2pdu.c: Negotiate protocol
> [  137.049435] fs/cifs/connect.c: Demultiplex PID: 1012
> [  137.050549] fs/cifs/smb2pdu.c: mode 0x1
> [  137.050550] fs/cifs/smb2pdu.c: negotiated smb3.0 dialect
> [  137.050552] fs/cifs/connect.c: Security Mode: 0x1 Capabilities: 0x300077 TimeAdjust: 0
> [  137.050553] fs/cifs/smb2pdu.c: Session Setup
> [  137.050554] fs/cifs/smb2pdu.c: sess setup type 5
> [  137.050556] fs/cifs/cifs_spnego.c: key description = ver=0x2;host=str02;ip4=10.1.1.6;sec=krb5;uid=0x2713;creduid=0x2713;user=mdg;pid=0x3c3
> [  137.076445] fs/cifs/smb2pdu.c: SMB2/3 session established successfully
> [  137.076450] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 21) rc = 0
> [  137.076452] fs/cifs/connect.c: CIFS VFS: in cifs_setup_ipc as Xid: 22 with uid: 10003
> [  137.076453] fs/cifs/smb2pdu.c: TCON
> [  137.077858] fs/cifs/smb2pdu.c: connection to pipe share
> [  137.077859] fs/cifs/smb2pdu.c: validate negotiate
> [  137.079297] fs/cifs/smb2pdu.c: validate negotiate info successful
> [  137.079299] fs/cifs/connect.c: CIFS VFS: leaving cifs_setup_ipc (xid = 22) rc = 0
> [  137.079300] fs/cifs/connect.c: IPC tcon rc = 0 ipc tid = 1
> [  137.079302] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 23 with uid: 10003
> [  137.079302] fs/cifs/smb2pdu.c: TCON
> [  137.080133] fs/cifs/smb2pdu.c: connection to disk share
> [  137.080133] fs/cifs/smb2pdu.c: validate negotiate
> [  137.081124] fs/cifs/smb2pdu.c: validate negotiate info successful
> [  137.081125] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 23) rc = 0
> [  137.081125] fs/cifs/connect.c: Tcon rc = 0
> [  137.081128] fs/cifs/fscache.c: cifs_fscache_get_super_cookie: (0x000000008c18fd1d/0x000000008958ea4b)
> [  137.081128] fs/cifs/smb2pdu.c: create/open
> [  137.083082] fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 0
> [  137.083083] fs/cifs/smb2ops.c: parse_server_interfaces: speed 20000000000 bps
> [  137.083084] fs/cifs/smb2ops.c: parse_server_interfaces: capabilities 0x00000001
> [  137.083085] fs/cifs/smb2ops.c: parse_server_interfaces: ipv4 10.1.1.6
> [  137.086177] fs/cifs/smb2pdu.c: Close
> [  137.086886] fs/cifs/connect.c: is_path_remote: full_path: \KAES6309
> [  137.086887] fs/cifs/smb2pdu.c: create/open
> [  137.087764] fs/cifs/smb2pdu.c: Close
> [  137.088474] fs/cifs/smb2pdu.c: create/open
> [  137.089175] fs/cifs/smb2pdu.c: Close
> [  137.089874] fs/cifs/smb2pdu.c: create/open
> [  137.090580] fs/cifs/smb2pdu.c: Close
> [  137.091293] fs/cifs/connect.c: cifs_put_tcon: tc_count=1
> [  137.091294] fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 24 with uid: 10003
> [  137.091295] fs/cifs/smb2pdu.c: Tree Disconnect
> [  137.091964] fs/cifs/fscache.c: cifs_fscache_release_super_cookie: (0x000000001c0618fa)
> [  137.091966] fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
> [  137.091967] fs/cifs/connect.c: CIFS VFS: in cifs_free_ipc as Xid: 25 with uid: 10003
> [  137.091967] fs/cifs/smb2pdu.c: Tree Disconnect
> [  137.091968] fs/cifs/connect.c: CIFS VFS: leaving cifs_free_ipc (xid = 25) rc = -5
> [  137.091968] fs/cifs/connect.c: failed to disconnect IPC tcon (rc=-5)
> [  137.091969] fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 26 with uid: 10003
> [  137.091970] fs/cifs/smb2pdu.c: disconnect session 0000000009690d1e
> [  137.092635] fs/cifs/fscache.c: cifs_fscache_release_client_cookie: (0x00000000a2b4dca0/0x00000000a7cf54d0)
> [  137.092638] fs/cifs/dfs_cache.c: dfs_cache_add_vol: fullpath: \\DC01.Prodrive.nl\product\KAES6309
> [  137.092639] fs/cifs/dfs_cache.c: dup_vol: vol->UNC: \\str02\product1$
> [  137.092640] fs/cifs/dfs_cache.c: dup_vol: vol->prepath: KAES6309
> [  137.092641] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 20) rc = 0
> [  137.092722] fs/cifs/inode.c: CIFS VFS: in cifs_root_iget as Xid: 27 with uid: 10003
> [  137.092724] fs/cifs/inode.c: Getting info on 
> [  137.093437] fs/cifs/smb2misc.c: Calculated size 190 length 192 mismatch mid 20
> [  137.093439] fs/cifs/smb2misc.c: Calculated size 124 length 128 mismatch mid 21
> [  137.093445] fs/cifs/inode.c: looking for uniqueid=123
> [  137.093452] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 123
> [  137.093452] fs/cifs/inode.c: cifs_revalidate_cache: inode 123 is new
> [  137.093453] fs/cifs/inode.c: CIFS VFS: leaving cifs_root_iget (xid = 27) rc = 0
> [  137.093455] fs/cifs/cifsfs.c: Get root dentry for \KAES6309
> [  137.093456] fs/cifs/dir.c: CIFS VFS: in cifs_lookup as Xid: 28 with uid: 10003
> [  137.093457] fs/cifs/dir.c: parent inode = 0x000000001835904b name is: KAES6309 and dentry = 0x0000000024c8b594
> [  137.093458] fs/cifs/dir.c: name: \KAES6309
> [  137.093459] fs/cifs/dir.c: NULL inode in lookup
> [  137.093460] fs/cifs/dir.c: Full path: \KAES6309 inode = 0x00000000a979baf8
> [  137.093460] fs/cifs/inode.c: Getting info on \KAES6309
> [  137.094200] fs/cifs/inode.c: looking for uniqueid=124
> [  137.094203] fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 124
> [  137.094203] fs/cifs/inode.c: cifs_revalidate_cache: inode 124 is new
> [  137.094204] fs/cifs/dir.c: CIFS VFS: leaving cifs_lookup (xid = 28) rc = 0
> [  137.094205] fs/cifs/cifsfs.c: dentry root is: 0000000024c8b594
> [  137.094211] fs/cifs/cifs_dfs_ref.c: cifs_dfs_do_automount: cifs_dfs_do_mount:\DC03.Prodrive.nl\product\KAES6309 , mnt:000000001bbef447
> [  137.094211] fs/cifs/cifs_dfs_ref.c: leaving cifs_dfs_do_automount
> [  137.094212] fs/cifs/cifs_dfs_ref.c: leaving cifs_dfs_d_automount [ok]

Thanks for testing it!

So far so good?

Let me know so I can prepare a patch for upstream.

Thanks,

Paulo
