Return-Path: <SRS0=2HAQ=6Q=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D095C3A5A9
	for <linux-cifs@archiver.kernel.org>; Sat,  2 May 2020 06:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C9972184D
	for <linux-cifs@archiver.kernel.org>; Sat,  2 May 2020 06:10:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d9oqWIEV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgEBGKb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 May 2020 02:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726468AbgEBGKb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 May 2020 02:10:31 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE877C061A0C
        for <linux-cifs@vger.kernel.org>; Fri,  1 May 2020 23:10:30 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id w7so6115567ybq.0
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2020 23:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fyfPHSIEr9YFDChoVSagzla6aK/E42BsAAoAYT1YCk4=;
        b=d9oqWIEVDXYJTpwHyph4aZ9FqsaWbZm+qumirhS9LhKvKc7XDMXCh2KxW8WECcifre
         r4pv/Gj6LfKXZHfY43T3yMmBE2/uERLtVtITYgQ5L+n2Jf/LSmJDc6NqJVj1h4Vql+1F
         513VA9LuEUUzJG5aqb8eKY44mF5cCB+XRbsHSSCFCt+RHOvUEh8xyk0YqkVWMntisukD
         iPrM70SMgrRUQX7zH7d9KTzsvbs/x377whVPBObRex/UUfv4WP46ingRuLuxNiYDMjOv
         uQrEqY98dQm5NztdZPxVN8cNZuckylA1r5dNQbzGbOT58x6Gm/nQfOslf1lWQyBgIJU4
         jbaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fyfPHSIEr9YFDChoVSagzla6aK/E42BsAAoAYT1YCk4=;
        b=rAFj/jmILT/K7U7z4QLBA/Ou7aMVRfSlH8E5JUPJCtFHAx6/e4VG2j42IN9P6pIxBW
         W3yPAb0tOS9BNmkJrWzuPMxn74FU0PlKq8NaD8riIEvTHy35BujK+GSI53/mhyNUJHoc
         qWU6LOJU3HzB7TyR6rHS2lv1AFegRXBK1+yKdUj/+6T6DzrzXVrjbNUs2oTcMCUISQhE
         h7JSiFuzKRODm5hyTsWxKrbCqvFhTUMqr/WBUadaXDQrI+WdEQoGSwHr9sWMR7GTRVHM
         7o0y530VHmToog3sgz5f3iSTFX5oTf/YY2OLb/mRbcFSRPGqFz3gesVUBuYXCgTvbLJq
         AYIA==
X-Gm-Message-State: AGi0PuaiAL7Zs+NcSE3SU9AadYJMpowKAe65TCwfmrBcATcu6m742gP5
        IpoXuUCbP6fGzOHd/IXrU8WomIQbeRTodFBnU08=
X-Google-Smtp-Source: APiQypLuTo/ODHazyFmei21V/OgsSLeE/Qlk11F0diVoXDc0cCvQKmAXDXv4ODeq7u+1nXOkGwLHrTHQ9VMnfAG11YE=
X-Received: by 2002:a25:42ce:: with SMTP id p197mr11533713yba.167.1588399829756;
 Fri, 01 May 2020 23:10:29 -0700 (PDT)
MIME-Version: 1.0
References: <52e802d7dde642c29662e9e05019c323@wynstonegroup.com>
 <CAH2r5msOBGS7QYagUkby4upxFKbxCdQg=T65K4s9VhRKkWY+Xw@mail.gmail.com> <5924ec7684ff4dd1ab853b1574cb140e@wynstonegroup.com>
In-Reply-To: <5924ec7684ff4dd1ab853b1574cb140e@wynstonegroup.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 2 May 2020 01:10:18 -0500
Message-ID: <CAH2r5mu_6bYahrywC=vHKSKXv7Vg3spNyBWOPrgH-uuR6m_4pg@mail.gmail.com>
Subject: Re: issues with CIFS on Ubuntu 20 mounting Windows 2019
To:     "Scott M. Lewandowski" <vgerkernel@scottl.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I don't know much about mono but wonder if signal handling problems
(in mono) could be related "EINTR" is suspicious on read ...

