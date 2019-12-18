Return-Path: <SRS0=WFxL=2I=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8148C43603
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Dec 2019 08:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A8B424685
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Dec 2019 08:12:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B3HvZYK7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfLRIMo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Dec 2019 03:12:44 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:40900 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfLRIMo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Dec 2019 03:12:44 -0500
Received: by mail-il1-f193.google.com with SMTP id c4so935327ilo.7
        for <linux-cifs@vger.kernel.org>; Wed, 18 Dec 2019 00:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MMDEaTvb7pCsurn7Es1VTPCsAEwb+FKsYjJjtrwcop8=;
        b=B3HvZYK7XdAeGhKM72eWdIbq50QJmYLt08FyOCacK2Yw8F3/zsfSC+fUR86IKgCOr7
         LKkwynUcK//budH+7n8kFAC2C4HEP8+VpN0lbUf6uOYAmlsKQiUp0tj5COMss/wjVPzb
         UvNXQeZxDvmBIkH6Fa8Le5+YA93V+C5tukP+PeB5AJW9bdFZT581wjqYrVDqR4ZiN5sj
         KYWX0FjQhqi2+C6UY80Q1G8TZMHTIRbjRyDgECTpjVnRG2N/j2mUtCqMXiZ+ft+HKoJE
         7Y6XPDZ0mVZGoHb2f896OQZgPtuhL3qB36Lv1t4NReBcrYG/NqWsityoxb/4xUeEKHuk
         w0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MMDEaTvb7pCsurn7Es1VTPCsAEwb+FKsYjJjtrwcop8=;
        b=uJg/I5pYDFlE6CdmaKPZU7du4KSXyZ+C8pirVk8Otap8FOxeOmVbrSh62tr/zLEZgW
         EdFTXpa83U+oUfiSMgO00cm2QY7E/xwH/C6u9kzC/i4HqLadNQKLKo6P+MFvSsE4QwZu
         vODwEIHMUBfRZLsSGWw2ERv6sK69NhVY9D2IxurUdtbPb69/pmA2UionrCsAp8Emd6r6
         aeaBLBU7S471C9wS3b+8y/PdU5j1BC4u5ZkGCQcFYqlzNj7NutHAmpl6we5RKYy7MG4X
         D+PC+Y22vhM5dgzGoKGnESBd4CJsaNkUxcJF6OfxnKAZ/1Ru/tZteSGb/Dkam6GveQCS
         YoJA==
X-Gm-Message-State: APjAAAW4WJFDvQay6i+F5FUzwrZX4dir48+dd7d0hbnxROeY99H7Yp8d
        XT1Az5n+0I0nF8jaug9fJOnPtTGIR/2vRxd6oD7wuQ==
X-Google-Smtp-Source: APXvYqwUxsYrmR7W5bVvTrf/rWucstqjZntGQa8bA+gVq9CUsOonp6i/xcN/MrzK1U11OPiGO2NlC5B3td09pzYo/Gw=
X-Received: by 2002:a92:c990:: with SMTP id y16mr736960iln.109.1576656763348;
 Wed, 18 Dec 2019 00:12:43 -0800 (PST)
MIME-Version: 1.0
References: <1327532317.1529923.1576509501382.JavaMail.zimbra@redhat.com>
 <180194560.1531945.1576510209913.JavaMail.zimbra@redhat.com>
 <MN2PR21MB143962C9B65975E1DAD7A81BA0510@MN2PR21MB1439.namprd21.prod.outlook.com>
 <798763602.1820950.1576637331025.JavaMail.zimbra@redhat.com>
In-Reply-To: <798763602.1820950.1576637331025.JavaMail.zimbra@redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 18 Dec 2019 18:12:32 +1000
Message-ID: <CAN05THShz43rw51JP-1X7JFjbuPCLAH2jcv+8x=d65UtMT+2hQ@mail.gmail.com>
Subject: Re: How to use SMB Direct
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     Tom Talpey <ttalpey@microsoft.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I don't think samba supports SMB Direct.
Metze used to have a private repo with some experimental patches but I
don't think it
has landed in official samba yet.

