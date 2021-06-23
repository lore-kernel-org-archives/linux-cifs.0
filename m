Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS,WEIRD_PORT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0B1C4743C
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 03:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E475611CE
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 03:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhFWDo0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 23:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFWDoZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 23:44:25 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72499C061574
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 20:42:08 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id g192so1230921pfb.6
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 20:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gnarbox-com.20150623.gappssmtp.com; s=20150623;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=2BOX2dWoIQlp+L2PPEQ1erffxeSBg8FnzNbmkRlEgnw=;
        b=CxFzmnwRTCl8E6Wv6iMm4ZH+eUfoi4B0wgTr1fG8wkL9wQ2u5FKoVFgsx8JqgCPy7Q
         /T7EQvii5soXSUoug758tBewz9Hgc+YS57ef8uh1wHu3Oh+5NPtwj+OkI2aOimMTbguO
         4ZHf6sVNWkmcUoiBFwfdufbQ4vbgg2XWeoDJN1vQzJKeE3kwAyIAKrtK4nc5Nn4dx2v4
         ymt04xC+MpLMjzVtxIrYyLXv1pVYEIgGPAKjj7aXrna5l1kgDaOsgXQvLxivottS8RAd
         2upAkYi3CDA9enfbammnWfvE4yNzCgZ0z542fZDQgWO/XGrkrgedqe+SdxNfBBUwYcCu
         SWmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=2BOX2dWoIQlp+L2PPEQ1erffxeSBg8FnzNbmkRlEgnw=;
        b=erOZRPo6JpO9Wsx+9JHliPkbpRXzg4UopWKNHXqePrzrXuNjfheotS+mpEIfV6x0l+
         MFflC21Yqa+IZ0cGmOzmbAGdI7SyuD9UgACobz+No4SW6Bnj6EsQlROpz1Etof9dqf3A
         m6VExkzgtbFNJBwTpPNoH6/ZRSjwmgt4bSrUnL+Dcdn8+3jYqpLkLGR8We4IjV49koyk
         L8jTk44mkgZbMHP7bpAYZ/5bqlx3wgK7GVUeAywsfJkcMl9erjU83fhaKPVAyx2ZBWHH
         viBFPr92ZCC9f3IyMPDuoDuf0k9xW6QHmWKlSjALBQXgl1HtBGjGpIIJsYYRV7QfOQFE
         kNKw==
X-Gm-Message-State: AOAM532L0nARzuYQCHmYdwcRa+QmjwBDxSKcWxt63ztUDmOo6BgewMOr
        Mipfk1o3EJdPWrvHr6ldATTuPZhHiPnzOw==
X-Google-Smtp-Source: ABdhPJxezPeiEJA8GD/62dqPWTURLoVgADRlO5xMjfJYvUmy6U/6OflHSk6oiM7I5SmKrYVmTqLJlQ==
X-Received: by 2002:a65:5288:: with SMTP id y8mr1826662pgp.31.1624419727423;
        Tue, 22 Jun 2021 20:42:07 -0700 (PDT)
Received: from smtpclient.apple ([47.151.138.208])
        by smtp.gmail.com with ESMTPSA id i2sm3451673pjj.25.2021.06.22.20.42.05
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jun 2021 20:42:05 -0700 (PDT)
From:   David Manpearl <david@gnarbox.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: SMB Partial Send Causes CIFS VFS Reconnection and File Copy Failure
Message-Id: <80F3362B-C817-4C16-A890-78ED3C6E0347@gnarbox.com>
Date:   Tue, 22 Jun 2021 20:42:04 -0700
To:     linux-cifs@vger.kernel.org
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