Don't know if this is related but google search turned up this:

"Mono uses signals on certain platforms to handle
NullReferenceExceptions. It=E2=80=99s also becoming more and more common to
add third-party libraries that detect and report crashes. The problem
is when those third-party libraries install their own signal handlers,
overwriting Mono=E2=80=99s signal handlers. When this happens, any
NullReferenceException would be detected by such libraries as a fatal
SIGSEGV, and the libraries would report it as a crash and terminate
the process."

On Fri, May 1, 2020 at 12:19 AM Scott M. Lewandowski
<vgerkernel@scottl.com> wrote:
>
> > EINTR on read ... Hundreds of times?! I have seen scp do that by sendin=
g signals but in writes not reads
>
> Not using scp at the moment.
>
> > Could an app be sending signals trying to kill the process doing the re=
ads?
>
> Not that I'm aware of. I'm not sure exactly how I'd check that, but I wil=
l look into it.
>
> One other thing that came to mind that may be helpful is that one of the =
processes doing the most IO is running under mono 6.8.0.105
>
> -scott
>
>
>
>
> From: Steve French <smfrench@gmail.com>
> Sent: Friday, May 1, 2020 12:07 AM
> To: Scott M. Lewandowski <vgerkernel@scottl.com>
> Cc: CIFS <linux-cifs@vger.kernel.org>
> Subject: Re: issues with CIFS on Ubuntu 20 mounting Windows 2019
>
> EINTR on read ... Hundreds of times?! I have seen scp do that by sending =
signals but in writes not reads
>
> On Thu, Apr 30, 2020, 23:48 Scott M. Lewandowski <mailto:vgerkernel@scott=
l.com> wrote:
> I have an Ubuntu 20.04 box mounting shares from a Windows 2019 server. Bo=
th boxes are fully patched. They are resident on the same hypervisor and co=
mmunicating directly via a vSwitch. I have 4 shares mounted; here is an exa=
mple from my fstab (yes, I know I should move the credential file):
>
> //file1/usenet /mnt/usenet cifs vers=3D3.0,uid=3Dscott,credentials=3D/hom=
e/scott/.smbcredentials,noserverino,nounix,iocharset=3Dutf8 0 0
>
> My kernel is 5.4.0-28-generic and mount.cifs version is 6.9. The contents=
 of DebugData are included below.