For a linux server, there is an experimental kernel based server
called cifsd which should support SMBDirect
but is incomplete in other areas. It is not part of linus tree yet
(but soon I hope).

Windows servers support SMBDirect but I am not aware of any soft-rdma
support so you might be
limited to just using real hw for any tests.

Linux serverside SMBD support is not ready afaik.

On Wed, Dec 18, 2019 at 12:49 PM Xiaoli Feng <xifeng@redhat.com> wrote:
>
> Hello Tom,
>
> Then I try to use IP to mount, it show this error:
> [79912.177783] CIFS VFS: _smbd_get_connection:1740 rdma_connect failed po=
rt=3D5445
> [79912.220723] CIFS VFS: _smbd_get_connection:1740 rdma_connect failed po=
rt=3D445
>
> Client:
> $ mount //172.31.0.250/cifs cifs -o user=3Droot,password=3Dredhat,rdma
> mount error(2): No such file or directory
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
> Server:
> $ ib addr |grep 172.31.0.250/
> mlx4_ib0:               Link UP, Interface UP   172.31.0.250/24
>
> Samba version is 4.11.2. And firewalld is stopped.
>
> ----- Original Message -----
> > From: "Tom Talpey" <ttalpey@microsoft.com>
> > To: "Xiaoli Feng" <xifeng@redhat.com>, linux-cifs@vger.kernel.org
> > Sent: Tuesday, December 17, 2019 1:11:24 AM
> > Subject: RE: How to use SMB Direct
> >
> > > -----Original Message-----
> > > From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.=
org>
> > > On
> > > Behalf Of Xiaoli Feng
> > > Sent: Monday, December 16, 2019 10:30 AM
> > > To: linux-cifs@vger.kernel.org
> > > Subject: [EXTERNAL] How to use SMB Direct
> > >
> > > Hello guys,
> > >
> > > I'd like to test SMB Direct. But it's failed. I'm not sure if it work=
s in
> > > upstream.
> > > I setup samba server on one rdma machine with 5.5.0-rc1+ kernel. The
> > > smb.conf is:
> > > [cifs]
> > > path=3D/mnt/cifs
> > > writeable=3Dyes
> > >
> > > Then I try to mount the share on another rdma machine with 5.5.0-rc1+
> > > kernel.
> > >    mount //$RDMA/cifs cifs -o user=3Droot,password=3D$password,rdma
> > >
> > > It's failed because of "CIFS VFS: smbd_create_id:614 rdma_resolve_add=
r()
> > > completed -113"
> >
> > Errno 113 is "no route to host". Sounds like a network or address issue=
.
> >
> > Tom.
> >
> > > Does SMB Direct work fine in upstream?
> > >
> > > Thanks.
> > >
> > > $ cat /boot/config-5.5.0-rc1+ |grep SMB_DIRECT
> > > CONFIG_CIFS_SMB_DIRECT=3Dy
> > > $ ibstat
> > > CA 'mlx4_0'
> > >     CA type: MT4099
> > >     Number of ports: 2
> > >     Firmware version: 2.42.5000
> > >     Hardware version: 1
> > >     Node GUID: 0xf4521403007be0e0
> > >     System image GUID: 0xf4521403007be0e3
> > >     Port 1:
> > >             State: Active
> > >             Physical state: LinkUp
> > >             Rate: 56
> > >             Base lid: 29
> > >             LMC: 0
> > >             SM lid: 1
> > >             Capability mask: 0x0259486a
> > >             Port GUID: 0xf4521403007be0e1
> > >             Link layer: InfiniBand
> > >     Port 2:
> > >             State: Active
> > >             Physical state: LinkUp
> > >             Rate: 40
> > >             Base lid: 44
> > >             LMC: 1
> > >             SM lid: 36
> > >             Capability mask: 0x02594868
> > >             Port GUID: 0xf4521403007be0e2
> > >             Link layer: InfiniBand
> > >
> > >
> > > --
> > > Best regards!
> > > XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
> > >
> > > Red Hat Software (Beijing) Co.,Ltd
> > > filesystem-qe Team
> > > IRC:xifeng=EF=BC=8C#channel: fs-qe
> > > Tel:+86-10-8388112
> > > 9/F, Raycom
> >
> >
>
