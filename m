Return-Path: <SRS0=2f0v=6P=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A96C47253
	for <linux-cifs@archiver.kernel.org>; Fri,  1 May 2020 15:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D040C216FD
	for <linux-cifs@archiver.kernel.org>; Fri,  1 May 2020 15:56:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pu6GIvDa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgEAP4t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 May 2020 11:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728495AbgEAP4t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 May 2020 11:56:49 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0A0C061A0C
        for <linux-cifs@vger.kernel.org>; Fri,  1 May 2020 08:56:47 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id t9so5164715ybo.8
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2020 08:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LqrJ+jerikjiLEc4zXG9wDdfIh+WRxb76ALmjhrIK7s=;
        b=pu6GIvDavvXUYJBF5niNIJqIVhWFX2CRR2wv4iXI7tEdFy4hQMNOZL3oS3NCii/4ud
         ZxJIhlJ6ZaFiKwcFRjMFnZydsTcYbhbB4ITK05CC1gFTb/khp1Iq8OUdhsUnAoSMgqhX
         CBW8ZGN5N4JQahpweoDAoWC4q1JWRMYj1DpIwWmHC/RQlzmLPcSwnf5ett6hKb9VN6S3
         CX4HXKzz8GLNnp1CJXFyLUXtkrmiH3h2VhJOjxNbN7RXUP4U+KNFUKrU57j27hiEjtJb
         i8oa27h+i38hrmf4QhnkAB/dJnWaG5DHIV0Hi5gclTCUfDfDIGYApNXN1eVhCFZNYUo3
         3LvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LqrJ+jerikjiLEc4zXG9wDdfIh+WRxb76ALmjhrIK7s=;
        b=nPQU6sBC7kgmpI6kX8rUjaV4G+y1U6MrkWOSOATVx84pQVqtfKMYSKL6wcjPiREVyf
         RALcQrzKjJPRZeiQwMhx1szi1XW9kPQPivx9x86Pmr+TrVC5aekSv/mTcc2DlI9g+zlF
         MEKKls8wof6x6GruzfxZsx74MNsfEJAesC2GMnfYzLKS/umRk8Ly8bMumbDgNpv0UKHh
         jj6S7XnrEqoSk8eNJuqFw5TaPE531nOmKNW3e+MGZbR/6dEemiuxR1QVy0AqF6i811Gp
         VXhbX1KQJHi61xW+diboqqelWTUVP4C03SEPDeTxr5XAH8n3fLxnLYrVbtvU9GU26yBs
         WFcA==
X-Gm-Message-State: AGi0PuYHpR6p5LSeRVxBHiwXXsgZHvbpm9R61Jtaq4kitD7l9p9Tpd7G
        byYUq9T0fFR5FzeyIidO7v/62o7natRTQ3juaY/8LYB3vD8=
X-Google-Smtp-Source: APiQypIHodzmacuHzUeRV3MwWXFNU71K9Xtl4sKsq3nGUqGw8RdzmV9fqh5fESVUNBuHf0/Bp/dnham3t/ySPJeVm5M=
X-Received: by 2002:a25:e907:: with SMTP id n7mr7182240ybd.85.1588348606790;
 Fri, 01 May 2020 08:56:46 -0700 (PDT)
MIME-Version: 1.0
References: <52e802d7dde642c29662e9e05019c323@wynstonegroup.com>
 <CAH2r5msOBGS7QYagUkby4upxFKbxCdQg=T65K4s9VhRKkWY+Xw@mail.gmail.com>
 <5924ec7684ff4dd1ab853b1574cb140e@wynstonegroup.com> <37908dec611a429c9055f84fc9958745@wynstonegroup.com>
In-Reply-To: <37908dec611a429c9055f84fc9958745@wynstonegroup.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 1 May 2020 10:56:36 -0500
Message-ID: <CAH2r5mtSXjyFOaPY5oKx2TDh6wZrUuZsFqqc7A=+jkG8zQsfKA@mail.gmail.com>
Subject: Re: issues with CIFS on Ubuntu 20 mounting Windows 2019
To:     "Scott M. Lewandowski" <vgerkernel@scottl.com>
Cc:     "Scott M. Lewandowski" <scott@wynstonegroup.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Are you comfortable with dynamic tracing ("trace-cmd record -e ..."
... the list of trace points can be seen in
/sys/kernel/debug/tracing/events/cifs)?

