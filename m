Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABBEC433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 07:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E256221E2
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 07:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbhAMHWt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jan 2021 02:22:49 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60607 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725775AbhAMHWt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 Jan 2021 02:22:49 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3D8005C014B
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jan 2021 02:21:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 13 Jan 2021 02:21:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=duncf.ca; h=
        mime-version:from:date:message-id:subject:to:content-type; s=
        fm2; bh=PnpaWXMwXKJwA4yOfBIxZ5X4jQasgjAt79+kLJBTNXI=; b=mXTiC4xG
        WT2oXm+wWwxDzt7R3OYDb3oWikHMbORDmUdxgigCkZndCQESW1nn7UcvfcxZD97U
        qGrgxmgSx/sy2XAotD/SDolxcq+2NFZfR62TuA5BhIHjtcq5reiaNmCkUBPNKjXG
        /SMpqsqUoelNheT6EbHiWMZHSf6q/SL0tnHFOHQsNCTQfuSuo9BpYFoQ7uC06p3b
        HvpjRx59HQ9y6jcBqi24XbFjtvfANuzYOC4u5W2AUnYccgzgxWnBoaJ3TY3fZ6MM
        dROuL4G/ARi4HxVtWNtalDMypvaB4TpNCKbqQa0xUKwnxPZN9gCmpyqryolXQswS
        f+rtnJnHkWlZvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=PnpaWXMwXKJwA4yOfBIxZ5X4jQasg
        jAt79+kLJBTNXI=; b=mcvwaKgLIlXJ4rDvjDhSMA3D8Vn7j/SMyTWaKND6QhWcV
        Gnn4XMhqGER+ZsVGRWWXHsMoRGvXH8EDdh3UeQlHWKKI2KP1bwAizqDiz0CJhf+w
        tCYYSEwHUMJ6b2krlNAqJkxlfDQ/Tmt+U9rcbv8EoSLFq/vPelP4Uyv5Fi59Pk9+
        1GBe9DscTyRBVvDGdtUu7d9A0DaEqRI3s6nIQXv+HCLYXkjEUjvjO0QZEIR4slAj
        Q2KcBNYTsFzPL/533Zz2byAiIqeoUbM5cjSkRq15SqgXMHfQVqeiMv93NayoISMf
        Nl9K0KmKAixlt+50P5qoC5qq3lXHhA3ZKNFb7K9BA==
X-ME-Sender: <xms:hp_-X1buU9OG1gvPv4_MgSZHr-rt-zlGbd-iAe0qSiePDW3Aqibgsg>
    <xme:hp_-X8baG_aqFW4vSGTUA13K_xCSUbeOB1DJNm8wI-CY_fG5ztPBtuFWXoU-XBAW_
    78M6L--OM3lq-Y->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedukedrtddugddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpegghfffkffuvfgtsehttdertddttd
    ejnecuhfhrohhmpeffuhhntggrnhcuhfhinhgulhgrhicuoeguuhhntghfseguuhhntghf
    rdgtrgeqnecuggftrfgrthhtvghrnhephfdvveffvdduheevkedtleevueejtdehffehud
    ejieekvdfgiedtgfdthfdvlefhnecukfhppedvtdelrdekhedrvddvuddrgeeknecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepughunhgtfhesug
    hunhgtfhdrtggr
X-ME-Proxy: <xmx:hp_-X39iUirYHyKELm_TxK6W_y4DabG8hIe-QZ3WP7J4b-L1NWh60g>
    <xmx:hp_-Xzp2iT3fihj_l3TOiqGlR31OmC9wRZyHOhKEd6v3JmgkeLjWtw>
    <xmx:hp_-Xwo3ezlTq3ujXg_NulH1IINatTI6flj0vPjUol_EODgO9rMngg>
    <xmx:hp_-X92Nl8dj23FTvRvffvxFMezGoXo0myS46buUmP5RkwFroJvqCg>
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by mail.messagingengine.com (Postfix) with ESMTPA id 013FF1080057
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jan 2021 02:21:42 -0500 (EST)
Received: by mail-wr1-f48.google.com with SMTP id c5so948982wrp.6
        for <linux-cifs@vger.kernel.org>; Tue, 12 Jan 2021 23:21:41 -0800 (PST)
X-Gm-Message-State: AOAM533hY4GOD73qOAXRxTl6Tx30f9ONTDrMfUEztuCf6x5jZax8jhKf
        7Zo58YEMVQLzOee1gKUhFg/UWfbx4fZ8zhE7IJg=
X-Google-Smtp-Source: ABdhPJxEFkDlgJ1FrWzS4r+WEzFc6+ToIPCsXOWStko2PDqTREZw0egbka+8eNbGHGbdX+TKpyQ/UonoeUUQS8mAAvU=
X-Received: by 2002:a5d:60c1:: with SMTP id x1mr980705wrt.271.1610522501079;
 Tue, 12 Jan 2021 23:21:41 -0800 (PST)