During file copy operations from our local file system to a Synology =
Samba server file system from within our app, we are seeing numerous =
partial data sends which appear to cause CIFS reconnections, which in =
turn cause the copies to fail.
We see these errors logged by our Golang application on the following =
operations:
os.Create
- tbd|ERROR [tbd/daemon] (tbd_copy_file.go:333#openWriters) Failed =
create file [open =
/media/smb_192_168_86_40_GBXShare/SHAREBOX/100MEDIA/DJI_0114.JPG: no =
such file or directory]
write
- tbd|ERROR [tbd/daemon] (tbd_copy_file.go:440#finishFile) writer [write =
/media/smb_192_168_86_40_GBXShare/SHAREBOX2/100MEDIA_01/DJI_0002.JPG: =
bad file descriptor]
- tbd|ERROR [tbd/daemon] (tbd_copy_file.go:294#openWriters) Failed =
create file [open =
/media/smb_192_168_86_40_GBXShare/SHAREBOX2/100MEDIA_01/DJI_0073.JPG: =
resource temporarily unavailable]
- tbd|ERROR [tbd/daemon] (tbd_copy_file.go:393#finishFile) writer [write =
/media/smb_192_168_86_40_GBXShare/SHAREBOX2/100MEDIA_01/DJI_0072.JPG: =
broken pipe]
file.Sync
- tbd|ERROR [tbd/daemon] (tbd_copy_file.go:395#finishFile) sync [sync =
/media/smb_192_168_86_40_GBXShare/SMBSHARE/100MEDIA_02/DJI_0014(1).JPG: =
input/output error]
file.Close
- tbd|WARN  [tbd/daemon] (tbd_copy_file.go:435#finishFile) close [close =
/media/smb_192_168_86_40_GBXShare/SHAREBOX2/100MEDIA_02/DJI_0097.JPG: =
input/output error]

Partial send log example:
[196361.832049] /usr/src/kernel/fs/cifs/transport.c: partial send =
(wanted=3D65652 sent=3D116): terminating session

Usually followed by:
[196361.868197] CIFS VFS: Free previous auth_key.response =3D =
ffff88011748b000

- What are the scenarios in which a partial send will occur, because =
this does not appear to be a network issue on our side?

- If this is expected behavior, how are we supposed to be handling the =
partial sends in userspace?

- Are there other errors you see in the attached logs?

Linux Kernel version: 4.9.115-yocto-standard
We are using the "fs/cifs/" directory from the =
"linux-4.9-full-backports" branch from this repo: =
https://github.com/smfrench/smb3-cifs-linux-stable-backports

Mount.cifs version: 6.7
Samba version:
http://192.168.86.40:5000
Control Panel > File Services > Max SMB3, Min SMB2.
Appliance: Synology:
Model name: DS1618
CPU: INTEL Atom C3538

DebugData:
# cat /proc/fs/cifs/DebugData
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 2.11
Features: posix xattr
Active VFS Requests: 0
Servers:
Number of credits: 512 Dialect 0x202
1) Name: 192.168.86.40 Uses: 1 Capability: 0x300001 Session Status: 1 =
TCP status: 1
Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
Shares:
0) IPC: \\192.168.86.40\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
PathComponentMax: 0 Status: 1 type: 0
1) \\192.168.86.40\GBXShare Mounts: 4 DevInfo: 0x20 Attributes: 0x5006f
PathComponentMax: 255 Status: 1 type: DISK
MIDs:
Number of credits: 528 Dialect 0x302
2) Name: 192.168.86.40 Uses: 1 Capability: 0x300005 Session Status: 1 =
TCP status: 1
Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0
Shares:
0) IPC: \\192.168.86.40\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
PathComponentMax: 0 Status: 1 type: 0
Share Capabilities: None Share Flags: 0x0

1) \\192.168.86.40\GBXShare Mounts: 1 DevInfo: 0x20 Attributes: 0x5006f
PathComponentMax: 255 Status: 1 type: DISK
Share Capabilities: None Aligned, Partition Aligned, Share Flags: 0x0 =
Optimal sector size: 0x200
MIDs:

Logs: dmesgCIFS-h.log: =
https://drive.google.com/file/d/1_fWpvSs5zeOFaV-YlGfW2ej3LGwFZSns/view?usp=
=3Dsharing

- Thank you, David


