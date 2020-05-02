Return-Path: <SRS0=2HAQ=6Q=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEBAC3A5A9
	for <linux-cifs@archiver.kernel.org>; Sat,  2 May 2020 06:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC6A72137B
	for <linux-cifs@archiver.kernel.org>; Sat,  2 May 2020 06:02:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YO09C+3Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgEBGCW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 May 2020 02:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726468AbgEBGCV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 May 2020 02:02:21 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BBAC061A0C
        for <linux-cifs@vger.kernel.org>; Fri,  1 May 2020 23:02:21 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id b17so6060110ybq.13
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2020 23:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bPujRJCBpsdHWdB+GYFeZ9NJiBELwW0kDy3YCAnZ7l8=;
        b=YO09C+3YNI8ttcYpZ5T6f0QrHKFfG3VfI/il3OUxyenulRP6ux+NjjwRiYjbyp43px
         fb/gCF8Mf2QHOjePnpDLlNPy3rUOGbP/qe9W4/m5zStK/qaNx0tOOOz9ajQ++EHa9yyC
         gjoeAhrTN7uNVUSh37mN8vPxvZmOTKP14ipxzVbmzuIK68yMDc9BiOXy2SQdce6jCpNF
         SC1EEvO1wqLg9OWf/3+YzIDk0AbJGn9ki+z7E6u0nAZaAaBhl5zj51XaLdXIlU96Xb0t
         8qY2Qu79efBhhpqC0971d9Q6dN93Udp/DNKn42fpqSNnJr6gMJCL7WcXGahFFNo89d7+
         xHZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bPujRJCBpsdHWdB+GYFeZ9NJiBELwW0kDy3YCAnZ7l8=;
        b=ZxX6tHgsuHcT8gsywocPCfiAxKq+htS3VnXZcbLR6BCkKrUFw3ijNckLtx8bdBZzMC
         8X06JDZIoH8PLbqtmj0I2BLUuRioagGtSEztikKtwCHqg+hZRM6ZyrPKD4NRJPrqcYAO
         5d4PQ90L/l0qTFS6IijlOJ4oTotVYvXy7AzTSRQfm5//8SW07tB0SMGTKk+ORopDoCx4
         PTq516vsUz5rstXH3i95ojBK8EhQoc9KSiWt/XYs1mZbQWj/d5W90vy7mE14OOayzo1u
         vDye6KBuAVLT74pJiQr3zsc8hqQ7asouqRL9Bf5RqyCXwj+dowPemLIJLR1zioA2z+6I
         M+Og==
X-Gm-Message-State: AGi0PuZLVtaoqfmZPZ8kndlKajvR3S3OKRKf0R7t7wERw1/rX4xvz/cg
        3mxq7bLacYeKHPrua6g3oLu31cYsdbiJK57YmnttAE2I
X-Google-Smtp-Source: APiQypKzA+OJPAMt/Xdrc32Ss2401JWTAVnDlEyUzeNlKciakvrNwn4s/eSFIATShbLQzCLT0nDa6emi7hi+X5+yh2M=
X-Received: by 2002:a25:e907:: with SMTP id n7mr11648440ybd.85.1588399340558;
 Fri, 01 May 2020 23:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <52e802d7dde642c29662e9e05019c323@wynstonegroup.com>
 <CAH2r5msOBGS7QYagUkby4upxFKbxCdQg=T65K4s9VhRKkWY+Xw@mail.gmail.com>
 <5924ec7684ff4dd1ab853b1574cb140e@wynstonegroup.com> <37908dec611a429c9055f84fc9958745@wynstonegroup.com>
 <CAH2r5mtSXjyFOaPY5oKx2TDh6wZrUuZsFqqc7A=+jkG8zQsfKA@mail.gmail.com> <14d642e4db6e42cc853755660d0bba20@wynstonegroup.com>