MIME-Version: 1.0
From:   Duncan Findlay <duncf@duncf.ca>
Date:   Tue, 12 Jan 2021 23:21:05 -0800
X-Gmail-Original-Message-ID: <CAE-Mgq2kwwZJicbU9oenD4M5SQhbErhXovGX+LKtcnRbLC4xSg@mail.gmail.com>
Message-ID: <CAE-Mgq2kwwZJicbU9oenD4M5SQhbErhXovGX+LKtcnRbLC4xSg@mail.gmail.com>
Subject: [bug report] Inconsistent state with CIFS mount after interrupted
 process in Linux 5.10
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There seems to be a problem with the CIFS module in Linux 5.10. Files
that are opened and not cleanly closed end up in an inconsistent
state. This can be triggered by writing to a file and interrupting the
writer with Ctrl-C. Once this happens, attempting to delete the file
causes access to the mount to hang. Afterwards, the files are visible
to ls, but cannot be accessed or deleted.

I'm running Debian unstable with a Debian unstable kernel
(5.10.5-1). I attempted to but could not reproduce this with a 4.19 kernel.


Repro steps:

$ sudo mount -t cifs //test/share /mnt/test --verbose -o
rw,user,auto,nosuid,uid=user,gid=user,vers=3.1.1,credentials=/home/user/tmp/creds
$ mkdir /mnt/test/subdir
$ cat > /mnt/test/subdir/foo
[ Hit Ctrl-C to interrupt ]
$ ls /mnt/test/subdir/
foo
$ rm /mnt/test/subdir/foo
[ Hangs for 35 seconds, errors in dmesg log -- see below ]
$ ls /mnt/test/subdir/
foo
$ stat /mnt/test/subdir/foo
stat: cannot statx '/mnt/test/subdir/foo': No such file or directory

At this point, the file still exists on the server side, and
restarting the server causes it to be deleted.

I can provide pcaps if necessary. It looks like with 4.19, when the
cat command is killed, the client sends a Close Request, and on 5.10
no commands are sent.


More details:

Client:
$ uname -a
Linux test 5.10.0-1-amd64 #1 SMP Debian 5.10.5-1 (2021-01-09) x86_64 GNU/Linux
$ sudo mount.cifs -V
mount.cifs version: 6.11

Samba Server:
$ sudo testparm --version
Version 4.13.3-Debian

In the logs below, the server and client are on the same
machine.

Partial /etc/samba/smb.conf:

[share]
comment = Test folder
path = /srv/test
read only = No

(Happy to share the rest, but it's likely uninteresting -- all default
Debian config.)


Logs:

Debug dmesg logs, while interrupting cat:

[  131.703533] CIFS: fs/cifs/file.c: Flush inode 00000000d8f49255 file
000000001e1eb942 rc 0
[  131.703541] CIFS: fs/cifs/file.c: closing last open instance for
inode 00000000d8f49255
[  131.703543] CIFS: fs/cifs/file.c: VFS: in _cifsFileInfo_put as Xid:
11 with uid: 1000
[  131.703545] CIFS: fs/cifs/smb2pdu.c: Close
[  131.703549] CIFS: fs/cifs/transport.c: signal pending before send request
[  131.703551] CIFS: fs/cifs/smb2ops.c: add 1 credits total=571
[  131.703559] cifs_small_buf_release: 2 callbacks suppressed
[  131.703559] CIFS: fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release

Debug dmesg logs from rm:

[  180.885931] CIFS: fs/cifs/inode.c: VFS: in
cifs_revalidate_dentry_attr as Xid: 13 with uid: 1000
[  180.885938] CIFS: fs/cifs/dir.c: name: \subdir
[  180.885944] CIFS: fs/cifs/inode.c: Update attributes: \subdir inode
0x000000008e2380dc count 1 dentry: 0x00000000568fd902 d_time
4294904495 jiffies 4294937505
[  180.885992] CIFS: fs/cifs/transport.c: Sending smb: smb_len=356
[  180.887242] CIFS: fs/cifs/connect.c: RFC1002 header 0x210
[  180.887255] CIFS: fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[  180.887258] smb2_calc_size: 3 callbacks suppressed
[  180.887259] CIFS: fs/cifs/smb2misc.c: SMB2 len 208
[  180.887269] CIFS: fs/cifs/smb2misc.c: SMB2 data length 114 offset 72
[  180.887271] CIFS: fs/cifs/smb2misc.c: SMB2 len 186
[  180.887274] CIFS: fs/cifs/smb2misc.c: Calculated size 186 length
192 mismatch mid 41
[  180.887281] CIFS: fs/cifs/smb2misc.c: SMB2 len 124
[  180.887284] CIFS: fs/cifs/smb2misc.c: Calculated size 124 length
128 mismatch mid 42
[  180.887287] CIFS: fs/cifs/smb2ops.c: add 30 credits total=598
[  180.887300] cifs_sync_mid_result: 2 callbacks suppressed
[  180.887302] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=5
mid=40 state=4
[  180.887306] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=16
mid=41 state=4
[  180.887309] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=6
mid=42 state=4
[  180.887312] CIFS: fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release
[  180.887314] CIFS: fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release
[  180.887316] CIFS: fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release
[  180.887328] CIFS: fs/cifs/inode.c: cifs_revalidate_cache:
revalidating inode 10952654749510940080
[  180.887331] CIFS: fs/cifs/inode.c: cifs_revalidate_cache:
invalidating inode 10952654749510940080 mapping
[  180.887335] CIFS: fs/cifs/inode.c: VFS: leaving
cifs_revalidate_dentry_attr (xid = 13) rc = 0
[  180.887343] CIFS: fs/cifs/inode.c: VFS: in
cifs_revalidate_dentry_attr as Xid: 14 with uid: 1000
[  180.887346] CIFS: fs/cifs/dir.c: name: \foo
[  180.887348] CIFS: fs/cifs/dir.c: name: \subdir\foo
[  180.887353] CIFS: fs/cifs/inode.c: Update attributes: \subdir\foo
inode 0x00000000d8f49255 count 1 dentry: 0x000000006cae3b3c d_time 0
jiffies 4294937506
[  180.887385] CIFS: fs/cifs/transport.c: Sending smb: smb_len=364
[  180.888296] CIFS: fs/cifs/connect.c: RFC1002 header 0x218
[  180.888307] CIFS: fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[  180.888309] CIFS: fs/cifs/smb2misc.c: SMB2 len 208
[  180.888337] CIFS: fs/cifs/smb2misc.c: SMB2 data length 122 offset 72
[  180.888339] CIFS: fs/cifs/smb2misc.c: SMB2 len 194
[  180.888343] CIFS: fs/cifs/smb2misc.c: Calculated size 194 length
200 mismatch mid 44
[  180.888392] CIFS: fs/cifs/smb2misc.c: SMB2 len 124
[  180.888394] CIFS: fs/cifs/smb2misc.c: Calculated size 124 length
128 mismatch mid 45
[  180.888398] CIFS: fs/cifs/smb2ops.c: add 30 credits total=625
[  180.888427] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=5
mid=43 state=4
[  180.888430] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=16
mid=44 state=4
[  180.888433] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=6
mid=45 state=4
[  180.888435] CIFS: fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release
[  180.888438] CIFS: fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release
[  180.888440] CIFS: fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release
[  180.888450] CIFS: fs/cifs/inode.c: cifs_revalidate_cache:
revalidating inode 10952654827393506808
[  180.888452] CIFS: fs/cifs/inode.c: cifs_revalidate_cache: inode
10952654827393506808 is unchanged
[  180.888457] CIFS: fs/cifs/inode.c: VFS: leaving
cifs_revalidate_dentry_attr (xid = 14) rc = 0
[  180.888534] CIFS: fs/cifs/inode.c: cifs_unlink,
dir=0x000000008e2380dc, dentry=0x000000006cae3b3c
[  180.888537] CIFS: fs/cifs/inode.c: VFS: in cifs_unlink as Xid: 15
with uid: 1000
[  180.888540] CIFS: fs/cifs/dir.c: name: \foo
[  180.888542] CIFS: fs/cifs/dir.c: name: \subdir\foo
[  180.888566] CIFS: fs/cifs/transport.c: Sending smb: smb_len=260
[  180.889623] CIFS: fs/cifs/connect.c: RFC1002 header 0x6c
[  180.889637] CIFS: fs/cifs/smb2misc.c: SMB2 len 108
[  180.889640] CIFS: fs/cifs/smb2misc.c: Checking for oplock break
[  180.889642] CIFS: fs/cifs/smb2misc.c: Checking for lease break
[  180.889645] CIFS: fs/cifs/smb2misc.c: Can not process lease break -
no lease matched
[  180.889647] CIFS: VFS: \\test No task to wake, unknown frame
received! NumMids 2
[  180.889748] CIFS: Received Data is: : dump of 64 bytes of data at
0x0000000009ce2743
[  180.889754] 00000000: 424d53fe 00000040 00000000 00000012  .SMB@...........
[  180.889757] 00000010: 00000001 00000000 ffffffff ffffffff  ................
[  180.889760] 00000020: 00000000 00000000 00000000 00000000  ................
[  180.889763] 00000030: 00000000 00000000 00000000 00000000  ................
[  180.890911] CIFS: fs/cifs/connect.c: RFC1002 header 0x49
[  180.890920] CIFS: fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
[  180.890923] CIFS: fs/cifs/smb2misc.c: SMB2 len 73
[  215.893172] CIFS: fs/cifs/connect.c: RFC1002 header 0x150
[  215.893186] CIFS: fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
[  215.893189] CIFS: fs/cifs/smb2misc.c: SMB2 len 208
[  215.893199] CIFS: fs/cifs/smb2misc.c: SMB2 len 124
[  215.893202] CIFS: fs/cifs/smb2misc.c: Calculated size 124 length
128 mismatch mid 47
[  215.893206] CIFS: fs/cifs/smb2ops.c: add 10 credits total=643
[  215.893230] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=5
mid=46 state=4
[  215.893233] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=6
mid=47 state=4
[  215.893236] CIFS: fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release
[  215.893240] CIFS: fs/cifs/misc.c: Null buffer passed to
cifs_small_buf_release
[  215.893249] CIFS: fs/cifs/inode.c: VFS: leaving cifs_unlink (xid = 15) rc = 0