On Fri, May 1, 2020 at 10:40 AM Scott M. Lewandowski
<vgerkernel@scottl.com> wrote:
>
> I=E2=80=99m also seeing entries like the following mixed in with the othe=
r messages:
>
> [27078.665192] CIFS VFS: \\file1 Cancelling wait for mid 13443257 cmd: 5
>
> And
>
> [31833.351785] CIFS VFS: cifs_invalidate_mapping: could not invalidate in=
ode 00000000b4733e96
>
>
>
>
> > -----Original Message-----
> > From: Scott M. Lewandowski <vgerkernel@scottl.com>
> > Sent: Friday, May 1, 2020 12:20 AM
> > To: 'Steve French' <smfrench@gmail.com>
> > Cc: CIFS <linux-cifs@vger.kernel.org>
> > Subject: RE: issues with CIFS on Ubuntu 20 mounting Windows 2019
> >
> > > EINTR on read ... Hundreds of times?! I have seen scp do that by
> > > sending signals but in writes not reads
> >
> > Not using scp at the moment.
> >
> > > Could an app be sending signals trying to kill the process doing the =
reads?
> >
> > Not that I'm aware of. I'm not sure exactly how I'd check that, but I w=
ill look
> > into it.
> >
> > One other thing that came to mind that may be helpful is that one of th=
e
> > processes doing the most IO is running under mono 6.8.0.105
> >
> > -scott
> >
> >
> >
> >
> > From: Steve French <smfrench@gmail.com>
> > Sent: Friday, May 1, 2020 12:07 AM
> > To: Scott M. Lewandowski <vgerkernel@scottl.com>
> > Cc: CIFS <linux-cifs@vger.kernel.org>
> > Subject: Re: issues with CIFS on Ubuntu 20 mounting Windows 2019
> >
> > EINTR on read ... Hundreds of times?! I have seen scp do that by sendin=
g
> > signals but in writes not reads
> >
> > On Thu, Apr 30, 2020, 23:48 Scott M. Lewandowski
> > <mailto:vgerkernel@scottl.com> wrote:
> > I have an Ubuntu 20.04 box mounting shares from a Windows 2019 server.
> > Both boxes are fully patched. They are resident on the same hypervisor =
and
> > communicating directly via a vSwitch. I have 4 shares mounted; here is =
an
> > example from my fstab (yes, I know I should move the credential file):
> >
> > //file1/usenet /mnt/usenet cifs
> > vers=3D3.0,uid=3Dscott,credentials=3D/home/scott/.smbcredentials,noserv=
erino,n
> > ounix,iocharset=3Dutf8 0 0
> >
> > My kernel is 5.4.0-28-generic and mount.cifs version is 6.9. The conten=
ts of
> > DebugData are included below.
> >
> > Right after the mount, I see a duplicate cookie reported. It is unclear=
 if this is