>
> Right after the mount, I see a duplicate cookie reported. It is unclear i=
f this is a problem or not. Following that, I periodically see messages sim=
ilar to the following repeated in dmesg:
>
> [  179.625296] SMB2_read: 9 callbacks suppressed
> [  179.625298] CIFS VFS: Send error in read =3D -4
> [  179.704191] CIFS VFS: Send error in read =3D -4
> [  179.847514] CIFS VFS: Send error in read =3D -4
> [  180.031516] CIFS VFS: Send error in read =3D -4
> [  180.214848] CIFS VFS: Send error in read =3D -4
> [  180.282909] CIFS VFS: Send error in read =3D -4
> [  180.474829] CIFS VFS: Send error in read =3D -4
> [  180.621349] CIFS VFS: Send error in read =3D -4
> [  180.780465] CIFS VFS: Send error in read =3D -4
> [  180.823249] CIFS VFS: Send error in read =3D -4
> [  182.339351] CIFS VFS: Close unmatched open
> [  182.726829] CIFS VFS: Close unmatched open
> [  184.292663] CIFS VFS: Close unmatched open
> [  184.501185] CIFS VFS: Close unmatched open
> [  191.784922] SMB2_read: 4 callbacks suppressed
> [  191.784925] CIFS VFS: Send error in read =3D -4
> [  191.884186] CIFS VFS: Send error in read =3D -4
> [  192.270851] CIFS VFS: Send error in read =3D -4
> [  192.323467] CIFS VFS: Send error in read =3D -4
> [  192.381336] CIFS VFS: Send error in read =3D -4
> [  192.446711] CIFS VFS: Send error in read =3D -4
> [  192.507605] CIFS VFS: Send error in read =3D -4
> [  193.244397] CIFS VFS: Send error in read =3D -4
> [  193.307588] CIFS VFS: Send error in read =3D -4
> [  193.403410] CIFS VFS: Send error in read =3D -4
> [  193.797038] CIFS VFS: Close unmatched open
> [  196.784082] CIFS VFS: Close unmatched open
> [  198.247594] CIFS VFS: Close unmatched open
>
> Here is the duplicate cookie info:
>
> [   21.713307] FS-Cache: Duplicate cookie detected
> [   21.713840] FS-Cache: O-cookie c=3D00000000e8276279 [p=3D0000000079ef0=
365 fl=3D222 nc=3D0 na=3D1]
> [   21.714330] FS-Cache: O-cookie d=3D00000000173ea0ee n=3D00000000243f21=
0c
> [   21.714779] FS-Cache: O-key=3D[8] '020001bdc0a801af'
> [   21.715219] FS-Cache: N-cookie c=3D00000000afb49d9c [p=3D0000000079ef0=
365 fl=3D2 nc=3D0 na=3D1]
> [   21.715672] FS-Cache: N-cookie d=3D00000000173ea0ee n=3D00000000dd1465=
c5
> [   21.716141] FS-Cache: N-key=3D[8] '020001bdc0a801af'
> [   21.716591] FS-Cache: Duplicate cookie detected
> [   21.717217] FS-Cache: O-cookie c=3D00000000e8276279 [p=3D0000000079ef0=
365 fl=3D222 nc=3D0 na=3D1]
> [   21.717679] FS-Cache: O-cookie d=3D00000000173ea0ee n=3D00000000243f21=
0c
> [   21.718220] FS-Cache: O-key=3D[8] '020001bdc0a801af'
> [   21.718681] FS-Cache: N-cookie c=3D0000000063665cf7 [p=3D0000000079ef0=
365 fl=3D2 nc=3D0 na=3D1]
> [   21.719166] FS-Cache: N-cookie d=3D00000000173ea0ee n=3D00000000e757f9=
17
> [   21.719621] FS-Cache: N-key=3D[8] '020001bdc0a801af'
> [   21.720097] FS-Cache: Duplicate cookie detected
> [   21.720565] FS-Cache: O-cookie c=3D00000000e8276279 [p=3D0000000079ef0=
365 fl=3D222 nc=3D0 na=3D1]
> [   21.721053] FS-Cache: O-cookie d=3D00000000173ea0ee n=3D00000000243f21=
0c
> [   21.721518] FS-Cache: O-key=3D[8] '020001bdc0a801af'
> [   21.721994] FS-Cache: N-cookie c=3D00000000d479c294 [p=3D0000000079ef0=
365 fl=3D2 nc=3D0 na=3D1]
> [   21.722476] FS-Cache: N-cookie d=3D00000000173ea0ee n=3D00000000ca1891=
fa
> [   21.722941] FS-Cache: N-key=3D[8] '020001bdc0a801af'
>
> Any ideas what could be going on?
>
> Thanks for any help!
>
>
>
>
>
>
> DebugData:
> CIFS Version 2.23
> Features: DFS,FSCACHE,STATS,DEBUG,ALLOW_INSECURE_LEGACY,WEAK_PW_HASH,CIFS=
_POSIX,UPCALL(SPNEGO),XATTR,ACL
> CIFSMaxBufSize: 16384
> Active VFS Requests: 0
> Servers:
> Number of credits: 8190 Dialect 0x300
> 1) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Status: 1=
 TCP status: 1 Instance: 1