In-Reply-To: <14d642e4db6e42cc853755660d0bba20@wynstonegroup.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 2 May 2020 01:02:09 -0500
Message-ID: <CAH2r5msMw29oL4uscBvK18UwJd4ag+iiJojQ1Rk1UZERodgDEQ@mail.gmail.com>
Subject: Re: issues with CIFS on Ubuntu 20 mounting Windows 2019
To:     "Scott M. Lewandowski" <vgerkernel@scottl.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I would expect the close unmatched open to be related to the session
being closed (thus all files implicitly closed on the server) but the
session drop overlapping the application closing a file.

On Fri, May 1, 2020 at 2:39 PM Scott M. Lewandowski
<vgerkernel@scottl.com> wrote:
>
> I've now got a trace that corresponds to the dmesg output below. I will t=
ake a look later, but upon quick glance, this doesn't look like anything th=
at will mean much to me, unfortunately. If someone would like to look at th=
e file I can find a way to get it to you.
>
>
> [53223.099221] CIFS VFS: Send error in read =3D -4
> [53223.232373] CIFS VFS: Send error in read =3D -4
> [53254.762914] CIFS VFS: Send error in read =3D -4
> [53301.403925] CIFS VFS: Send error in read =3D -4
> [53301.772568] CIFS VFS: Send error in read =3D -4
> [53301.818566] CIFS VFS: Send error in read =3D -4
> [53301.885510] CIFS VFS: Send error in read =3D -4
> [53302.055959] CIFS VFS: Send error in read =3D -4
> [53302.146337] CIFS VFS: Send error in read =3D -4
> [53302.236322] CIFS VFS: Send error in read =3D -4
> [53302.329525] CIFS VFS: Send error in read =3D -4
> [53303.000869] CIFS VFS: Send error in read =3D -4
> [53303.106961] CIFS VFS: Send error in read =3D -4
> [53304.756998] CIFS VFS: Close unmatched open
> [53670.776832] CIFS VFS: Close unmatched open
>
>
> > -----Original Message-----
> > From: Steve French <smfrench@gmail.com>
> > Sent: Friday, May 1, 2020 10:57 AM
> > To: Scott M. Lewandowski <vgerkernel@scottl.com>
> > Cc: Scott M. Lewandowski <scott@wynstonegroup.com>; CIFS <linux-
> > cifs@vger.kernel.org>
> > Subject: Re: issues with CIFS on Ubuntu 20 mounting Windows 2019
> >
> > Are you comfortable with dynamic tracing ("trace-cmd record -e ..."
> > ... the list of trace points can be seen in
> > /sys/kernel/debug/tracing/events/cifs)?
> >
> > On Fri, May 1, 2020 at 10:40 AM Scott M. Lewandowski
> > <vgerkernel@scottl.com> wrote:
> > >
> > > I=E2=80=99m also seeing entries like the following mixed in with the =
other messages:
> > >
> > > [27078.665192] CIFS VFS: \\file1 Cancelling wait for mid 13443257 cmd=
:
> > > 5
> > >
> > > And
> > >
> > > [31833.351785] CIFS VFS: cifs_invalidate_mapping: could not invalidat=
e
> > > inode 00000000b4733e96
> > >
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Scott M. Lewandowski <vgerkernel@scottl.com>
> > > > Sent: Friday, May 1, 2020 12:20 AM
> > > > To: 'Steve French' <smfrench@gmail.com>
> > > > Cc: CIFS <linux-cifs@vger.kernel.org>
> > > > Subject: RE: issues with CIFS on Ubuntu 20 mounting Windows 2019
> > > >
> > > > > EINTR on read ... Hundreds of times?! I have seen scp do that by
> > > > > sending signals but in writes not reads
> > > >
> > > > Not using scp at the moment.
> > > >
> > > > > Could an app be sending signals trying to kill the process doing =
the
> > reads?
> > > >
> > > > Not that I'm aware of. I'm not sure exactly how I'd check that, but
> > > > I will look into it.
> > > >
> > > > One other thing that came to mind that may be helpful is that one o=
f
> > > > the processes doing the most IO is running under mono 6.8.0.105
> > > >
> > > > -scott
> > > >
> > > >
> > > >
> > > >
> > > > From: Steve French <smfrench@gmail.com>
> > > > Sent: Friday, May 1, 2020 12:07 AM
> > > > To: Scott M. Lewandowski <vgerkernel@scottl.com>
> > > > Cc: CIFS <linux-cifs@vger.kernel.org>
> > > > Subject: Re: issues with CIFS on Ubuntu 20 mounting Windows 2019
> > > >
> > > > EINTR on read ... Hundreds of times?! I have seen scp do that by
> > > > sending signals but in writes not reads
> > > >
> > > > On Thu, Apr 30, 2020, 23:48 Scott M. Lewandowski
> > > > <mailto:vgerkernel@scottl.com> wrote:
> > > > I have an Ubuntu 20.04 box mounting shares from a Windows 2019
> > server.
> > > > Both boxes are fully patched. They are resident on the same
> > > > hypervisor and communicating directly via a vSwitch. I have 4 share=
s
> > > > mounted; here is an example from my fstab (yes, I know I should mov=
e
> > the credential file):
> > > >
> > > > //file1/usenet /mnt/usenet cifs
> > > > vers=3D3.0,uid=3Dscott,credentials=3D/home/scott/.smbcredentials,no=
serveri
> > > > no,n
> > > > ounix,iocharset=3Dutf8 0 0
> > > >
> > > > My kernel is 5.4.0-28-generic and mount.cifs version is 6.9. The
> > > > contents of DebugData are included below.
> > > >
> > > > Right after the mount, I see a duplicate cookie reported. It is
> > > > unclear if this is a problem or not. Following that, I periodically
> > > > see messages similar to the following repeated in dmesg:
> > > >
> > > > [  179.625296] SMB2_read: 9 callbacks suppressed [  179.625298] CIF=
S VFS:
> > > > Send error in read =3D -4 [  179.704191] CIFS VFS: Send error in re=
ad
> > > > =3D -4 [  179.847514] CIFS VFS: Send error in read =3D -4 [  180.03=
1516]
> > > > CIFS VFS: Send error in read =3D -4 [  180.214848] CIFS VFS: Send
> > > > error in read =3D -4 [  180.282909] CIFS VFS: Send error in read =
=3D -4
> > > > [  180.474829] CIFS VFS: Send error in read =3D -4 [  180.621349] C=
IFS
> > > > VFS: Send error in read =3D -4 [  180.780465] CIFS VFS: Send error =
in
> > > > read =3D -4 [  180.823249] CIFS VFS: Send error in read =3D -4 [
> > > > 182.339351] CIFS VFS: Close unmatched open [  182.726829] CIFS VFS:
> > > > Close unmatched open [  184.292663] CIFS VFS: Close unmatched open =
[
> > > > 184.501185] CIFS VFS: Close unmatched open [  191.784922] SMB2_read=
:
> > 4 callbacks suppressed [  191.784925] CIFS VFS:
> > > > Send error in read =3D -4 [  191.884186] CIFS VFS: Send error in re=
ad
> > > > =3D -4 [  192.270851] CIFS VFS: Send error in read =3D -4 [  192.32=
3467]
> > > > CIFS VFS: Send error in read =3D -4 [  192.381336] CIFS VFS: Send
> > > > error in read =3D -4 [  192.446711] CIFS VFS: Send error in read =
=3D -4
> > > > [  192.507605] CIFS VFS: Send error in read =3D -4 [  193.244397] C=
IFS
> > > > VFS: Send error in read =3D -4 [  193.307588] CIFS VFS: Send error =
in
> > > > read =3D -4 [  193.403410] CIFS VFS: Send error in read =3D -4 [
> > > > 193.797038] CIFS VFS: Close unmatched open [  196.784082] CIFS VFS:
> > > > Close unmatched open [  198.247594] CIFS VFS: Close unmatched open
> > > >
> > > > Here is the duplicate cookie info:
> > > >
> > > > [   21.713307] FS-Cache: Duplicate cookie detected [   21.713840] F=
S-
> > Cache: O-
> > > > cookie c=3D00000000e8276279 [p=3D0000000079ef0365 fl=3D222 nc=3D0 n=
a=3D1]
> > > > [   21.714330] FS-Cache: O-cookie d=3D00000000173ea0ee
> > n=3D00000000243f210c
> > > > [   21.714779] FS-Cache: O-key=3D[8] '020001bdc0a801af'
> > > > [   21.715219] FS-Cache: N-cookie c=3D00000000afb49d9c
> > [p=3D0000000079ef0365
> > > > fl=3D2 nc=3D0 na=3D1] [   21.715672] FS-Cache: N-cookie d=3D0000000=
0173ea0ee
> > > > n=3D00000000dd1465c5 [   21.716141] FS-Cache: N-key=3D[8]
> > '020001bdc0a801af'
> > > > [   21.716591] FS-Cache: Duplicate cookie detected [   21.717217] F=
S-
> > Cache: O-
> > > > cookie c=3D00000000e8276279 [p=3D0000000079ef0365 fl=3D222 nc=3D0 n=
a=3D1]
> > > > [   21.717679] FS-Cache: O-cookie d=3D00000000173ea0ee
> > n=3D00000000243f210c
> > > > [   21.718220] FS-Cache: O-key=3D[8] '020001bdc0a801af'
> > > > [   21.718681] FS-Cache: N-cookie c=3D0000000063665cf7
> > [p=3D0000000079ef0365
> > > > fl=3D2 nc=3D0 na=3D1] [   21.719166] FS-Cache: N-cookie d=3D0000000=
0173ea0ee
> > > > n=3D00000000e757f917 [   21.719621] FS-Cache: N-key=3D[8]
> > '020001bdc0a801af'
> > > > [   21.720097] FS-Cache: Duplicate cookie detected [   21.720565] F=
S-
> > Cache: O-
> > > > cookie c=3D00000000e8276279 [p=3D0000000079ef0365 fl=3D222 nc=3D0 n=
a=3D1]
> > > > [   21.721053] FS-Cache: O-cookie d=3D00000000173ea0ee
> > n=3D00000000243f210c
> > > > [   21.721518] FS-Cache: O-key=3D[8] '020001bdc0a801af'
> > > > [   21.721994] FS-Cache: N-cookie c=3D00000000d479c294
> > [p=3D0000000079ef0365
> > > > fl=3D2 nc=3D0 na=3D1] [   21.722476] FS-Cache: N-cookie d=3D0000000=
0173ea0ee
> > > > n=3D00000000ca1891fa [   21.722941] FS-Cache: N-key=3D[8]
> > '020001bdc0a801af'
> > > >
> > > > Any ideas what could be going on?
> > > >
> > > > Thanks for any help!
> > > >
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > DebugData:
> > > > CIFS Version 2.23
> > > > Features:
> > > >
> > DFS,FSCACHE,STATS,DEBUG,ALLOW_INSECURE_LEGACY,WEAK_PW_HASH,C
> > > > IFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
> > > > CIFSMaxBufSize: 16384
> > > > Active VFS Requests: 0
> > > > Servers:
> > > > Number of credits: 8190 Dialect 0x300
> > > > 1) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Sta=
tus: 1
> > TCP
> > > > status: 1 Instance: 1
> > > >         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Sessio=
nId:
> > > > 0x100080000021
> > > >         Shares:
> > > >         0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> > > >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
> > > >         Share Capabilities: None        Share Flags: 0x30
> > > >         tid: 0x1        Maximal Access: 0x11f01ff
> > > >
> > > >         1) \\file1\XXX Mounts: 1 DevInfo: 0x20020 Attributes: 0x850=
0df
> > > >         PathComponentMax: 255 Status: 1 type: DISK Serial Number:
> > 0xa3c339a0
> > > >         Share Capabilities: None Aligned, Partition Aligned,    Sha=
re Flags: 0x0
> > > >         tid: 0x5        Optimal sector size: 0x200      Maximal Acc=
ess: 0x1f01ff
> > > >
> > > >         MIDs:
> > > >
> > > >         Server interfaces: 2
> > > >         0)      Speed: 10000000000 bps
> > > >                 Capabilities:
> > > >                 IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
> > > >         1)      Speed: 10000000000 bps
> > > >                 Capabilities:
> > > >                 IPv4: 192.168.1.175
> > > > Number of credits: 8190 Dialect 0x300
> > > >
> > > > 2) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Sta=
tus: 1
> > TCP
> > > > status: 1 Instance: 1
> > > >         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Sessio=
nId:
> > > > 0x10006c000019
> > > >         Shares:
> > > >         0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> > > >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
> > > >         Share Capabilities: None        Share Flags: 0x30
> > > >         tid: 0x1        Maximal Access: 0x11f01ff
> > > >
> > > >         1) \\file1\usenet Mounts: 1 DevInfo: 0x20020 Attributes: 0x=
8500df
> > > >         PathComponentMax: 255 Status: 1 type: DISK Serial Number:
> > 0xa3c339a0
> > > >         Share Capabilities: None Aligned, Partition Aligned,    Sha=
re Flags: 0x0
> > > >         tid: 0x5        Optimal sector size: 0x200      Maximal Acc=
ess: 0x1f01ff
> > > >
> > > >         MIDs:
> > > >
> > > >         Server interfaces: 2
> > > >         0)      Speed: 10000000000 bps
> > > >                 Capabilities:
> > > >                 IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
> > > >         1)      Speed: 10000000000 bps
> > > >                 Capabilities:
> > > >                 IPv4: 192.168.1.175
> > > >
> > > >
> > > > 3) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Sta=
tus: 1
> > TCP
> > > > status: 1 Instance: 1
> > > >         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 2 Sessio=
nId:
> > > > 0x10007c000061
> > > >         Shares:
> > > >         0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> > > >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
> > > >         Share Capabilities: None        Share Flags: 0x30
> > > >         tid: 0x1        Maximal Access: 0x11f01ff
> > > >
> > > >         1) \\file1\YYY Mounts: 1 DevInfo: 0x20020 Attributes: 0x850=
0df
> > > >         PathComponentMax: 255 Status: 1 type: DISK Serial Number:
> > 0xa3c339a0
> > > >         Share Capabilities: None Aligned, Partition Aligned,    Sha=
re Flags: 0x0
> > > >         tid: 0x5        Optimal sector size: 0x200      Maximal Acc=
ess: 0x1f01ff
> > > >
> > > >         MIDs:
> > > >         State: 2 com: 8 pid: 1218 cbdata: 00000000e45c59d2 mid 1211=
489
> > > >         State: 2 com: 8 pid: 1218 cbdata: 0000000018476195 mid
> > > > 1211553
> > > >
> > > >         Server interfaces: 2
> > > >         0)      Speed: 10000000000 bps
> > > >                 Capabilities:
> > > >                 IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
> > > >         1)      Speed: 10000000000 bps
> > > >                 Capabilities:
> > > >                 IPv4: 192.168.1.175
> > > >
> > > > Number of credits: 8190 Dialect 0x300
> > > > 4) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Sta=
tus: 1
> > TCP
> > > > status: 1 Instance: 1
> > > >         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Sessio=
nId:
> > > > 0x10006c000055
> > > >         Shares:
> > > >         0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> > > >         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
> > > >         Share Capabilities: None        Share Flags: 0x30
> > > >         tid: 0x1        Maximal Access: 0x11f01ff
> > > >
> > > >         1) \\file1\ZZZ Mounts: 1 DevInfo: 0x20020 Attributes: 0x850=
0df
> > > >         PathComponentMax: 255 Status: 1 type: DISK Serial Number:
> > 0xa3c339a0
> > > >         Share Capabilities: None Aligned, Partition Aligned,    Sha=
re Flags: 0x0
> > > >         tid: 0x5        Optimal sector size: 0x200      Maximal Acc=
ess: 0x1f01ff
> > > >
> > > >         MIDs:
> > > >
> > > >         Server interfaces: 2
> > > >         0)      Speed: 10000000000 bps
> > > >                 Capabilities:
> > > >                 IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
> > > >         1)      Speed: 10000000000 bps
> > > >                 Capabilities:
> > > >                 IPv4: 192.168.1.175
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