> > a problem or not. Following that, I periodically see messages similar t=
o the
> > following repeated in dmesg:
> >
> > [  179.625296] SMB2_read: 9 callbacks suppressed [  179.625298] CIFS VF=
S:
> > Send error in read =3D -4 [  179.704191] CIFS VFS: Send error in read =
=3D -4
> > [  179.847514] CIFS VFS: Send error in read =3D -4 [  180.031516] CIFS =
VFS: Send
> > error in read =3D -4 [  180.214848] CIFS VFS: Send error in read =3D -4
> > [  180.282909] CIFS VFS: Send error in read =3D -4 [  180.474829] CIFS =
VFS: Send
> > error in read =3D -4 [  180.621349] CIFS VFS: Send error in read =3D -4
> > [  180.780465] CIFS VFS: Send error in read =3D -4 [  180.823249] CIFS =
VFS: Send
> > error in read =3D -4 [  182.339351] CIFS VFS: Close unmatched open
> > [  182.726829] CIFS VFS: Close unmatched open [  184.292663] CIFS VFS: =
Close
> > unmatched open [  184.501185] CIFS VFS: Close unmatched open
> > [  191.784922] SMB2_read: 4 callbacks suppressed [  191.784925] CIFS VF=
S:
> > Send error in read =3D -4 [  191.884186] CIFS VFS: Send error in read =
=3D -4
> > [  192.270851] CIFS VFS: Send error in read =3D -4 [  192.323467] CIFS =
VFS: Send
> > error in read =3D -4 [  192.381336] CIFS VFS: Send error in read =3D -4
> > [  192.446711] CIFS VFS: Send error in read =3D -4 [  192.507605] CIFS =
VFS: Send
> > error in read =3D -4 [  193.244397] CIFS VFS: Send error in read =3D -4
> > [  193.307588] CIFS VFS: Send error in read =3D -4 [  193.403410] CIFS =
VFS: Send
> > error in read =3D -4 [  193.797038] CIFS VFS: Close unmatched open
> > [  196.784082] CIFS VFS: Close unmatched open [  198.247594] CIFS VFS: =
Close
> > unmatched open
> >
> > Here is the duplicate cookie info:
> >
> > [   21.713307] FS-Cache: Duplicate cookie detected [   21.713840] FS-Ca=
che: O-
> > cookie c=3D00000000e8276279 [p=3D0000000079ef0365 fl=3D222 nc=3D0 na=3D=
1]
> > [   21.714330] FS-Cache: O-cookie d=3D00000000173ea0ee n=3D00000000243f=
210c
> > [   21.714779] FS-Cache: O-key=3D[8] '020001bdc0a801af'
> > [   21.715219] FS-Cache: N-cookie c=3D00000000afb49d9c [p=3D0000000079e=
f0365
> > fl=3D2 nc=3D0 na=3D1] [   21.715672] FS-Cache: N-cookie d=3D00000000173=
ea0ee
> > n=3D00000000dd1465c5 [   21.716141] FS-Cache: N-key=3D[8] '020001bdc0a8=
01af'
> > [   21.716591] FS-Cache: Duplicate cookie detected [   21.717217] FS-Ca=
che: O-
> > cookie c=3D00000000e8276279 [p=3D0000000079ef0365 fl=3D222 nc=3D0 na=3D=
1]
> > [   21.717679] FS-Cache: O-cookie d=3D00000000173ea0ee n=3D00000000243f=
210c
> > [   21.718220] FS-Cache: O-key=3D[8] '020001bdc0a801af'
> > [   21.718681] FS-Cache: N-cookie c=3D0000000063665cf7 [p=3D0000000079e=
f0365
> > fl=3D2 nc=3D0 na=3D1] [   21.719166] FS-Cache: N-cookie d=3D00000000173=
ea0ee
> > n=3D00000000e757f917 [   21.719621] FS-Cache: N-key=3D[8] '020001bdc0a8=
01af'
> > [   21.720097] FS-Cache: Duplicate cookie detected [   21.720565] FS-Ca=
che: O-
> > cookie c=3D00000000e8276279 [p=3D0000000079ef0365 fl=3D222 nc=3D0 na=3D=
1]
> > [   21.721053] FS-Cache: O-cookie d=3D00000000173ea0ee n=3D00000000243f=
210c
> > [   21.721518] FS-Cache: O-key=3D[8] '020001bdc0a801af'
> > [   21.721994] FS-Cache: N-cookie c=3D00000000d479c294 [p=3D0000000079e=
f0365
> > fl=3D2 nc=3D0 na=3D1] [   21.722476] FS-Cache: N-cookie d=3D00000000173=
ea0ee
> > n=3D00000000ca1891fa [   21.722941] FS-Cache: N-key=3D[8] '020001bdc0a8=
01af'
> >
> > Any ideas what could be going on?
> >
> > Thanks for any help!
> >
> >
> >
> >
> >
> >
> > DebugData:
> > CIFS Version 2.23
> > Features:
> > DFS,FSCACHE,STATS,DEBUG,ALLOW_INSECURE_LEGACY,WEAK_PW_HASH,C
> > IFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
> > CIFSMaxBufSize: 16384
> > Active VFS Requests: 0
> > Servers:
> > Number of credits: 8190 Dialect 0x300
> > 1) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Status:=
 1 TCP
