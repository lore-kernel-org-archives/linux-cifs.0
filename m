Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9060C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Mar 2022 22:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349585AbiCOWsj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Mar 2022 18:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352358AbiCOWsi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Mar 2022 18:48:38 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DD54B874
        for <linux-cifs@vger.kernel.org>; Tue, 15 Mar 2022 15:47:22 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id t25so903927lfg.7
        for <linux-cifs@vger.kernel.org>; Tue, 15 Mar 2022 15:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HBydo26SOhC0ELhKbLFON+Et45ZGY03MmxnNKTTujP0=;
        b=XUlbW68Wa77DzYeRr1SwZjilx9Db6tJnR7ycnzpZxIFyp8EHzFKOVlo+PEdfp0ljdF
         YPAP/8xW0Y8GU9nGL/rUEzOa+sKhjXQkg31QM5XruJSv+JWXvBEFFQr3o8OaaJ5HOHxu
         6D23kKtKbH+bKgWg3Ax9eednDV5K62dJYQKcui7uXoL9BbBGxboD3nQRv4XPEf3k4s33
         U4PmdJd594EJvffwgmFxWoz1GG07hPxEIKnMVxelg19cura20kFSrbglLzUTHV49r/Ry
         dZ6nYY+c1V6HMaMGMmBRXJ8/bUc5Fyu3BAouO3vBQZCYrcqoEzdeVZxJpIcUYS//b5as
         PMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HBydo26SOhC0ELhKbLFON+Et45ZGY03MmxnNKTTujP0=;
        b=PxXt5oQv39FQ67v0uoNhreWw8+gJiEu7J5FCKY1pKLzDNWVHondZHN2cKZrWanLbyS
         HDH0h2Oow1WXlYxnfo2/jSq8RYsKFLuIiTSh7pOxPUPA//+t9M/K7N7JgbbeUobAxIPZ
         E+hhVn/Kjz1akL+hgfmQRIizvZqQuU0qDSSHT67Kn0+c4lDhfldPETJpwOtktfPzyBjB
         c2J0DHumIodU7HMcepJGoSWuTF0HenXLZ3bfx/JyXiB3B6tr7vlTu86qDcnA2Ynhyrdi
         2vS1Zl0MfTgmC/O2yREffJUTrTeWYo36FSSB5KiVSfQEAhnOHPNNcC//hmGR26SEA0ar
         2f1g==
X-Gm-Message-State: AOAM532akw86UTVNZQ09X/pGQTJVwgz1VHwdbgYbeEah7YNjnt3YsbVC
        Raxi7Egz04/wbNqN4ZDNEmQVOFRk0KbpJ8HwVYs=
X-Google-Smtp-Source: ABdhPJzujBU8SQJZ0ayNg+/OgfRUD/G+hgK/xbY4/bHIuBt+58Qtx0LnOs94yofJi2wXlkcluqoA7fm+QDJBPsHxYC8=
X-Received: by 2002:ac2:4145:0:b0:448:273a:7697 with SMTP id
 c5-20020ac24145000000b00448273a7697mr17853966lfi.601.1647384440168; Tue, 15
 Mar 2022 15:47:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
 <eae5c0cc-55d1-f8db-aba0-57cee7f10332@leemhuis.info> <CAH2r5msUiBuZ74_nPVyzn=k=g0ELpcMnoTm_z30zrMSxF4sn1A@mail.gmail.com>
 <CAFrh3J-oOR1FxPrpzKsQQvronyk9fhDSqD2CY5DNsYO5Lt0ydg@mail.gmail.com>
 <CAFrh3J-TOW4JG6QND0nz_9asiv2g0DzPmxR68BBB_an9yAQ+Vw@mail.gmail.com>
 <CAFrh3J83sUd3tQYHzssKoBb4uQXd3MXf9e=4jLsJ9aH7z2B3oA@mail.gmail.com>
 <CANT5p=qvrV5mrE8dN=RAmCBefGd4_3BzTfM7U98eqmZN2ZVjEg@mail.gmail.com>
 <CAFrh3J8xaEoLo56SmgTKd7gU_KZiyK2AqmrT_7VSM-Hxsyxwrw@mail.gmail.com>
 <CANT5p=p50RU4HY=Dbx0+HzorZ_W0gTmE6iCZbQf0RdF3ZcfRLw@mail.gmail.com>
 <CAFrh3J-xXK1ScRT2BddWzYw9VbeUsGT9cL30bC_KwhQn4G3dtQ@mail.gmail.com>
 <CAFrh3J8+Yb9gHoCaxMPCTyzzS68v9Fz9VGggkjm2hOB07Hj0Yw@mail.gmail.com>
 <CAFrh3J_GSfsXkT5A773E0Raem+h4FsN-KOdXK+qC7LUr6dUmpQ@mail.gmail.com> <472a1fec-ef7b-a8e2-6c14-cc5fa97bd8b3@leemhuis.info>