>         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 SessionId: 0=
x100080000021
>         Shares:
>         0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
>         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
>         Share Capabilities: None        Share Flags: 0x30
>         tid: 0x1        Maximal Access: 0x11f01ff
>
>         1) \\file1\XXX Mounts: 1 DevInfo: 0x20020 Attributes: 0x8500df
>         PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xa3c33=
9a0
>         Share Capabilities: None Aligned, Partition Aligned,    Share Fla=
gs: 0x0
>         tid: 0x5        Optimal sector size: 0x200      Maximal Access: 0=
x1f01ff
>
>         MIDs:
>
>         Server interfaces: 2
>         0)      Speed: 10000000000 bps
>                 Capabilities:
>                 IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
>         1)      Speed: 10000000000 bps
>                 Capabilities:
>                 IPv4: 192.168.1.175
> Number of credits: 8190 Dialect 0x300
>
> 2) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Status: 1=
 TCP status: 1 Instance: 1
>         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 SessionId: 0=
x10006c000019
>         Shares:
>         0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
>         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
>         Share Capabilities: None        Share Flags: 0x30
>         tid: 0x1        Maximal Access: 0x11f01ff
>
>         1) \\file1\usenet Mounts: 1 DevInfo: 0x20020 Attributes: 0x8500df
>         PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xa3c33=
9a0
>         Share Capabilities: None Aligned, Partition Aligned,    Share Fla=
gs: 0x0
>         tid: 0x5        Optimal sector size: 0x200      Maximal Access: 0=
x1f01ff
>
>         MIDs:
>
>         Server interfaces: 2
>         0)      Speed: 10000000000 bps
>                 Capabilities:
>                 IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
>         1)      Speed: 10000000000 bps
>                 Capabilities:
>                 IPv4: 192.168.1.175
>
>
> 3) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Status: 1=
 TCP status: 1 Instance: 1
>         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 2 SessionId: 0=
x10007c000061
>         Shares:
>         0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
>         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
>         Share Capabilities: None        Share Flags: 0x30
>         tid: 0x1        Maximal Access: 0x11f01ff
>
>         1) \\file1\YYY Mounts: 1 DevInfo: 0x20020 Attributes: 0x8500df
>         PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xa3c33=
9a0
>         Share Capabilities: None Aligned, Partition Aligned,    Share Fla=
gs: 0x0
>         tid: 0x5        Optimal sector size: 0x200      Maximal Access: 0=
x1f01ff
>
>         MIDs:
>         State: 2 com: 8 pid: 1218 cbdata: 00000000e45c59d2 mid 1211489
>         State: 2 com: 8 pid: 1218 cbdata: 0000000018476195 mid 1211553
>
>         Server interfaces: 2
>         0)      Speed: 10000000000 bps
>                 Capabilities:
>                 IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
>         1)      Speed: 10000000000 bps
>                 Capabilities:
>                 IPv4: 192.168.1.175
>
> Number of credits: 8190 Dialect 0x300
> 4) Name: 192.168.1.175 Uses: 1 Capability: 0x300067     Session Status: 1=
 TCP status: 1 Instance: 1
>         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 SessionId: 0=
x10006c000055
>         Shares:
>         0) IPC: \\file1\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
>         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
>         Share Capabilities: None        Share Flags: 0x30
>         tid: 0x1        Maximal Access: 0x11f01ff
>
>         1) \\file1\ZZZ Mounts: 1 DevInfo: 0x20020 Attributes: 0x8500df
>         PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0xa3c33=
9a0
>         Share Capabilities: None Aligned, Partition Aligned,    Share Fla=
gs: 0x0
>         tid: 0x5        Optimal sector size: 0x200      Maximal Access: 0=
x1f01ff
>
>         MIDs:
>
>         Server interfaces: 2
>         0)      Speed: 10000000000 bps
>                 Capabilities:
>                 IPv6: fe80:0000:0000:0000:71cb:1839:1069:9806
>         1)      Speed: 10000000000 bps
>                 Capabilities:
>                 IPv4: 192.168.1.175



--=20
Thanks,

Steve