> > status: 1 Instance: 1
> >         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 SessionId:
> > 0x100080000021
> >         Shares:
> >         0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
> >         Share Capabilities: None        Share Flags: 0x30
> >         tid: 0x1        Maximal Access: 0x11f01ff
> >
> >         1) \\file1\XXX Mounts: 1 DevInfo: 0x20020 Attributes: 0x8500df
> >         PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xa3c=
339a0
> >         Share Capabilities: None Aligned, Partition Aligned,    Share F=
lags: 0x0
> >         tid: 0x5        Optimal sector size: 0x200      Maximal Access:=
 0x1f01ff
> >
> >         MIDs:
> >
> >         Server interfaces: 2
> >         0)      Speed: 10000000000 bps
> >                 Capabilities:
> >                 IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
> >         1)      Speed: 10000000000 bps
> >                 Capabilities:
> >                 IPv4: 192.168.1.175
> > Number of credits: 8190 Dialect 0x300
> >
> > 2) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Status:=
 1 TCP
> > status: 1 Instance: 1
> >         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 SessionId:
> > 0x10006c000019
> >         Shares:
> >         0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
> >         Share Capabilities: None        Share Flags: 0x30
> >         tid: 0x1        Maximal Access: 0x11f01ff
> >
> >         1) \\file1\usenet Mounts: 1 DevInfo: 0x20020 Attributes: 0x8500=
df
> >         PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xa3c=
339a0
> >         Share Capabilities: None Aligned, Partition Aligned,    Share F=
lags: 0x0
> >         tid: 0x5        Optimal sector size: 0x200      Maximal Access:=
 0x1f01ff
> >
> >         MIDs:
> >
> >         Server interfaces: 2
> >         0)      Speed: 10000000000 bps
> >                 Capabilities:
> >                 IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
> >         1)      Speed: 10000000000 bps
> >                 Capabilities:
> >                 IPv4: 192.168.1.175
> >
> >
> > 3) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Status:=
 1 TCP
> > status: 1 Instance: 1
> >         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 2 SessionId:
> > 0x10007c000061
> >         Shares:
> >         0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
> >         Share Capabilities: None        Share Flags: 0x30
> >         tid: 0x1        Maximal Access: 0x11f01ff
> >
> >         1) \\file1\YYY Mounts: 1 DevInfo: 0x20020 Attributes: 0x8500df
> >         PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xa3c=
339a0
> >         Share Capabilities: None Aligned, Partition Aligned,    Share F=
lags: 0x0
> >         tid: 0x5        Optimal sector size: 0x200      Maximal Access:=
 0x1f01ff
> >
> >         MIDs:
> >         State: 2 com: 8 pid: 1218 cbdata: 00000000e45c59d2 mid 1211489
> >         State: 2 com: 8 pid: 1218 cbdata: 0000000018476195 mid 1211553
> >
> >         Server interfaces: 2
> >         0)      Speed: 10000000000 bps
> >                 Capabilities:
> >                 IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
> >         1)      Speed: 10000000000 bps
> >                 Capabilities:
> >                 IPv4: 192.168.1.175
> >
> > Number of credits: 8190 Dialect 0x300
> > 4) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Status:=
 1 TCP
> > status: 1 Instance: 1
> >         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 SessionId:
> > 0x10006c000055
> >         Shares:
> >         0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
> >         Share Capabilities: None        Share Flags: 0x30
> >         tid: 0x1        Maximal Access: 0x11f01ff
> >
> >         1) \\file1\ZZZ Mounts: 1 DevInfo: 0x20020 Attributes: 0x8500df
> >         PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xa3c=
339a0
> >         Share Capabilities: None Aligned, Partition Aligned,    Share F=
lags: 0x0
> >         tid: 0x5        Optimal sector size: 0x200      Maximal Access:=
 0x1f01ff
> >
> >         MIDs:
> >
> >         Server interfaces: 2
> >         0)      Speed: 10000000000 bps
> >                 Capabilities:
> >                 IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
> >         1)      Speed: 10000000000 bps
> >                 Capabilities:
> >                 IPv4: 192.168.1.175



--=20
Thanks,

Steve
