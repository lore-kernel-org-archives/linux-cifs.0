Return-Path: <SRS0=4GOt=RW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51EC7C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 16:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 227E52077B
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 16:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfCSQ1F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Mar 2019 12:27:05 -0400
Received: from isilmar-4.linta.de ([136.243.71.142]:44898 "EHLO
        isilmar-4.linta.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfCSQ1F (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Mar 2019 12:27:05 -0400
Received: from light.dominikbrodowski.net (isilmar.linta [10.0.0.1])
        by isilmar-4.linta.de (Postfix) with ESMTPS id 3D4C12009CC;
        Tue, 19 Mar 2019 16:27:03 +0000 (UTC)
Received: by light.dominikbrodowski.net (Postfix, from userid 1000)
        id EEFCD215E0; Tue, 19 Mar 2019 17:26:45 +0100 (CET)
Date:   Tue, 19 Mar 2019 17:26:45 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org
Subject: Re: v5.1-rc1 cifs bug: underflow; use-after-free.
Message-ID: <20190319162645.GA3498@light.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k1gu6f3u.fsf@suse.com>
 <87mulq6g2e.fsf@suse.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Aurélien,

Thanks for taking a look at this issue. Fortunately, it is easily
reproducable (at least for me).

> If you enable verbose debugging [1], if my theory is correct you should
> see a lease break messsage followed by "clear cached root file handle"
> message before the warning.

Hm, no.

...
[ 2466.101770] fs/cifs/connect.c: Socket created
[ 2466.101813] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo 0x1b58
[ 2466.158066] fs/cifs/connect.c: Demultiplex PID: 3380
[ 2466.158074] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 1 with uid: 0
[ 2466.158302] fs/cifs/connect.c: Existing smb sess not found
[ 2466.158582] fs/cifs/smb2pdu.c: Negotiate protocol
[ 2466.159125] fs/cifs/transport.c: Sending smb: smb_len=106
[ 2466.196439] fs/cifs/connect.c: RFC1002 header 0xaa
[ 2466.196513] fs/cifs/smb2misc.c: SMB2 data length 42 offset 128
[ 2466.196565] fs/cifs/smb2misc.c: SMB2 len 170
[ 2466.196723] fs/cifs/transport.c: cifs_sync_mid_result: cmd=0 mid=0 state=4
[ 2466.196781] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2466.196838] fs/cifs/smb2pdu.c: mode 0x1
[ 2466.196882] fs/cifs/smb2pdu.c: negotiated smb2.0 dialect
[ 2466.196982] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
[ 2466.197038] fs/cifs/connect.c: Security Mode: 0x1 Capabilities: 0x300001 TimeAdjust: 0
[ 2466.197083] fs/cifs/smb2pdu.c: Session Setup
[ 2466.197132] fs/cifs/smb2pdu.c: sess setup type 4
[ 2466.197185] fs/cifs/transport.c: Sending smb: smb_len=124
[ 2466.243262] fs/cifs/connect.c: RFC1002 header 0xdc
[ 2466.243298] fs/cifs/smb2misc.c: SMB2 data length 148 offset 72
[ 2466.243305] fs/cifs/smb2misc.c: SMB2 len 220
[ 2466.243376] fs/cifs/transport.c: cifs_sync_mid_result: cmd=1 mid=1 state=4
[ 2466.243532] fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000016 to POSIX err -5
[ 2466.243542] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2466.243625] fs/cifs/smb2pdu.c: rawntlmssp session setup challenge phase
[ 2466.260371] fs/cifs/transport.c: Sending smb: smb_len=310
[ 2466.786417] fs/cifs/connect.c: RFC1002 header 0x48
[ 2466.786460] fs/cifs/smb2misc.c: SMB2 data length 0 offset 72
[ 2466.786469] fs/cifs/smb2misc.c: SMB2 len 73
[ 2466.786694] fs/cifs/smb2misc.c: Calculated size 73 length 72 mismatch mid 2
[ 2466.786810] fs/cifs/transport.c: cifs_sync_mid_result: cmd=1 mid=2 state=4
[ 2466.786828] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2466.787077] fs/cifs/smb2pdu.c: SMB2/3 session established successfully
[ 2466.787229] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 1) rc = 0
[ 2466.787373] fs/cifs/connect.c: CIFS VFS: in cifs_setup_ipc as Xid: 2 with uid: 0
[ 2466.787487] fs/cifs/smb2pdu.c: TCON
[ 2466.787675] fs/cifs/transport.c: Sending smb: smb_len=152
[ 2466.846776] fs/cifs/connect.c: RFC1002 header 0x50
[ 2466.846823] fs/cifs/smb2misc.c: SMB2 len 80
[ 2466.847300] fs/cifs/smb2ops.c: add 33 credits total=65
[ 2466.847382] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3 mid=3 state=4
[ 2466.847408] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2466.847527] fs/cifs/smb2pdu.c: connection to pipe share
[ 2466.847626] fs/cifs/connect.c: CIFS VFS: leaving cifs_setup_ipc (xid = 2) rc = 0
[ 2466.847716] fs/cifs/connect.c: IPC tcon rc = 0 ipc tid = 58268
[ 2466.847833] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 3 with uid: 0
[ 2466.847843] fs/cifs/smb2pdu.c: TCON
[ 2466.848031] fs/cifs/transport.c: Sending smb: smb_len=158
[ 2466.943307] fs/cifs/connect.c: RFC1002 header 0x50
[ 2466.943355] fs/cifs/smb2misc.c: SMB2 len 80
[ 2466.943373] fs/cifs/smb2ops.c: add 33 credits total=97
[ 2466.943467] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3 mid=4 state=4
[ 2466.943488] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2466.943666] fs/cifs/smb2pdu.c: connection to disk share
[ 2466.943766] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 3) rc = 0
[ 2466.943854] fs/cifs/connect.c: Tcon rc = 0
[ 2466.944054] fs/cifs/smb2pdu.c: create/open
[ 2466.944185] fs/cifs/transport.c: Sending smb: smb_len=132
[ 2466.993187] fs/cifs/connect.c: RFC1002 header 0x98
[ 2466.993254] fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
[ 2466.993270] fs/cifs/smb2misc.c: SMB2 len 153
[ 2466.993286] fs/cifs/smb2misc.c: Calculated size 153 length 152 mismatch mid 5
[ 2466.993307] fs/cifs/smb2ops.c: add 10 credits total=106
[ 2466.993414] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=5 state=4
[ 2466.993442] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2466.993738] fs/cifs/smb2pdu.c: Query FSInfo level 5
[ 2466.993870] fs/cifs/transport.c: Sending smb: smb_len=109
[ 2467.039768] fs/cifs/connect.c: RFC1002 header 0x5c
[ 2467.039822] fs/cifs/smb2misc.c: SMB2 data length 20 offset 72
[ 2467.039834] fs/cifs/smb2misc.c: SMB2 len 92
[ 2467.039851] fs/cifs/smb2ops.c: add 10 credits total=115
[ 2467.040006] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=6 state=4
[ 2467.040021] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2467.040039] fs/cifs/smb2pdu.c: Query FSInfo level 4
[ 2467.040105] fs/cifs/transport.c: Sending smb: smb_len=109
[ 2467.093835] fs/cifs/connect.c: RFC1002 header 0x50
[ 2467.093895] fs/cifs/smb2misc.c: SMB2 data length 8 offset 72
[ 2467.093909] fs/cifs/smb2misc.c: SMB2 len 80
[ 2467.094007] fs/cifs/smb2ops.c: add 10 credits total=124
[ 2467.094084] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=7 state=4
[ 2467.094105] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2467.094269] fs/cifs/smb2pdu.c: Close
[ 2467.094342] fs/cifs/transport.c: Sending smb: smb_len=92
[ 2467.136116] fs/cifs/connect.c: RFC1002 header 0x7c
[ 2467.136152] fs/cifs/smb2misc.c: SMB2 len 124
[ 2467.136162] fs/cifs/smb2ops.c: add 10 credits total=133
[ 2467.136219] fs/cifs/transport.c: cifs_sync_mid_result: cmd=6 mid=8 state=4
[ 2467.136227] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2467.136345] fs/cifs/connect.c: is_path_remote: full_path: 
[ 2467.136367] fs/cifs/smb2pdu.c: create/open
[ 2467.136408] fs/cifs/transport.c: Sending smb: smb_len=132
[ 2467.176286] fs/cifs/connect.c: RFC1002 header 0x98
[ 2467.176314] fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
[ 2467.176320] fs/cifs/smb2misc.c: SMB2 len 153
[ 2467.176327] fs/cifs/smb2misc.c: Calculated size 153 length 152 mismatch mid 9
[ 2467.176339] fs/cifs/smb2ops.c: add 10 credits total=142
[ 2467.176393] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=9 state=4
[ 2467.176402] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[ 2467.176417] fs/cifs/smb2pdu.c: Close
[ 2467.212780] fs/cifs/smb2ops.c: add 10 credits total=151
[ 2467.212845] fs/cifs/smb2pdu.c: create/open
[ 2467.256263] fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
[ 2467.256274] fs/cifs/smb2misc.c: Calculated size 153 length 152 mismatch mid 11
[ 2467.256285] fs/cifs/smb2ops.c: add 10 credits total=160
[ 2467.256359] fs/cifs/smb2pdu.c: Close
[ 2467.289638] fs/cifs/smb2ops.c: add 10 credits total=169
[ 2467.289873] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 0) rc = 0
[ 2467.294012] fs/cifs/inode.c: CIFS VFS: in cifs_root_iget as Xid: 4 with uid: 0
[ 2467.294118] fs/cifs/inode.c: Getting info on 
[ 2467.339730] fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
[ 2467.339741] fs/cifs/smb2misc.c: Calculated size 153 length 152 mismatch mid 13
[ 2467.339774] fs/cifs/smb2misc.c: SMB2 data length 102 offset 72
[ 2467.340050] fs/cifs/smb2pdu.c: Query Info
[ 2467.376660] ------------[ cut here ]------------
[ 2467.376697] refcount_t: underflow; use-after-free.

... and then the call trace I already sent.

Thanks,
	Dominik