In-Reply-To: <472a1fec-ef7b-a8e2-6c14-cc5fa97bd8b3@leemhuis.info>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 15 Mar 2022 17:47:08 -0500
Message-ID: <CAH2r5mvn7=Vt3tv6whjNDqnmpQDnmVFPppZux9ZfvyVA0rNJvg@mail.gmail.com>
Subject: Re: Failure to access cifs mount of samba share after resume from
 sleep with 5.17-rc5
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Satadru Pramanik <satadru@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We have bisected a regression (may be related) that was reproducible
(we had difficulty reproducing Satadru's scenario) and affects a
similar area so are focused on that.  We bisected that regression down
to this commit added early in 5.17-rc. Adding Ronnie on cc because he
had noticed the easier to repro scenario. Still debugging.

commit 73f9bfbe3d818bb52266d5c9f3ba57d97842ffe7 (HEAD -> tmp)
Author: Shyam Prasad N <sprasad@microsoft.com>
Date:   Mon Jul 19 17:37:52 2021 +0000

    cifs: maintain a state machine for tcp/smb/tcon sessions

    If functions like cifs_negotiate_protocol, cifs_setup_session,
    cifs_tree_connect are called in parallel on different channels,
    each of these will be execute the requests. This maybe unnecessary
    in some cases, and only the first caller may need to do the work.

    This is achieved by having more states for the tcp/smb/tcon session
    status fields. And tracking the state of reconnection based on the
    state machine.

    For example:
    for tcp connections:
    CifsNew/CifsNeedReconnect ->
      CifsNeedNegotiate ->
        CifsInNegotiate ->
          CifsNeedSessSetup ->
            CifsInSessSetup ->
              CifsGood

    for smb sessions:
    CifsNew/CifsNeedReconnect ->
      CifsGood

On Tue, Mar 15, 2022 at 8:26 AM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> Hi, this is your Linux kernel regression tracker. Top-posting for once,
> to make this easily accessible to everyone.
>
> Steve, Shyam, what's up here? Satadru prodided lot's of data already
> last week and wrote below message 24h ago, but I haven't seen anything
> about this from your side for more than ten days now. Or is the issue
> (or even a fix?) discussed somewhere else and I just missed it?
>
> Just asking, because thx to rc8 there is still a chance to get this
> fixed before the final release happens.
>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>
> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> reports on my table. I can only look briefly into most of them and lack
> knowledge about most of the areas they concern. I thus unfortunately
> will sometimes get things wrong or miss something important. I hope
> that's not the case here; if you think it is, don't hesitate to tell me
> in a public reply, it's in everyone's interest to set the public record
> straight.
>
> On 14.03.22 14:00, Satadru Pramanik wrote:
> > This still appears to be an issue in 5.17-rc8.
> >
> > I would also not this issue appears when the samba server reboots. The
> > client has an unresponsive cifs mount instead of attempting to retry
> > the connection.
> >
> > dmesg after resume from suspend on 5.17-rc8:
> >
> > [ 4072.503603] PM: suspend exit
> > [ 4076.381594] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
> > [ 4090.501947] CIFS: fs/cifs/inode.c: VFS: in
> > cifs_revalidate_dentry_attr as Xid: 633 with uid: 0
> > [ 4090.501966] CIFS: fs/cifs/inode.c: Update attributes: \bin inode
> > 0x00000000b30e5246 count 1 dentry: 0x0000000080235318 d_time
> > 4295826505 jiffies 4295914933
> > [ 4090.502012] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 3 credits total=3005
> > [ 4090.502053] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4090.502081] CIFS: fs/cifs/transport.c: Sending smb: smb_len=400
> > [ 4096.800754] CIFS: fs/cifs/cifsfs.c: VFS: in cifs_statfs as Xid: 634
> > with uid: 1000
> > [ 4096.800783] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 3 credits total=3002
> > [ 4096.800822] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4096.800845] CIFS: fs/cifs/transport.c: Sending smb: smb_len=400
> > [ 4099.320129] CIFS: fs/cifs/dir.c: VFS: in cifs_lookup as Xid: 635
> > with uid: 1000
> > [ 4099.320137] CIFS: fs/cifs/dir.c: parent inode = 0x00000000cc8fcd81
> > name is: bashprompt.sh and dentry = 0x000000007afa4336
> > [ 4099.320143] CIFS: fs/cifs/dir.c: NULL inode in lookup
> > [ 4099.320145] CIFS: fs/cifs/dir.c: Full path: \bashprompt.sh inode =
> > 0x0000000000000000
> > [ 4099.320164] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 3 credits total=2999
> > [ 4099.320185] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4099.320193] CIFS: fs/cifs/transport.c: Sending smb: smb_len=424
> > [ 4105.135867] CIFS: fs/cifs/smb2pdu.c: In echo request for conn_id 4
> > [ 4105.135891] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 1 credits total=0
> > [ 4105.135921] CIFS: fs/cifs/transport.c: Sending smb: smb_len=72
> > [ 4166.576112] CIFS: fs/cifs/smb2pdu.c: In echo request for conn_id 4
> > [ 4166.576131] CIFS: fs/cifs/smb2pdu.c: Echo request failed: -11
> > [ 4166.576138] CIFS: fs/cifs/connect.c: Unable to send echo request to
> > server: cheekon
> > [ 4204.895155] CIFS: fs/cifs/inode.c: VFS: in
> > cifs_revalidate_dentry_attr as Xid: 636 with uid: 1000
> > [ 4204.895165] CIFS: fs/cifs/inode.c: Update attributes:  inode
> > 0x00000000cc8fcd81 count 2 dentry: 0x000000002b8e3e8b d_time 0 jiffies
> > 4295943531
> > [ 4204.895186] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 3 credits total=2996
> > [ 4204.895210] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4204.895221] CIFS: fs/cifs/transport.c: Sending smb: smb_len=400
> > [ 4205.757794] CIFS: fs/cifs/transport.c: \\cheekon Cancelling wait
> > for mid 321 cmd: 5
> > [ 4205.757811] CIFS: fs/cifs/transport.c: \\cheekon Cancelling wait
> > for mid 322 cmd: 16
> > [ 4205.757816] CIFS: fs/cifs/transport.c: \\cheekon Cancelling wait
> > for mid 323 cmd: 6
> > [ 4205.757832] CIFS: fs/cifs/inode.c: cifs_get_inode_info: unhandled err rc -512
> > [ 4205.757840] CIFS: fs/cifs/inode.c: VFS: leaving
> > cifs_revalidate_dentry_attr (xid = 636) rc = -512
> >
> >
> > Also including a manual unmount and remount:
> >
> > [ 4205.757840] CIFS: fs/cifs/inode.c: VFS: leaving
> > cifs_revalidate_dentry_attr (xid = 636) rc = -512
> > [ 4220.854276] CIFS: VFS: \\cheekon has not responded in 180 seconds.
> > Reconnecting...
> > [ 4220.854284] CIFS: fs/cifs/connect.c: Mark tcp session as need reconnect
> > [ 4220.854287] CIFS: fs/cifs/connect.c:
> > cifs_mark_tcp_ses_conns_for_reconnect: marking necessary sessions and
> > tcons for reconnect
> > [ 4220.854289] CIFS: fs/cifs/sess.c: Set reconnect bitmask for chan 0; now 0x1
> > [ 4220.854292] CIFS: fs/cifs/connect.c: cifs_abort_connection: tearing
> > down socket
> > [ 4220.854293] CIFS: fs/cifs/connect.c: State: 0x3 Flags: 0x0
> > [ 4220.854371] CIFS: fs/cifs/connect.c: Post shutdown state: 0x3 Flags: 0x0
> > [ 4220.854378] CIFS: fs/cifs/connect.c: cifs_abort_connection: moving
> > mids to private list
> > [ 4220.854380] CIFS: fs/cifs/connect.c: cifs_abort_connection: issuing
> > mid callbacks
> > [ 4220.854383] cifs_small_buf_release: 1 callbacks suppressed
> > [ 4220.854384] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4220.854387] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4220.854388] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4220.854397] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4220.854412] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: probably server name is whole unc:
> > \\cheekon
> > [ 4220.854425] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=5
> > mid=317 state=8
> > [ 4220.854431] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4220.854431] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=5
> > mid=314 state=8
> > [ 4220.854433] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4220.854437] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4220.854439] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4220.854442] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4220.854444] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4220.854451] CIFS: fs/cifs/inode.c: cifs_get_inode_info: unhandled err rc -11
> > [ 4220.854450] CIFS: fs/cifs/cifsfs.c: VFS: leaving cifs_statfs (xid =
> > 634) rc = -11
> > [ 4220.854451] CIFS: fs/cifs/inode.c: cifs_get_inode_info: unhandled err rc -11
> > [ 4220.854463] CIFS: fs/cifs/smb2pdu.c: smb2_reconnect: aborting
> > reconnect due to a received signal by the process
> > [ 4220.854463] CIFS: fs/cifs/inode.c: cifs_get_inode_info: unhandled err rc -512
> > [ 4220.854466] CIFS: fs/cifs/inode.c: cifs_get_inode_info: unhandled err rc -512
> > [ 4220.854467] CIFS: fs/cifs/inode.c: VFS: leaving
> > cifs_revalidate_dentry_attr (xid = 633) rc = -512
> > [ 4220.854468] CIFS: fs/cifs/dir.c: Unexpected lookup error -512
> > [ 4220.854470] CIFS: fs/cifs/dir.c: cifs_revalidate_dentry failed with rc=-512
> > [ 4220.854470] CIFS: fs/cifs/dir.c: VFS: leaving cifs_lookup (xid =
> > 635) rc = -512
> > [ 4220.854490] CIFS: fs/cifs/dir.c: VFS: in cifs_lookup as Xid: 637
> > with uid: 1000
> > [ 4220.854493] CIFS: fs/cifs/dir.c: parent inode = 0x00000000cc8fcd81
> > name is: bashprompt.sh and dentry = 0x00000000afae7ba3
> > [ 4220.854498] CIFS: fs/cifs/dir.c: NULL inode in lookup
> > [ 4220.854499] CIFS: fs/cifs/dir.c: Full path: \bashprompt.sh inode =
> > 0x0000000000000000
> > [ 4220.854508] CIFS: fs/cifs/smb2pdu.c: smb2_reconnect: aborting
> > reconnect due to a received signal by the process
> > [ 4220.854511] CIFS: fs/cifs/inode.c: cifs_get_inode_info: unhandled err rc -512
> > [ 4220.854513] CIFS: fs/cifs/dir.c: Unexpected lookup error -512
> > [ 4220.854514] CIFS: fs/cifs/dir.c: VFS: leaving cifs_lookup (xid =
> > 637) rc = -512
> > [ 4220.854523] CIFS: fs/cifs/dir.c: VFS: in cifs_lookup as Xid: 638
> > with uid: 1000
> > [ 4220.854529] CIFS: fs/cifs/dir.c: parent inode = 0x00000000cc8fcd81
> > name is: bashprompt.sh and dentry = 0x00000000fe692902
> > [ 4220.854535] CIFS: fs/cifs/dir.c: NULL inode in lookup
> > [ 4220.854536] CIFS: fs/cifs/dir.c: Full path: \bashprompt.sh inode =
> > 0x0000000000000000
> > [ 4220.854546] CIFS: fs/cifs/smb2pdu.c: smb2_reconnect: aborting
> > reconnect due to a received signal by the process
> > [ 4220.854549] CIFS: fs/cifs/inode.c: cifs_get_inode_info: unhandled err rc -512
> > [ 4220.854552] CIFS: fs/cifs/dir.c: Unexpected lookup error -512
> > [ 4220.854554] CIFS: fs/cifs/dir.c: VFS: leaving cifs_lookup (xid =
> > 638) rc = -512
> > [ 4220.855211] CIFS: fs/cifs/inode.c: VFS: in
> > cifs_revalidate_dentry_attr as Xid: 639 with uid: 0
> > [ 4220.855218] CIFS: fs/cifs/inode.c: Update attributes: \bin inode
> > 0x00000000b30e5246 count 1 dentry: 0x0000000080235318 d_time
> > 4295826505 jiffies 4295947521
> > [ 4220.856348] CIFS: fs/cifs/cifsfs.c: VFS: in cifs_statfs as Xid: 640
> > with uid: 1000
> > [ 4225.844263] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: unable to resolve: cheekon
> > [ 4225.844273] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: failed to resolve server part of
> > cheekon to IP: -4
> > [ 4225.844276] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: next dns resolution scheduled for 600
> > seconds in the future
> > [ 4225.844281] CIFS: fs/cifs/connect.c: __cifs_reconnect:
> > reconn_set_ipaddr_from_hostname: rc=-4
> > [ 4225.844283] CIFS: fs/cifs/connect.c: generic_ip_connect: connecting
> > to 192.168.0.20:445
> > [ 4225.844293] CIFS: fs/cifs/connect.c: Socket created
> > [ 4225.844295] CIFS: fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
> > rcvtimeo 0x6d6
> > [ 4228.912632] CIFS: fs/cifs/connect.c: Error -113 connecting to server
> > [ 4228.912670] CIFS: fs/cifs/connect.c: __cifs_reconnect: reconnect error -113
> > [ 4231.088378] CIFS: fs/cifs/smb2pdu.c: gave up waiting on reconnect in smb_init
> > [ 4231.088383] CIFS: fs/cifs/smb2pdu.c: gave up waiting on reconnect in smb_init
> > [ 4231.088385] cifs_small_buf_release: 7 callbacks suppressed
> > [ 4231.088387] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4231.088388] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4231.088390] CIFS: fs/cifs/cifsfs.c: VFS: leaving cifs_statfs (xid =
> > 640) rc = -112
> > [ 4231.088393] CIFS: fs/cifs/inode.c: cifs_get_inode_info: unhandled err rc -112
> > [ 4231.088398] CIFS: fs/cifs/inode.c: VFS: leaving
> > cifs_revalidate_dentry_attr (xid = 639) rc = -112
> > [ 4231.088401] CIFS: fs/cifs/dir.c: cifs_revalidate_dentry failed with rc=-112
> > [ 4231.088421] CIFS: fs/cifs/inode.c: VFS: in
> > cifs_revalidate_dentry_attr as Xid: 641 with uid: 0
> > [ 4231.088425] CIFS: fs/cifs/inode.c: Update attributes: \x86_64 inode
> > 0x000000004022c915 count 1 dentry: 0x00000000669397cc d_time
> > 4295826508 jiffies 4295950080
> > [ 4232.112342] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: probably server name is whole unc:
> > \\cheekon
> > [ 4238.141384] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: unable to resolve: cheekon
> > [ 4238.141400] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: failed to resolve server part of
> > cheekon to IP: -4
> > [ 4238.141408] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: next dns resolution scheduled for 600
> > seconds in the future
> > [ 4238.141417] CIFS: fs/cifs/connect.c: __cifs_reconnect:
> > reconn_set_ipaddr_from_hostname: rc=-4
> > [ 4238.141422] CIFS: fs/cifs/connect.c: generic_ip_connect: connecting
> > to 192.168.0.20:445
> > [ 4238.141441] CIFS: fs/cifs/connect.c: Socket created
> > [ 4238.141445] CIFS: fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
> > rcvtimeo 0x6d6
> > [ 4241.200798] CIFS: fs/cifs/connect.c: Error -113 connecting to server
> > [ 4241.200826] CIFS: fs/cifs/connect.c: __cifs_reconnect: reconnect error -113
> > [ 4241.328397] CIFS: fs/cifs/smb2pdu.c: gave up waiting on reconnect in smb_init
> > [ 4241.328409] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4241.328417] CIFS: fs/cifs/inode.c: cifs_get_inode_info: unhandled err rc -112
> > [ 4241.328423] CIFS: fs/cifs/inode.c: VFS: leaving
> > cifs_revalidate_dentry_attr (xid = 641) rc = -112
> > [ 4241.328426] CIFS: fs/cifs/dir.c: cifs_revalidate_dentry failed with rc=-112
> > [ 4244.400422] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: probably server name is whole unc:
> > \\cheekon
> > [ 4250.434011] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: unable to resolve: cheekon
> > [ 4250.434033] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: failed to resolve server part of
> > cheekon to IP: -4
> > [ 4250.434043] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: next dns resolution scheduled for 600
> > seconds in the future
> > [ 4250.434056] CIFS: fs/cifs/connect.c: __cifs_reconnect:
> > reconn_set_ipaddr_from_hostname: rc=-4
> > [ 4250.434063] CIFS: fs/cifs/connect.c: generic_ip_connect: connecting
> > to 192.168.0.20:445
> > [ 4250.434086] CIFS: fs/cifs/connect.c: Socket created
> > [ 4250.434091] CIFS: fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
> > rcvtimeo 0x6d6
> > [ 4253.488848] CIFS: fs/cifs/connect.c: Error -113 connecting to server
> > [ 4253.488875] CIFS: fs/cifs/connect.c: __cifs_reconnect: reconnect error -113
> > [ 4256.688419] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: probably server name is whole unc:
> > \\cheekon
> > [ 4265.790981] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: unable to resolve: cheekon
> > [ 4265.790995] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: failed to resolve server part of
> > cheekon to IP: -4
> > [ 4265.791000] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: next dns resolution scheduled for 600
> > seconds in the future
> > [ 4265.791005] CIFS: fs/cifs/connect.c: __cifs_reconnect:
> > reconn_set_ipaddr_from_hostname: rc=-4
> > [ 4265.791008] CIFS: fs/cifs/connect.c: generic_ip_connect: connecting
> > to 192.168.0.20:445
> > [ 4265.791022] CIFS: fs/cifs/connect.c: Socket created
> > [ 4265.791025] CIFS: fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
> > rcvtimeo 0x6d6
> > [ 4268.848709] CIFS: fs/cifs/connect.c: Error -113 connecting to server
> > [ 4268.848752] CIFS: fs/cifs/connect.c: __cifs_reconnect: reconnect error -113
> > [ 4272.052440] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: probably server name is whole unc:
> > \\cheekon
> > [ 4278.078864] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: unable to resolve: cheekon
> > [ 4278.078889] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: failed to resolve server part of
> > cheekon to IP: -4
> > [ 4278.078898] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: next dns resolution scheduled for 600
> > seconds in the future
> > [ 4278.078904] CIFS: fs/cifs/connect.c: __cifs_reconnect:
> > reconn_set_ipaddr_from_hostname: rc=-4
> > [ 4278.078911] CIFS: fs/cifs/connect.c: generic_ip_connect: connecting
> > to 192.168.0.20:445
> > [ 4278.078937] CIFS: fs/cifs/connect.c: Socket created
> > [ 4278.078942] CIFS: fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
> > rcvtimeo 0x6d6
> > [ 4280.826140] CIFS: fs/cifs/cifsfs.c: VFS: in cifs_statfs as Xid: 642
> > with uid: 1000
> > [ 4281.136704] CIFS: fs/cifs/connect.c: Error -113 connecting to server
> > [ 4281.136737] CIFS: fs/cifs/connect.c: __cifs_reconnect: reconnect error -113
> > [ 4284.336534] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: probably server name is whole unc:
> > \\cheekon
> > [ 4290.992510] CIFS: fs/cifs/smb2pdu.c: gave up waiting on reconnect in smb_init
> > [ 4290.992532] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4290.992543] CIFS: fs/cifs/cifsfs.c: VFS: leaving cifs_statfs (xid =
> > 642) rc = -112
> > [ 4292.289757] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: unable to resolve: cheekon
> > [ 4292.289765] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: failed to resolve server part of
> > cheekon to IP: -4
> > [ 4292.289769] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: next dns resolution scheduled for 600
> > seconds in the future
> > [ 4292.289773] CIFS: fs/cifs/connect.c: __cifs_reconnect:
> > reconn_set_ipaddr_from_hostname: rc=-4
> > [ 4292.289776] CIFS: fs/cifs/connect.c: generic_ip_connect: connecting
> > to 192.168.0.20:445
> > [ 4292.289793] CIFS: fs/cifs/connect.c: Socket created
> > [ 4292.289794] CIFS: fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
> > rcvtimeo 0x6d6
> > [ 4295.348741] CIFS: fs/cifs/connect.c: Error -113 connecting to server
> > [ 4295.348773] CIFS: fs/cifs/connect.c: __cifs_reconnect: reconnect error -113
> > [ 4298.416556] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: probably server name is whole unc:
> > \\cheekon
> > [ 4308.425564] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: unable to resolve: cheekon
> > [ 4308.425582] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: failed to resolve server part of
> > cheekon to IP: -4
> > [ 4308.425589] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: next dns resolution scheduled for 600
> > seconds in the future
> > [ 4308.425595] CIFS: fs/cifs/connect.c: __cifs_reconnect:
> > reconn_set_ipaddr_from_hostname: rc=-4
> > [ 4308.425599] CIFS: fs/cifs/connect.c: generic_ip_connect: connecting
> > to 192.168.0.20:445
> > [ 4308.425621] CIFS: fs/cifs/connect.c: Socket created
> > [ 4308.425625] CIFS: fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
> > rcvtimeo 0x6d6
> > [ 4311.505060] CIFS: fs/cifs/connect.c: Error -113 connecting to server
> > [ 4311.505094] CIFS: fs/cifs/connect.c: __cifs_reconnect: reconnect error -113
> > [ 4314.544551] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: probably server name is whole unc:
> > \\cheekon
> > [ 4323.328365] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: unable to resolve: cheekon
> > [ 4323.328387] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: failed to resolve server part of
> > cheekon to IP: -4
> > [ 4323.328397] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: next dns resolution scheduled for 600
> > seconds in the future
> > [ 4323.328406] CIFS: fs/cifs/connect.c: __cifs_reconnect:
> > reconn_set_ipaddr_from_hostname: rc=-4
> > [ 4323.328413] CIFS: fs/cifs/connect.c: generic_ip_connect: connecting
> > to 192.168.0.20:445
> > [ 4323.328437] CIFS: fs/cifs/connect.c: Socket created
> > [ 4323.328441] CIFS: fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
> > rcvtimeo 0x6d6
> > [ 4326.384727] CIFS: fs/cifs/connect.c: Error -113 connecting to server
> > [ 4326.384755] CIFS: fs/cifs/connect.c: __cifs_reconnect: reconnect error -113
> > [ 4329.392599] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: probably server name is whole unc:
> > \\cheekon
> > [ 4339.406543] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: unable to resolve: cheekon
> > [ 4339.406550] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: failed to resolve server part of
> > cheekon to IP: -4
> > [ 4339.406553] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: next dns resolution scheduled for 600
> > seconds in the future
> > [ 4339.406556] CIFS: fs/cifs/connect.c: __cifs_reconnect:
> > reconn_set_ipaddr_from_hostname: rc=-4
> > [ 4339.406559] CIFS: fs/cifs/connect.c: generic_ip_connect: connecting
> > to 192.168.0.20:445
> > [ 4339.406567] CIFS: fs/cifs/connect.c: Socket created
> > [ 4339.406568] CIFS: fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
> > rcvtimeo 0x6d6
> > [ 4340.826465] CIFS: fs/cifs/cifsfs.c: VFS: in cifs_statfs as Xid: 643
> > with uid: 1000
> > [ 4342.481043] CIFS: fs/cifs/connect.c: Error -113 connecting to server
> > [ 4342.481071] CIFS: fs/cifs/connect.c: __cifs_reconnect: reconnect error -113
> > [ 4343.513393] CIFS: fs/cifs/inode.c: VFS: in
> > cifs_revalidate_dentry_attr as Xid: 644 with uid: 0
> > [ 4343.513400] CIFS: fs/cifs/inode.c: Update attributes:  inode
> > 0x00000000cc8fcd81 count 2 dentry: 0x000000002b8e3e8b d_time 0 jiffies
> > 4295978186
> > [ 4345.520578] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: probably server name is whole unc:
> > \\cheekon
> > [ 4350.900608] CIFS: fs/cifs/smb2pdu.c: gave up waiting on reconnect in smb_init
> > [ 4350.900628] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4350.900632] CIFS: fs/cifs/cifsfs.c: VFS: leaving cifs_statfs (xid =
> > 643) rc = -112
> > [ 4353.712700] CIFS: fs/cifs/smb2pdu.c: gave up waiting on reconnect in smb_init
> > [ 4353.712720] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4353.712728] CIFS: fs/cifs/inode.c: cifs_get_inode_info: unhandled err rc -112
> > [ 4353.712734] CIFS: fs/cifs/inode.c: VFS: leaving
> > cifs_revalidate_dentry_attr (xid = 644) rc = -112
> > [ 4353.714004] CIFS: fs/cifs/connect.c: cifs_put_tcon: tc_count=1
> > [ 4353.714015] CIFS: fs/cifs/connect.c: VFS: in cifs_put_tcon as Xid:
> > 645 with uid: 0
> > [ 4353.714020] CIFS: fs/cifs/smb2pdu.c: Tree Disconnect
> > [ 4353.714024] CIFS: fs/cifs/fscache.c:
> > cifs_fscache_release_super_cookie: (0x0000000000000000)
> > [ 4353.714032] CIFS: fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
> > [ 4353.714037] CIFS: fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
> > [ 4353.714039] CIFS: fs/cifs/connect.c: cifs_put_smb_ses: ses ipc:
> > \\cheekon\IPC$
> > [ 4355.529971] CIFS: fs/cifs/dns_resolve.c:
> > dns_resolve_server_name_to_ip: unable to resolve: cheekon
> > [ 4355.529988] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: failed to resolve server part of
> > \x1b\x86\xb9\xeaj1\x15\xb2;\x87\xb9\xeaj1\x15\x8a@\x04 to IP: -4
> > [ 4355.529996] CIFS: fs/cifs/connect.c:
> > reconn_set_ipaddr_from_hostname: next dns resolution scheduled for 600
> > seconds in the future
> > [ 4355.530002] CIFS: fs/cifs/connect.c: __cifs_reconnect:
> > reconn_set_ipaddr_from_hostname: rc=-4
> > [ 4355.530006] CIFS: fs/cifs/connect.c: generic_ip_connect: connecting
> > to 192.168.0.20:445
> > [ 4355.530025] CIFS: fs/cifs/connect.c: Socket created
> > [ 4355.530027] CIFS: fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
> > rcvtimeo 0x6d6
> > [ 4355.530185] CIFS: fs/cifs/connect.c: Error -4 connecting to server
> > [ 4355.530201] CIFS: fs/cifs/connect.c: __cifs_reconnect: reconnect error -4
> > [ 4372.001470] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
> > [ 4377.427015] smb3_fs_context_parse_param: 1 callbacks suppressed
> > [ 4377.427018] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount
> > option 'source'
> > [ 4377.427025] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'ip'
> > [ 4377.427028] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'unc'
> > [ 4377.427030] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount
> > option 'forceuid'
> > [ 4377.427032] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount
> > option 'resilienthandles'
> > [ 4377.427033] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount
> > option 'vers'
> > [ 4377.427036] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount
> > option 'iocharset'
> > [ 4377.427038] CIFS: fs/cifs/fs_context.c: iocharset set to utf8
> > [ 4377.427039] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount
> > option 'cifsacl'
> > [ 4377.427040] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount option 'uid'
> > [ 4377.427043] CIFS: fs/cifs/fs_context.c: CIFS: parsing cifs mount
> > option 'user'
> > [ 4377.427047] CIFS: fs/cifs/cifsfs.c: Devname: \\cheekon\localnet flags: 0
> > [ 4377.427050] CIFS: fs/cifs/connect.c: Username: localnet
> > [ 4377.427052] CIFS: fs/cifs/connect.c: file mode: 0755  dir mode: 0755
> > [ 4377.427055] CIFS: fs/cifs/connect.c: VFS: in mount_get_conns as
> > Xid: 646 with uid: 0
> > [ 4377.427057] CIFS: fs/cifs/connect.c: UNC: \\cheekon\localnet
> > [ 4377.427060] CIFS: fs/cifs/connect.c: generic_ip_connect: connecting
> > to 192.168.0.20:445
> > [ 4377.427067] CIFS: fs/cifs/connect.c: Socket created
> > [ 4377.427069] CIFS: fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072
> > rcvtimeo 0x6d6
> > [ 4377.428082] CIFS: fs/cifs/connect.c: cifs_get_tcp_session: next dns
> > resolution scheduled for 600 seconds in the future
> > [ 4377.428086] CIFS: fs/cifs/connect.c: VFS: in cifs_get_smb_ses as
> > Xid: 647 with uid: 0
> > [ 4377.428089] CIFS: fs/cifs/connect.c: Existing smb sess not found
> > [ 4377.428093] CIFS: fs/cifs/smb2pdu.c: Negotiate protocol
> > [ 4377.428093] CIFS: fs/cifs/connect.c: Demultiplex PID: 77240
> > [ 4377.428098] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 1 credits total=0
> > [ 4377.428113] CIFS: fs/cifs/transport.c: Sending smb: smb_len=220
> > [ 4377.432265] CIFS: fs/cifs/connect.c: RFC1002 header 0x10c
> > [ 4377.432272] CIFS: fs/cifs/smb2misc.c: SMB2 data length 74 offset 128
> > [ 4377.432274] CIFS: fs/cifs/smb2misc.c: SMB2 len 202
> > [ 4377.432276] CIFS: fs/cifs/smb2misc.c: length of negcontexts 60 pad 6
> > [ 4377.432279] CIFS: fs/cifs/smb2ops.c: smb2_add_credits: added 1
> > credits total=1
> > [ 4377.432305] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=0
> > mid=0 state=4
> > [ 4377.432314] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4377.432317] CIFS: fs/cifs/smb2pdu.c: mode 0x1
> > [ 4377.432319] CIFS: fs/cifs/smb2pdu.c: negotiated smb3.1.1 dialect
> > [ 4377.432322] CIFS: fs/cifs/smb2pdu.c: decoding 2 negotiate contexts
> > [ 4377.432324] CIFS: fs/cifs/smb2pdu.c: decode SMB3.11 encryption neg
> > context of len 4
> > [ 4377.432326] CIFS: fs/cifs/smb2pdu.c: SMB311 cipher type:2
> > [ 4377.432328] CIFS: fs/cifs/connect.c: Security Mode: 0x1
> > Capabilities: 0x300046 TimeAdjust: 0
> > [ 4377.432332] CIFS: fs/cifs/smb2pdu.c: Session Setup
> > [ 4377.432333] CIFS: fs/cifs/smb2pdu.c: sess setup type 2
> > [ 4377.432336] CIFS: fs/cifs/smb2pdu.c: Fresh session. Previous: 0
> > [ 4377.432338] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 1 credits total=0
> > [ 4377.432346] CIFS: fs/cifs/transport.c: Sending smb: smb_len=136
> > [ 4377.433477] CIFS: fs/cifs/connect.c: RFC1002 header 0xda
> > [ 4377.433483] CIFS: fs/cifs/smb2misc.c: SMB2 data length 146 offset 72
> > [ 4377.433485] CIFS: fs/cifs/smb2misc.c: SMB2 len 218
> > [ 4377.433488] CIFS: fs/cifs/smb2ops.c: smb2_add_credits: added 1
> > credits total=1
> > [ 4377.433512] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=1
> > mid=1 state=4
> > [ 4377.433518] CIFS: Status code returned 0xc0000016
> > STATUS_MORE_PROCESSING_REQUIRED
> > [ 4377.433526] CIFS: fs/cifs/smb2maperror.c: Mapping SMB2 status code
> > 0xc0000016 to POSIX err -5
> > [ 4377.433531] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4377.433534] CIFS: fs/cifs/sess.c: decode_ntlmssp_challenge:
> > negotiate=0xe2088235 challenge=0xe28a8235
> > [ 4377.433536] CIFS: fs/cifs/smb2pdu.c: rawntlmssp session setup challenge phase
> > [ 4377.433539] CIFS: fs/cifs/smb2pdu.c: Fresh session. Previous: 0
> > [ 4377.433558] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 1 credits total=0
> > [ 4377.433565] CIFS: fs/cifs/transport.c: Sending smb: smb_len=320
> > [ 4377.446423] CIFS: fs/cifs/connect.c: RFC1002 header 0x48
> > [ 4377.446436] CIFS: fs/cifs/smb2misc.c: SMB2 data length 0 offset 72
> > [ 4377.446440] CIFS: fs/cifs/smb2misc.c: SMB2 len 73
> > [ 4377.446442] CIFS: fs/cifs/smb2misc.c: Calculated size 73 length 72
> > mismatch mid 2
> > [ 4377.446446] CIFS: fs/cifs/smb2ops.c: smb2_add_credits: added 130
> > credits total=130
> > [ 4377.446478] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=1
> > mid=2 state=4
> > [ 4377.446484] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4377.446499] CIFS: fs/cifs/smb2pdu.c: SMB2/3 session established successfully
> > [ 4377.446502] CIFS: fs/cifs/sess.c: Cleared reconnect bitmask for
> > chan 0; now 0x0
> > [ 4377.446505] CIFS: fs/cifs/connect.c: VFS: leaving cifs_get_smb_ses
> > (xid = 647) rc = 0
> > [ 4377.446508] CIFS: fs/cifs/connect.c: VFS: in cifs_setup_ipc as Xid:
> > 648 with uid: 0
> > [ 4377.446510] CIFS: fs/cifs/smb2pdu.c: TCON
> > [ 4377.446513] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 1 credits total=129
> > [ 4377.446539] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4377.446548] CIFS: fs/cifs/transport.c: Sending smb: smb_len=158
> > [ 4377.455288] CIFS: fs/cifs/connect.c: RFC1002 header 0x84
> > [ 4377.455308] CIFS: fs/cifs/smb2ops.c: Decrypt message returned 0
> > [ 4377.455310] CIFS: fs/cifs/smb2ops.c: mid found
> > [ 4377.455312] CIFS: fs/cifs/smb2misc.c: SMB2 len 80
> > [ 4377.455315] CIFS: fs/cifs/smb2ops.c: smb2_add_credits: added 64
> > credits total=191
> > [ 4377.455344] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=3
> > mid=3 state=4
> > [ 4377.455349] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4377.455352] CIFS: fs/cifs/smb2pdu.c: connection to pipe share
> > [ 4377.455355] CIFS: fs/cifs/connect.c: VFS: leaving cifs_setup_ipc
> > (xid = 648) rc = 0
> > [ 4377.455357] CIFS: fs/cifs/connect.c: IPC tcon rc = 0 ipc tid = -1798775872
> > [ 4377.455362] CIFS: fs/cifs/connect.c: VFS: in cifs_get_tcon as Xid:
> > 649 with uid: 0
> > [ 4377.455364] CIFS: fs/cifs/smb2pdu.c: TCON
> > [ 4377.455367] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 1 credits total=190
> > [ 4377.455376] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4377.455384] CIFS: fs/cifs/transport.c: Sending smb: smb_len=166
> > [ 4377.457328] CIFS: fs/cifs/connect.c: RFC1002 header 0x84
> > [ 4377.457341] CIFS: fs/cifs/smb2ops.c: Decrypt message returned 0
> > [ 4377.457343] CIFS: fs/cifs/smb2ops.c: mid found
> > [ 4377.457345] CIFS: fs/cifs/smb2misc.c: SMB2 len 80
> > [ 4377.457347] CIFS: fs/cifs/smb2ops.c: smb2_add_credits: added 64
> > credits total=254
> > [ 4377.457373] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=3
> > mid=4 state=4
> > [ 4377.457378] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4377.457380] CIFS: fs/cifs/smb2pdu.c: connection to disk share
> > [ 4377.457383] CIFS: fs/cifs/connect.c: VFS: leaving cifs_get_tcon
> > (xid = 649) rc = 0
> > [ 4377.457385] CIFS: fs/cifs/connect.c: Tcon rc = 0
> > [ 4377.457388] CIFS: fs/cifs/smb2pdu.c: create/open
> > [ 4377.457391] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 1 credits total=253
> > [ 4377.457400] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4377.457407] CIFS: fs/cifs/transport.c: Sending smb: smb_len=208
> > [ 4377.458319] CIFS: fs/cifs/connect.c: RFC1002 header 0x104
> > [ 4377.458331] CIFS: fs/cifs/smb2ops.c: Decrypt message returned 0
> > [ 4377.458333] CIFS: fs/cifs/smb2ops.c: mid found
> > [ 4377.458334] CIFS: fs/cifs/smb2misc.c: SMB2 data length 56 offset 152
> > [ 4377.458336] CIFS: fs/cifs/smb2misc.c: SMB2 len 208
> > [ 4377.458338] CIFS: fs/cifs/smb2ops.c: smb2_add_credits: added 10
> > credits total=263
> > [ 4377.458362] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=5
> > mid=5 state=4
> > [ 4377.458367] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4377.458371] CIFS: fs/cifs/smb2pdu.c: SMB2 IOCTL
> > [ 4377.458373] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 1 credits total=262
> > [ 4377.458382] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4377.458387] CIFS: fs/cifs/transport.c: Sending smb: smb_len=177
> > [ 4377.459230] CIFS: fs/cifs/connect.c: RFC1002 header 0x4cc
> > [ 4377.459244] CIFS: fs/cifs/smb2ops.c: Decrypt message returned 0
> > [ 4377.459245] CIFS: fs/cifs/smb2ops.c: mid found
> > [ 4377.459247] CIFS: fs/cifs/smb2misc.c: SMB2 data length 1064 offset 112
> > [ 4377.459248] CIFS: fs/cifs/smb2misc.c: SMB2 len 1176
> > [ 4377.459250] CIFS: fs/cifs/smb2ops.c: smb2_add_credits: added 10
> > credits total=272
> > [ 4377.459274] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=11
> > mid=6 state=4
> > [ 4377.459282] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 0
> > [ 4377.459284] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: speed
> > 10000000000 bps
> > [ 4377.459285] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces:
> > capabilities 0x00000001
> > [ 4377.459287] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: ipv4
> > 192.168.0.20
> > [ 4377.459289] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 1
> > [ 4377.459290] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: speed
> > 10000000000 bps
> > [ 4377.459291] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces:
> > capabilities 0x00000001
> > [ 4377.459293] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: ipv6
> > fd40:1eef:5174:0000:f872:6d14:bade:233b
> > [ 4377.459294] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 2
> > [ 4377.459296] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: speed
> > 10000000000 bps
> > [ 4377.459297] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces:
> > capabilities 0x00000001
> > [ 4377.459298] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: ipv6
> > fd40:1eef:5174:0000:7f90:c7fb:ffa7:a8dd
> > [ 4377.459299] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 3
> > [ 4377.459300] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: speed
> > 10000000000 bps
> > [ 4377.459302] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces:
> > capabilities 0x00000001
> > [ 4377.459303] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: ipv6
> > 2001:0470:e1f3:0000:187d:e160:8517:e8df
> > [ 4377.459304] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 4
> > [ 4377.459305] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: speed
> > 10000000000 bps
> > [ 4377.459307] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces:
> > capabilities 0x00000001
> > [ 4377.459308] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: ipv6
> > 2001:0470:e1f3:0000:11c8:9923:c250:1d0e
> > [ 4377.459309] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 5
> > [ 4377.459310] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: speed
> > 1000000000 bps
> > [ 4377.459311] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces:
> > capabilities 0x00000000
> > [ 4377.459312] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: ipv4 127.0.0.1
> > [ 4377.459314] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: adding iface 6
> > [ 4377.459315] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: speed
> > 1000000000 bps
> > [ 4377.459317] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces:
> > capabilities 0x00000000
> > [ 4377.459318] CIFS: fs/cifs/smb2ops.c: parse_server_interfaces: ipv6
> > 0000:0000:0000:0000:0000:0000:0000:0001
> > [ 4377.459321] CIFS: fs/cifs/smb2pdu.c: Query FSInfo level 5
> > [ 4377.459324] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 1 credits total=271
> > [ 4377.459332] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4377.459337] CIFS: fs/cifs/transport.c: Sending smb: smb_len=161
> > [ 4377.460257] CIFS: fs/cifs/connect.c: RFC1002 header 0x90
> > [ 4377.460267] CIFS: fs/cifs/smb2ops.c: Decrypt message returned 0
> > [ 4377.460269] CIFS: fs/cifs/smb2ops.c: mid found
> > [ 4377.460271] CIFS: fs/cifs/smb2misc.c: SMB2 data length 20 offset 72
> > [ 4377.460272] CIFS: fs/cifs/smb2misc.c: SMB2 len 92
> > [ 4377.460274] CIFS: fs/cifs/smb2ops.c: smb2_add_credits: added 10
> > credits total=281
> > [ 4377.460299] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=16
> > mid=7 state=4
> > [ 4377.460304] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4377.460306] CIFS: fs/cifs/smb2pdu.c: Query FSInfo level 4
> > [ 4377.460309] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 1 credits total=280
> > [ 4377.460317] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4377.460322] CIFS: fs/cifs/transport.c: Sending smb: smb_len=161
> > [ 4377.461344] CIFS: fs/cifs/connect.c: RFC1002 header 0x84
> > [ 4377.461356] CIFS: fs/cifs/smb2ops.c: Decrypt message returned 0
> > [ 4377.461359] CIFS: fs/cifs/smb2ops.c: mid found
> > [ 4377.461361] CIFS: fs/cifs/smb2misc.c: SMB2 data length 8 offset 72
> > [ 4377.461363] CIFS: fs/cifs/smb2misc.c: SMB2 len 80
> > [ 4377.461366] CIFS: fs/cifs/smb2ops.c: smb2_add_credits: added 10
> > credits total=290
> > [ 4377.461393] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=16
> > mid=8 state=4
> > [ 4377.461399] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4377.461401] CIFS: fs/cifs/smb2pdu.c: Query FSInfo level 1
> > [ 4377.461403] CIFS: fs/cifs/transport.c: wait_for_free_credits:
> > remove 1 credits total=289
> > [ 4377.461412] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4377.461418] CIFS: fs/cifs/transport.c: Sending smb: smb_len=161
> > [ 4377.462309] CIFS: fs/cifs/connect.c: RFC1002 header 0x9e
> > [ 4377.462322] CIFS: fs/cifs/smb2ops.c: Decrypt message returned 0
> > [ 4377.462324] CIFS: fs/cifs/smb2ops.c: mid found
> > [ 4377.462326] CIFS: fs/cifs/smb2misc.c: SMB2 data length 34 offset 72
> > [ 4377.462329] CIFS: fs/cifs/smb2misc.c: SMB2 len 106
> > [ 4377.462332] CIFS: fs/cifs/smb2ops.c: smb2_add_credits: added 10
> > credits total=299
> > [ 4377.462358] CIFS: fs/cifs/transport.c: cifs_sync_mid_result: cmd=16
> > mid=9 state=4
> > [ 4377.462363] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4377.462366] CIFS: fs/cifs/smb2pdu.c: Query FSInfo level 11
> > [ 4377.462376] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4377.463243] CIFS: fs/cifs/smb2ops.c: Decrypt message returned 0
> > [ 4377.463248] CIFS: fs/cifs/smb2ops.c: mid found
> > [ 4377.463250] CIFS: fs/cifs/smb2misc.c: SMB2 data length 28 offset 72
> > [ 4377.463278] CIFS: fs/cifs/misc.c: Null buffer passed to
> > cifs_small_buf_release
> > [ 4377.463283] CIFS: fs/cifs/smb2pdu.c: Close
> > [ 4377.463293] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4377.464259] CIFS: fs/cifs/smb2ops.c: Decrypt message returned 0
> > [ 4377.464262] CIFS: fs/cifs/smb2ops.c: mid found
> > [ 4377.464291] CIFS: fs/cifs/dfs_cache.c: cache_refresh_path: search
> > path: \cheekon\localnet
> > [ 4377.464297] CIFS: fs/cifs/dfs_cache.c: get_dfs_referral: get an DFS
> > referral for \cheekon\localnet
> > [ 4377.464299] CIFS: fs/cifs/smb2ops.c: smb2_get_dfs_refer: path:
> > \cheekon\localnet
> > [ 4377.464302] CIFS: fs/cifs/smb2pdu.c: SMB2 IOCTL
> > [ 4377.464311] CIFS: fs/cifs/smb2ops.c: Encrypt message returned 0
> > [ 4377.465280] CIFS: fs/cifs/smb2ops.c: Decrypt message returned 0
> > [ 4377.465286] CIFS: fs/cifs/smb2ops.c: mid found
> > [ 4377.465288] CIFS: fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
> > [ 4377.465322] CIFS: Status code returned 0xc000019c STATUS_FS_DRIVER_REQUIRED
> > [ 4377.465336] CIFS: fs/cifs/smb2maperror.c: Mapping SMB2 status code
> > 0xc000019c to POSIX err -95
> > [ 4377.465342] CIFS: fs/cifs/connect.c: is_path_remote: full_path:
> > [ 4377.465347] CIFS: fs/cifs/smb2pdu.c: create/open
> > [ 4377.466524] CIFS: fs/cifs/smb2pdu.c: Close
> > [ 4377.467607] CIFS: fs/cifs/smb2pdu.c: create/open
> > [ 4377.468787] CIFS: fs/cifs/smb2pdu.c: Close
> > [ 4377.469850] CIFS: fs/cifs/connect.c: VFS: leaving cifs_mount (xid =
> > 646) rc = 0
> > [ 4377.469856] CIFS: fs/cifs/sess.c: ses already at max_channels (1),
> > nothing to open
> > [ 4377.470004] CIFS: fs/cifs/inode.c: VFS: in cifs_root_iget as Xid:
> > 650 with uid: 0
> > [ 4377.471323] CIFS: fs/cifs/smb2misc.c: Calculated size 208 length
> > 512 mismatch mid 17
> > [ 4377.471344] CIFS: fs/cifs/smb2misc.c: Calculated size 174 length
> > 512 mismatch mid 18
> > [ 4377.471347] CIFS: fs/cifs/smb2misc.c: Calculated size 124 length
> > 512 mismatch mid 19
> > [ 4377.471395] CIFS: fs/cifs/smb2ops.c: get smb3 acl for path
> > [ 4377.471403] CIFS: fs/cifs/smb2ops.c: VFS: in get_smb2_acl_by_path
> > as Xid: 651 with uid: 0
> > [ 4377.471409] CIFS: fs/cifs/smb2pdu.c: create/open
> > [ 4377.472632] CIFS: fs/cifs/smb2pdu.c: Query Info
> > [ 4377.473671] CIFS: fs/cifs/smb2pdu.c: Close
> > [ 4377.474729] CIFS: fs/cifs/smb2ops.c: VFS: leaving
> > get_smb2_acl_by_path (xid = 651) rc = 0
> > [ 4377.474733] CIFS: fs/cifs/smb2ops.c: get_smb2_acl_by_path: rc = 0 ACL len 312
> > [ 4377.477086] CIFS: fs/cifs/cifsacl.c: sid_to_id: Can't map SID
> > os:S-1-5-21-122774138-3582407017-3610500266-1001 to a uid
> > [ 4377.478800] CIFS: fs/cifs/cifsacl.c: sid_to_id: Can't map SID
> > gs:S-1-22-2-1001 to a gid
> > [ 4377.478809] CIFS: fs/cifs/inode.c: looking for uniqueid=263248
> > [ 4377.478821] CIFS: fs/cifs/inode.c: cifs_revalidate_cache:
> > revalidating inode 263248
> > [ 4377.478823] CIFS: fs/cifs/inode.c: cifs_revalidate_cache: inode 263248 is new
> > [ 4377.478826] CIFS: fs/cifs/inode.c: VFS: leaving cifs_root_iget (xid
> > = 650) rc = 0
> > [ 4377.478830] CIFS: fs/cifs/cifsfs.c: Get root dentry for
> > [ 4377.478832] CIFS: fs/cifs/cifsfs.c: dentry root is: 0000000095b05357
> > [ 4377.480027] CIFS: fs/cifs/dir.c: VFS: in cifs_lookup as Xid: 652
> > with uid: 1000
> > [ 4377.480033] CIFS: fs/cifs/dir.c: parent inode = 0x00000000cc8fcd81
> > name is: .Trash and dentry = 0x000000001bf85909
> > [ 4377.480039] CIFS: fs/cifs/dir.c: NULL inode in lookup
> > [ 4377.480041] CIFS: fs/cifs/dir.c: Full path: \.Trash inode =
> > 0x0000000000000000
> > [ 4377.481529] CIFS: fs/cifs/cifsfs.c: VFS: in cifs_statfs as Xid: 653
> > with uid: 1000
> > [ 4377.481861] CIFS: fs/cifs/smb2misc.c: Calculated size 73 length 240
> > mismatch mid 23
> > [ 4377.481867] CIFS: fs/cifs/smb2misc.c: Calculated size 73 length 240
> > mismatch mid 24
> > [ 4377.481870] CIFS: fs/cifs/smb2misc.c: Calculated size 73 length 240
> > mismatch mid 25
> > [ 4377.481885] CIFS: Status code returned 0xc0000034
> > STATUS_OBJECT_NAME_NOT_FOUND
> > [ 4377.481893] CIFS: fs/cifs/smb2maperror.c: Mapping SMB2 status code
> > 0xc0000034 to POSIX err -2
> > [ 4377.481901] CIFS: fs/cifs/inode.c: cifs_get_inode_info: unhandled err rc -2
> > [ 4377.481905] CIFS: fs/cifs/dir.c: VFS: leaving cifs_lookup (xid = 652) rc = -2
> > [ 4377.481957] CIFS: fs/cifs/dir.c: VFS: in cifs_lookup as Xid: 654
> > with uid: 1000
> > [ 4377.481960] CIFS: fs/cifs/dir.c: parent inode = 0x00000000cc8fcd81
> > name is: .Trash-1000 and dentry = 0x000000007d3b3552
> > [ 4377.481966] CIFS: fs/cifs/dir.c: NULL inode in lookup
> > [ 4377.481967] CIFS: fs/cifs/dir.c: Full path: \.Trash-1000 inode =
> > 0x0000000000000000
> > [ 4377.483453] CIFS: fs/cifs/smb2misc.c: Calculated size 208 length
> > 440 mismatch mid 26
> > [ 4377.483463] CIFS: fs/cifs/smb2misc.c: Calculated size 104 length
> > 440 mismatch mid 27
> > [ 4377.483466] CIFS: fs/cifs/smb2misc.c: Calculated size 124 length
> > 440 mismatch mid 28
> > [ 4377.483491] CIFS: fs/cifs/cifsfs.c: VFS: leaving cifs_statfs (xid =
> > 653) rc = 0
> > [ 4377.484901] CIFS: Status code returned 0xc0000034
> > STATUS_OBJECT_NAME_NOT_FOUND
> > [ 4377.484908] CIFS: fs/cifs/smb2maperror.c: Mapping SMB2 status code
> > 0xc0000034 to POSIX err -2
> > [ 4377.484913] CIFS: fs/cifs/inode.c: cifs_get_inode_info: unhandled err rc -2
> > [ 4377.484916] CIFS: fs/cifs/dir.c: VFS: leaving cifs_lookup (xid = 654) rc = -2
> >
> >
> >
> > On Fri, Mar 4, 2022 at 9:01 AM Satadru Pramanik <satadru@gmail.com> wrote:
> >>
> >> Here is a subset of the recent dmesg during failed mounts, followed by
> >> an unmount and remount.
> >>
> >> On Fri, Mar 4, 2022 at 8:58 AM Satadru Pramanik <satadru@gmail.com> wrote:
> >>>
> >>> I have put this in my /etc/rc.local:
> >>> echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
> >>> echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
> >>> echo 7 > /proc/fs/cifs/cifsFYI
> >>>
> >>> I ran the commands again manually, and the attached dmesg appears to
> >>> be capturing some of the aforementioned reconnection efforts this
> >>> morning.
> >>>
> >>> On Fri, Mar 4, 2022 at 12:49 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >>>>
> >>>> On Wed, Mar 2, 2022 at 8:16 PM Satadru Pramanik <satadru@gmail.com> wrote:
> >>>>>
> >>>>> Here is also the dmesg as promised. (After resuming from suspend/sleep
> >>>>> this morning, when I again had the same issue.)
> >>>>>
> >>>>> On Wed, Mar 2, 2022 at 2:57 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >>>>>>
> >>>>>> On Wed, Mar 2, 2022 at 3:51 AM Satadru Pramanik <satadru@gmail.com> wrote:
> >>>>>>>
> >>>>>>> I have put the trace.dat and other debug files here since I can not
> >>>>>>> attach the files to a message to the list. (Apparently the trace.dat
> >>>>>>> file is too large.)
> >>>>>>>
> >>>>>>> https://drive.google.com/drive/folders/1wEi968RbXxivXMMH8J7XUsHhrxu9OWDX?usp=sharing
> >>>>>>>
> >>>>>>> On Mon, Feb 28, 2022 at 11:12 PM Satadru Pramanik <satadru@gmail.com> wrote:
> >>>>>>>>
> >>>>>>>> The trace.dat file is attached, covering the period before suspend,
> >>>>>>>> and through wake several hours later, when the mount no longer worked,
> >>>>>>>> and showed the CIFS: VFS: cifs_tree_connect: could not find
> >>>>>>>> superblock: -22 message, and through when I unmounted and remounted
> >>>>>>>> the share, which then started working.
> >>>>>>>>
> >>>>>>>> On Mon, Feb 28, 2022 at 9:31 AM Satadru Pramanik <satadru@gmail.com> wrote:
> >>>>>>>>>
> >>>>>>>>> Here is the DebugData from before and after from the system with the
> >>>>>>>>> failed mount.
> >>>>>>>>> Both systems are now running 5.17-rc6.
> >>>>>>>>>
> >>>>>>>>> Working on the trace-cmd now.
> >>>>>>>>>
> >>>>>>>>> On Sun, Feb 27, 2022 at 9:37 PM Steve French <smfrench@gmail.com> wrote:
> >>>>>>>>>>
> >>>>>>>>>> I would like to see the output of:
> >>>>>>>>>>
> >>>>>>>>>> /proc/fs/cifs/DebugData before and after the failure if possible.
> >>>>>>>>>>
> >>>>>>>>>> In addition, there would be some value in seeing trace information
> >>>>>>>>>> (e.g start tracing by
> >>>>>>>>>> "trace-cmd record -e cifs" before the failure and then forward the
> >>>>>>>>>> debug information displayed by "trace-cmd show" after the failure)
> >>>>>>>>>>
> >>>>>>>>>> On Sun, Feb 27, 2022 at 7:55 AM Thorsten Leemhuis
> >>>>>>>>>> <regressions@leemhuis.info> wrote:
> >>>>>>>>>>>
> >>>>>>>>>>> [TLDR: I'm adding the regression report below to regzbot, the Linux
> >>>>>>>>>>> kernel regression tracking bot; all text you find below is compiled from
> >>>>>>>>>>> a few templates paragraphs you might have encountered already already
> >>>>>>>>>>> from similar mails.]
> >>>>>>>>>>>
> >>>>>>>>>>> Hi, this is your Linux kernel regression tracker. Top-posting for once,
> >>>>>>>>>>> to make this easily accessible to everyone.
> >>>>>>>>>>>
> >>>>>>>>>>> CCing the regression mailing list, as it should be in the loop for all
> >>>>>>>>>>> regressions, as explained here:
> >>>>>>>>>>> https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html
> >>>>>>>>>>>
> >>>>>>>>>>> To be sure below issue doesn't fall through the cracks unnoticed, I'm
> >>>>>>>>>>> adding it to regzbot, my Linux kernel regression tracking bot:
> >>>>>>>>>>>
> >>>>>>>>>>> #regzbot ^introduced v5.16.11..v5.17-rc5
> >>>>>>>>>>> #regzbot title cifs: Failure to access cifs mount of samba share after
> >>>>>>>>>>> resume from sleep
> >>>>>>>>>>> #regzbot ignore-activity
> >>>>>>>>>>>
> >>>>>>>>>>> Reminder for developers: when fixing the issue, please add a 'Link:'
> >>>>>>>>>>> tags pointing to the report (the mail quoted above) using
> >>>>>>>>>>> lore.kernel.org/r/, as explained in
> >>>>>>>>>>> 'Documentation/process/submitting-patches.rst' and
> >>>>>>>>>>> 'Documentation/process/5.Posting.rst'. This allows the bot to connect
> >>>>>>>>>>> the report with any patches posted or committed to fix the issue; this
> >>>>>>>>>>> again allows the bot to show the current status of regressions and
> >>>>>>>>>>> automatically resolve the issue when the fix hits the right tree.
> >>>>>>>>>>>
> >>>>>>>>>>> I'm sending this to everyone that got the initial report, to make them
> >>>>>>>>>>> aware of the tracking. I also hope that messages like this motivate
> >>>>>>>>>>> people to directly get at least the regression mailing list and ideally
> >>>>>>>>>>> even regzbot involved when dealing with regressions, as messages like
> >>>>>>>>>>> this wouldn't be needed then. And don't worry, if I need to send other
> >>>>>>>>>>> mails regarding this regression only relevant for regzbot I'll send them
> >>>>>>>>>>> to the regressions lists only (with a tag in the subject so people can
> >>>>>>>>>>> filter them away). With a bit of luck no such messages will be needed
> >>>>>>>>>>> anyway.
> >>>>>>>>>>>
> >>>>>>>>>>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> >>>>>>>>>>>
> >>>>>>>>>>> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> >>>>>>>>>>> reports on my table. I can only look briefly into most of them and lack
> >>>>>>>>>>> knowledge about most of the areas they concern. I thus unfortunately
> >>>>>>>>>>> will sometimes get things wrong or miss something important. I hope
> >>>>>>>>>>> that's not the case here; if you think it is, don't hesitate to tell me
> >>>>>>>>>>> in a public reply, it's in everyone's interest to set the public record
> >>>>>>>>>>> straight.
> >>>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>> On 27.02.22 03:36, Satadru Pramanik wrote:
> >>>>>>>>>>>> I'm on a x86_64 ubuntu 22.04 system accessing a similar system running
> >>>>>>>>>>>> samba Version 4.13.14-Ubuntu. Both systems are on ubuntu mainline
> >>>>>>>>>>>> kernel 5.17-rc5.
> >>>>>>>>>>>>
> >>>>>>>>>>>> I have a samba share mounted from my fstab, and file access works fine.
> >>>>>>>>>>>> Upon suspending my system and resuming though, the mounted samba share
> >>>>>>>>>>>> is inaccessible, and my dmesg has many "CIFS: VFS: cifs_tree_connect:
> >>>>>>>>>>>> could not find superblock: -22" messages.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Unmounting and remounting the share restores access.
> >>>>>>>>>>>>
> >>>>>>>>>>>> When I boot into kernel 5.16.11, I do not have this issue. The cifs
> >>>>>>>>>>>> share is accessible just fine after a suspend/resume cycle.
> >>>>>>>>>>>>
> >>>>>>>>>>>> I assume this is a regression with 5.17? Is there any information
> >>>>>>>>>>>> worth providing which might help debug and fix this issue?
> >>>>>>>>>>>>
> >>>>>>>>>>>> Regards,
> >>>>>>>>>>>>
> >>>>>>>>>>>> Satadru Pramanik
> >>>>>>>>>>>
> >>>>>>>>>>> --
> >>>>>>>>>>> Additional information about regzbot:
> >>>>>>>>>>>
> >>>>>>>>>>> If you want to know more about regzbot, check out its web-interface, the
> >>>>>>>>>>> getting start guide, and the references documentation:
> >>>>>>>>>>>
> >>>>>>>>>>> https://linux-regtracking.leemhuis.info/regzbot/
> >>>>>>>>>>> https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
> >>>>>>>>>>> https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md
> >>>>>>>>>>>
> >>>>>>>>>>> The last two documents will explain how you can interact with regzbot
> >>>>>>>>>>> yourself if your want to.
> >>>>>>>>>>>
> >>>>>>>>>>> Hint for reporters: when reporting a regression it's in your interest to
> >>>>>>>>>>> CC the regression list and tell regzbot about the issue, as that ensures
> >>>>>>>>>>> the regression makes it onto the radar of the Linux kernel's regression
> >>>>>>>>>>> tracker -- that's in your interest, as it ensures your report won't fall
> >>>>>>>>>>> through the cracks unnoticed.
> >>>>>>>>>>>
> >>>>>>>>>>> Hint for developers: you normally don't need to care about regzbot once
> >>>>>>>>>>> it's involved. Fix the issue as you normally would, just remember to
> >>>>>>>>>>> include 'Link:' tag in the patch descriptions pointing to all reports
> >>>>>>>>>>> about the issue. This has been expected from developers even before
> >>>>>>>>>>> regzbot showed up for reasons explained in
> >>>>>>>>>>> 'Documentation/process/submitting-patches.rst' and
> >>>>>>>>>>> 'Documentation/process/5.Posting.rst'.
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> --
> >>>>>>>>>> Thanks,
> >>>>>>>>>>
> >>>>>>>>>> Steve
> >>>>>>
> >>>>>> The DebugData shows that the connection and smb session are fine, but
> >>>>>> the tree connect is not in a good state.
> >>>>>> Similarly, the trace output shows that connection was reconnected
> >>>>>> successfully, SMB session was reconnected as well. However, the tree
> >>>>>> connect did not go over the wire.
> >>>>>>
> >>>>>>> The trace.dat file is attached, covering the period before suspend,
> >>>>>>> and through wake several hours later, when the mount no longer worked,
> >>>>>>> and showed the CIFS: VFS: cifs_tree_connect: could not find
> >>>>>>> superblock: -22 message, and through when I unmounted and remounted
> >>>>>>> the share, which then started working.
> >>>>>>
> >>>>>> This suggests to me that the cifs_tcp_get_super is failing.
> >>>>>> This is odd, since it looks up the server as pointers.
> >>>>>> Did we start undercounting the ref count somewhere?
> >>>>>>
> >>>>>> --
> >>>>>> Regards,
> >>>>>> Shyam
> >>>>
> >>>> Hi Satadru,
> >>>>
> >>>> The attached dmesg did not have cifsFYI enabled.
> >>>> Please use the below steps to enable cifsFYI before the sleep:
> >>>> # echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
> >>>> # echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
> >>>> # echo 7 > /proc/fs/cifs/cifsFYI
> >>>>
> >>>> You can disable it after the repro using this cmd:
> >>>> # echo 0 > /proc/fs/cifs/cifsFYI
> >>>>
> >>>> --
> >>>> Regards,
> >>>> Shyam
> >



-- 
Thanks,

Steve
