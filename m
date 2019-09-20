Return-Path: <SRS0=I8uG=XP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48825C3A5A2
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 23:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DACC2080F
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 23:27:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G2W7/n8o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394035AbfITX1C (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Sep 2019 19:27:02 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46193 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389793AbfITX1C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Sep 2019 19:27:02 -0400
Received: by mail-lf1-f68.google.com with SMTP id t8so6105093lfc.13
        for <linux-cifs@vger.kernel.org>; Fri, 20 Sep 2019 16:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pLwvnyn2LCu9IJkgE1qKF9FKFZHel0nn1vUQwlzkRYQ=;
        b=G2W7/n8oxV0jH/amVV5v79QdI2I9dtc5XjG4ctCip3ztlJPafkH8lKPUIXSdX4l06U
         e6ItO2eZEhLxm7zYyIx/SdNMCstZprOPqthA+4kY0dm0MaLkHXvR3nNSsCT+t5giq3lY
         QTi4iakN+wzvFVKnq5fdlkY/Zl9I+XOVl5vR7DTQY/BoUjo4y7x9lqD6stCeU0zaryXr
         DNIh4JfazuVkEYgDQCYbSfSuDX5tmVik6nAp9Z1MLbtBgtTnsm7OwHGfmuZksB9+YA+5
         rPeuDKpuRnL7lz/g/X3lx87HWdgECDawAeq4ZXOz8VFX8ZYUd88XQMMYbVFQmyHqTyl/
         xAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pLwvnyn2LCu9IJkgE1qKF9FKFZHel0nn1vUQwlzkRYQ=;
        b=gR1cUha4Dcr26pNjwqvUIzwKzJGqaRjgc7O2em5COHf8QbYWxo3BDEwc7C5hUlxMga
         EHhAeS+UFJAQqud3MhvM4kiQTpwpeADAbvdd4u9Pk5vyKAfSoOiQ9Lme2Euj8l7T1qj+
         oMC3daEG2TDZfYju8TpLodNhqqmcwcxWRYVod6I6tmZcj3/0J8+ALu0TdX6aREt4pb8G
         UWYk0SHRIDX3JKNBf8nIfTLWGXfkYqKzdYiGN63ss+/rTjeyMvuinFiVg3zSuPiV/eeK
         fjQWZAPf6/eodPAcYRKalJ/f0IvxytoepwshIUjIqnClFvfMqSzkED1d7m3o6en8baqj
         F8EA==
X-Gm-Message-State: APjAAAUEV8/COaQ38a04k7r5qN820wNjGf0jZ6VObOyujAgOctwlfYSP
        GDKaTSLLtAhb9O2VYZT4FqIFPPQNs5UcXQkW4A==
X-Google-Smtp-Source: APXvYqxCT7zvo1CdKD6/OouQvsGCgBdqFWjZdjsYaCiYM/hpmLqUGafbM8nOcXu9kVTlcCKvJtJ/0EJ7QBT8RN7L4VQ=
X-Received: by 2002:a19:f707:: with SMTP id z7mr10485645lfe.142.1569022020363;
 Fri, 20 Sep 2019 16:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
In-Reply-To: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 20 Sep 2019 16:26:49 -0700
Message-ID: <CAKywueT=hWCTM=Crsafrj-8P=1mD93DY73oK=Ub8JeWc5X85fQ@mail.gmail.com>
Subject: Re: Possible timeout problem when opening a file twice on a SMB mount
To:     Moritz M <mailinglist@moritzmueller.ee>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 20 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 12:11, Morit=
z M <mailinglist@moritzmueller.ee>:
>
> Hello,
>
> I've some trouble with saving files with a particular software, LyX[0]
> in this case.
> The problem is that saving a file on a SMB share makes the programm
> freeze for 30 s
> due to creating an empty temp file.
>
> While investigating I created a small python script which mimics
> (compared the strace output)
> the LyX behaviour and also freezes the python script for 30 s.
> That makes me believe that it could be a cifs problem.
>
> The python script is:
>
> #!/usr/bin/env python3
>
> import os, sys
>
> fd =3D os.open( "/mnt/share/foo.txt",
> os.O_RDWR|os.O_CREAT|os.O_EXCL|os.O_CLOEXEC, 0o600 )
> fd =3D os.access( "/mnt/share/foo.txt", os.F_OK )
> fd =3D os.chmod( "/mnt/share/foo.txt", 0o755 )
> fd =3D os.open( "/mnt/share/foo.txt", os.O_WRONLY|os.O_CREAT|os.O_TRUNC,
> 0o666 )
>
> # Close opened file
> os.close( fd )
>
>
> Stracing it with
>
> strace -f -t -T -e trace=3Dopenat,close,chmod,access python open.py
>
> gives
>
> 23:18:52 openat(AT_FDCWD, "/mnt/share/foo.txt",
> O_RDWR|O_CREAT|O_EXCL|O_CLOEXEC, 0600) =3D 3 <0.002434>
> 23:18:52 access("/mnt/share/foo.txt", F_OK) =3D 0 <0.000091>
> 23:18:52 chmod("/mnt/share/foo.txt", 0755) =3D 0 <0.000168>
> 23:18:52 openat(AT_FDCWD, "/mnt/share/foo.txt",
> O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) =3D 4 <30.033585>
>
> The second openat call takes 30 s and freezes the script.
>
> When doing a os.close( fd ) after first open in the python script it
> works as expected:
>
> 23:22:11 openat(AT_FDCWD, "/mnt/share/foo.txt",
> O_RDWR|O_CREAT|O_EXCL|O_CLOEXEC, 0600) =3D 3 <0.002464>
> 23:22:11 close(3)                       =3D 0 <0.001652>
> 23:22:11 access("/mnt/share/foo.txt", F_OK) =3D 0 <0.000082>
> 23:22:11 chmod("/mnt/share/foo.txt", 0755) =3D 0 <0.000175>
> 23:22:11 openat(AT_FDCWD, "/mnt/share/foo.txt",
> O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) =3D 3 <0.003221>
>
> My setup ist (server is a Synology Diskstation):
>
> $ uname -r
> 5.1.21-1-MANJARO
>
> $ mount.cifs -V
> mount.cifs version: 6.8
>
> $ samba --version
> Version 4.4.16
>
>
> Display Internal CIFS Data Structures for Debugging
> ---------------------------------------------------
> CIFS Version 2.19
> Features:
> DFS,FSCACHE,STATS,DEBUG,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),X=
ATTR,ACL
> CIFSMaxBufSize: 16384
> Active VFS Requests: 0
> Servers:
> Number of credits: 510 Dialect 0x311
> 1) Name: x.x.x.x Uses: 1 Capability: 0x300045   Session Status: 1 TCP
> status: 1 Instance: 1
>         Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 SessionId:
> 0x14e3311d
>         Shares:
>         0) IPC: \\server\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
>         PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
>         Share Capabilities: None        Share Flags: 0x0
>         tid: 0xf1884345 Maximal Access: 0x1f00a9
>
>         1) \\server\share Mounts: 1 DevInfo: 0x20 Attributes: 0x5006f
>         PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0x1dc3f=
115
>         Share Capabilities: None Aligned, Partition Aligned,    Share Fla=
gs: 0x800
>         tid: 0xe3ad48c8 Optimal sector size: 0x200      Maximal Access: 0=
x1f01ff
>
>         MIDs:
>
>
>
> Does anybody has a clue why it takes exactly 30 s when opening a file
> twice?
> Even more important: how can I prevent it?
> Any help is appreciated.
>
> Thanks
> Moritz
>
> [0]: https://www.lyx.org/


Hi Moritz,

Thanks for reporting the problem. From the 1st glance It looks like a
problem with SMB leases - probably a server sent a lease break and the
client didn't ack it in a timely manner.

Could you please enable debugging logging
(https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debugg=
ing),
reproduce the problem and send us the kernel logs? A network capture
of a repro could also be useful
(https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Wire_Captures).

--
Best regards,
Pavel Shilovsky
