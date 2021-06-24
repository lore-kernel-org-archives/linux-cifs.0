Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,WEIRD_PORT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E13C49EA5
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 18:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46FE96135C
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Jun 2021 18:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhFXSXa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 24 Jun 2021 14:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbhFXSXa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 24 Jun 2021 14:23:30 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5534C061574
        for <linux-cifs@vger.kernel.org>; Thu, 24 Jun 2021 11:21:09 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id hc16so10823361ejc.12
        for <linux-cifs@vger.kernel.org>; Thu, 24 Jun 2021 11:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kR2bEq25iayABNzer0UnuSwP8khPR3/Fg6DdPD7/2MM=;
        b=ebh6OLEody+YFSnBnP5jtDxXDQ+W8VNZoHupkDg83L0siqYH1fWGThZ1tTO9Lo/S1j
         UOmkirHTzVTCakZiYdcKoHVEUcq2+OhBi824/drHL/K53qvAutvdAq1D+nJ71Zh4uOaS
         Kc7awNrp2MpWaA3SxDafbulnLboggY4yYfDP2WfVROYolCCmVebn6297ZZwnPsq3sg4m
         PosIAvJEXjtk3QLP4+tSTbrT3CzFLl1vzoIjsJuD/3XuLPlhxcDdq86P+i/osan5OeXI
         zZgUV7XJ1CW2o9TmX/wfZWGt5IybaOMIGr7en+INwMhpSsBnZ4pGKtllVtDv5DRM39Yf
         t8mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kR2bEq25iayABNzer0UnuSwP8khPR3/Fg6DdPD7/2MM=;
        b=V3WV+mN4UAROpRei8FdBOFGA+RSsvi7Cw/St/NqtjRRqNd60JEEz0V0stNQK8eoPWI
         ea5uMjUTKYIEwUqIkwQKj8GD2MRaIRJYGtuI6XqqK4/XDsaeUxeB3nOv9xE3FmhXIemH
         mlXcRnoP7plIYBLur4N4h/kfakyHry5zdqbuiLA3lsYVb1wXZWYl2O62syAXS1pe1zab
         Ukvui0tBmHNDi9w1otxqxEX41Zcj0wEi/b668tU7LZtR7iPrqRALcbskiMRYA4qV5Jvl
         U/Ws/vyXqO3i6M2rB915TP6LxTtKXq3+9Ch5otwtEYAwQHrUaObnZZKWumA0YP983f3x
         u7Ww==
X-Gm-Message-State: AOAM532fkpOLHVqtrm8Jn+i7bjFGnKhQeT8dwvf3w8IUTurUdu/meEUf
        c9ev98KpONdwxmsL3ivaPLMM+UMtnn+HR4il4A==
X-Google-Smtp-Source: ABdhPJx91W31h+sYb7wfb/54Xkg4bl26KrSb84NvWak1L0QmJ4VTAef78iFBvPVJPo26gIVFu5LGtYoNz8WddnLCS98=
X-Received: by 2002:a17:907:7b82:: with SMTP id ne2mr6441571ejc.271.1624558868110;
 Thu, 24 Jun 2021 11:21:08 -0700 (PDT)
MIME-Version: 1.0
References: <80F3362B-C817-4C16-A890-78ED3C6E0347@gnarbox.com>
In-Reply-To: <80F3362B-C817-4C16-A890-78ED3C6E0347@gnarbox.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 24 Jun 2021 11:20:57 -0700
Message-ID: <CAKywueQ29aD9vc0nQFdBW6sEWtyzJo5Se8g5YDGSnHFVWfEnYA@mail.gmail.com>
Subject: Re: SMB Partial Send Causes CIFS VFS Reconnection and File Copy Failure
To:     David Manpearl <david@gnarbox.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi David,

Some issues with partial sends were fixed in the 5.1 kernel. I don't
think the patches were backported to 4.9.

In particular the following patches are needed:

https://www.spinics.net/lists/linux-cifs/msg16569.html
https://www.spinics.net/lists/linux-cifs/msg20496.html

The errors may occur if an application accessing a share uses signals
that may be triggered during system calls. Such errors should be
handled by retrying in the userspace if getting -EINTR.

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 22 =D0=B8=D1=8E=D0=BD. 2021 =D0=B3. =D0=B2 20:42, David Manpe=
arl <david@gnarbox.com>:

>
> During file copy operations from our local file system to a Synology Samb=
a server file system from within our app, we are seeing numerous partial da=
ta sends which appear to cause CIFS reconnections, which in turn cause the =
copies to fail.
> We see these errors logged by our Golang application on the following ope=
rations:
> os.Create
> - tbd|ERROR [tbd/daemon] (tbd_copy_file.go:333#openWriters) Failed create=
 file [open /media/smb_192_168_86_40_GBXShare/SHAREBOX/100MEDIA/DJI_0114.JP=
G: no such file or directory]
> write
> - tbd|ERROR [tbd/daemon] (tbd_copy_file.go:440#finishFile) writer [write =
/media/smb_192_168_86_40_GBXShare/SHAREBOX2/100MEDIA_01/DJI_0002.JPG: bad f=
ile descriptor]
> - tbd|ERROR [tbd/daemon] (tbd_copy_file.go:294#openWriters) Failed create=
 file [open /media/smb_192_168_86_40_GBXShare/SHAREBOX2/100MEDIA_01/DJI_007=
3.JPG: resource temporarily unavailable]
> - tbd|ERROR [tbd/daemon] (tbd_copy_file.go:393#finishFile) writer [write =
/media/smb_192_168_86_40_GBXShare/SHAREBOX2/100MEDIA_01/DJI_0072.JPG: broke=
n pipe]
> file.Sync
> - tbd|ERROR [tbd/daemon] (tbd_copy_file.go:395#finishFile) sync [sync /me=
dia/smb_192_168_86_40_GBXShare/SMBSHARE/100MEDIA_02/DJI_0014(1).JPG: input/=
output error]
> file.Close
> - tbd|WARN  [tbd/daemon] (tbd_copy_file.go:435#finishFile) close [close /=
media/smb_192_168_86_40_GBXShare/SHAREBOX2/100MEDIA_02/DJI_0097.JPG: input/=
output error]
>
> Partial send log example:
> [196361.832049] /usr/src/kernel/fs/cifs/transport.c: partial send (wanted=
=3D65652 sent=3D116): terminating session
>
> Usually followed by:
> [196361.868197] CIFS VFS: Free previous auth_key.response =3D ffff8801174=
8b000
>
> - What are the scenarios in which a partial send will occur, because this=
 does not appear to be a network issue on our side?
>
> - If this is expected behavior, how are we supposed to be handling the pa=
rtial sends in userspace?
>
> - Are there other errors you see in the attached logs?
>
> Linux Kernel version: 4.9.115-yocto-standard
> We are using the "fs/cifs/" directory from the "linux-4.9-full-backports"=
 branch from this repo: https://github.com/smfrench/smb3-cifs-linux-stable-=
backports
>
> Mount.cifs version: 6.7
> Samba version:
> http://192.168.86.40:5000
> Control Panel > File Services > Max SMB3, Min SMB2.
> Appliance: Synology:
> Model name: DS1618
> CPU: INTEL Atom C3538
>
> DebugData:
> # cat /proc/fs/cifs/DebugData
> Display Internal CIFS Data Structures for Debugging
> ---------------------------------------------------
> CIFS Version 2.11
> Features: posix xattr
> Active VFS Requests: 0
> Servers:
> Number of credits: 512 Dialect 0x202
> 1) Name: 192.168.86.40 Uses: 1 Capability: 0x300001 Session Status: 1 TCP=
 status: 1
> Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
> Shares:
> 0) IPC: \\192.168.86.40\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> PathComponentMax: 0 Status: 1 type: 0
> 1) \\192.168.86.40\GBXShare Mounts: 4 DevInfo: 0x20 Attributes: 0x5006f
> PathComponentMax: 255 Status: 1 type: DISK
> MIDs:
> Number of credits: 528 Dialect 0x302
> 2) Name: 192.168.86.40 Uses: 1 Capability: 0x300005 Session Status: 1 TCP=
 status: 1
> Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
> Shares:
> 0) IPC: \\192.168.86.40\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
> PathComponentMax: 0 Status: 1 type: 0
> Share Capabilities: None Share Flags: 0x0
>
> 1) \\192.168.86.40\GBXShare Mounts: 1 DevInfo: 0x20 Attributes: 0x5006f
> PathComponentMax: 255 Status: 1 type: DISK
> Share Capabilities: None Aligned, Partition Aligned, Share Flags: 0x0 Opt=
imal sector size: 0x200
> MIDs:
>
> Logs: dmesgCIFS-h.log: https://drive.google.com/file/d/1_fWpvSs5zeOFaV-Yl=
GfW2ej3LGwFZSns/view?usp=3Dsharing
>
> - Thank you, David
>
>
