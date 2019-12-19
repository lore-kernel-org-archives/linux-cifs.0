Return-Path: <SRS0=Aa8Y=2J=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA4CC2D0C0
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 06:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A74EC21582
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 06:47:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eAUZ0/D0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfLSGry (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Dec 2019 01:47:54 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51891 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfLSGry (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Dec 2019 01:47:54 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so4257680wmd.1
        for <linux-cifs@vger.kernel.org>; Wed, 18 Dec 2019 22:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=M1X3+zVyIVSQn4morrHactjcrABk0KHLtEj9eqc5Ses=;
        b=eAUZ0/D0RXwh7wj7iMEZJW0fzj5Azv+OwNLxMc1sbcopiTDtCZMohAYdq3x1TAdokZ
         rrDV0iJm97VSlZlNY9tQdEpg5ntcNX6o5TF4bQbDxhQ9InaT1ktaqHNaIJz5gsai1iMP
         0LMv8tIVGz659c+ig/d+VRG6Kjrpjjba/PgMJc8+b2SR6Im68yzGZaCd55LGcFVziPY+
         IET0rXDaNnFl3pdHC40gAyVLdLTx1uT8UUO52pTEy4LJWRnEXWUpGfU8bqQUcBnCVWDv
         mx2w+W34ejdOCBgAKDQ1VmZZfKr00k+8T6nLofbq+85/DWPv3x/6GW8wN8cKFXB1UMwa
         1QVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=M1X3+zVyIVSQn4morrHactjcrABk0KHLtEj9eqc5Ses=;
        b=tVtwN40pANZjN7gzDZGYz6vJEAToNmQYWvxTzaGeG1z8ugUjGAZrCDM/EeFM3aXaaD
         FQD4nSKkGzCmXc7uiDfzRtCkb9/S78xe1Fsp1ZzfI9S3c9BcBIVoJhsb83rwFXrw3AX5
         ERVDYgC8PzTHMtxolnV37W9vVsRVf484jB3xkZoFtIbnnqGsfCqzeG/2fPiQYpMIWEZg
         q6Q1GuX0sYgNjsQPYWwWk5jRwgIZ+zDM6K31wD9nxx5ujCnfH/ZAYEON2qiiUYX2eYhD
         x6TOWAVAdIY3pNL9rUFznsW0L95+dxhqJ79XCUKG+ZVTKuIXTXvISFjMNudFfMMPEg3/
         v89w==
X-Gm-Message-State: APjAAAVY+HZk2G6oj0C/R8qVjV6PKf18uNzq0pCQRPv6NbwJ5mjozAlv
        kRgwoPFTeBFctQmFGAUkx8KnAzDF73jPBb4KfPE=
X-Google-Smtp-Source: APXvYqwKfYwiaO0rojFO/T0BHzQcGZzeQyNI5MAFEAQ1joBVkz5a9iYiG/eJ0YcbVUw71zGdBD2aUUMxQkzKjXehbaU=
X-Received: by 2002:a1c:3187:: with SMTP id x129mr8092852wmx.91.1576738071740;
 Wed, 18 Dec 2019 22:47:51 -0800 (PST)
MIME-Version: 1.0
References: <1327532317.1529923.1576509501382.JavaMail.zimbra@redhat.com>
 <180194560.1531945.1576510209913.JavaMail.zimbra@redhat.com>
 <MN2PR21MB143962C9B65975E1DAD7A81BA0510@MN2PR21MB1439.namprd21.prod.outlook.com>
 <798763602.1820950.1576637331025.JavaMail.zimbra@redhat.com>
 <CAN05THShz43rw51JP-1X7JFjbuPCLAH2jcv+8x=d65UtMT+2hQ@mail.gmail.com> <2122939021.2041834.1576722876658.JavaMail.zimbra@redhat.com>
In-Reply-To: <2122939021.2041834.1576722876658.JavaMail.zimbra@redhat.com>
From:   Hyeoncheol Lee <hyc.lee@gmail.com>
Date:   Thu, 19 Dec 2019 15:47:40 +0900
Message-ID: <CANFS6bY6b23MznmrGuugcVUEW3UuRbzAxBd4p35K3qdkz4DCAA@mail.gmail.com>
Subject: Re: How to use SMB Direct
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Tom Talpey <ttalpey@microsoft.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        linux-cifsd-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Xiaoli,

cifsd is an in-kernel SMB server which supports SMB Direct.
If you want to test SMB Direct with cifs, you can use cifsd.

Currently we have tested SMB Direct between two old fashioned
Mellanox ConnectX devices which are connected directly,
and between two soft RoCE devices in kernel.

You can get cifsd's code from the following url, and
If you have any questions, we will help you.

https://github.com/cifsd-team/cifsd.git

Thank you.


2019=EB=85=84 12=EC=9B=94 19=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 11:35,=
 Xiaoli Feng <xifeng@redhat.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Thanks Ronnie for the information. Last question: Is it supported that mo=
unt the windows file
> server(has rdma hardware) with SMB Direct in linux client(has rdma hardwa=
re)?
>
> ----- Original Message -----
> > From: "ronnie sahlberg" <ronniesahlberg@gmail.com>
> > To: "Xiaoli Feng" <xifeng@redhat.com>
> > Cc: "Tom Talpey" <ttalpey@microsoft.com>, "linux-cifs" <linux-cifs@vger=
.kernel.org>
> > Sent: Wednesday, December 18, 2019 4:12:32 PM
> > Subject: Re: How to use SMB Direct
> >
> > I don't think samba supports SMB Direct.
> > Metze used to have a private repo with some experimental patches but I
> > don't think it
> > has landed in official samba yet.
> >
> > For a linux server, there is an experimental kernel based server
> > called cifsd which should support SMBDirect
> > but is incomplete in other areas. It is not part of linus tree yet
> > (but soon I hope).
> >
> > Windows servers support SMBDirect but I am not aware of any soft-rdma
> > support so you might be
> > limited to just using real hw for any tests.
> >
> > Linux serverside SMBD support is not ready afaik.
> >
> > On Wed, Dec 18, 2019 at 12:49 PM Xiaoli Feng <xifeng@redhat.com> wrote:
> > >
> > > Hello Tom,
> > >
> > > Then I try to use IP to mount, it show this error:
> > > [79912.177783] CIFS VFS: _smbd_get_connection:1740 rdma_connect faile=
d
> > > port=3D5445
> > > [79912.220723] CIFS VFS: _smbd_get_connection:1740 rdma_connect faile=
d
> > > port=3D445
> > >
> > > Client:
> > > $ mount //172.31.0.250/cifs cifs -o user=3Droot,password=3Dredhat,rdm=
a
> > > mount error(2): No such file or directory
> > > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> > >
> > > Server:
> > > $ ib addr |grep 172.31.0.250/
> > > mlx4_ib0:               Link UP, Interface UP   172.31.0.250/24
> > >
> > > Samba version is 4.11.2. And firewalld is stopped.
> > >
> > > ----- Original Message -----
> > > > From: "Tom Talpey" <ttalpey@microsoft.com>
> > > > To: "Xiaoli Feng" <xifeng@redhat.com>, linux-cifs@vger.kernel.org
> > > > Sent: Tuesday, December 17, 2019 1:11:24 AM
> > > > Subject: RE: How to use SMB Direct
> > > >
> > > > > -----Original Message-----
> > > > > From: linux-cifs-owner@vger.kernel.org
> > > > > <linux-cifs-owner@vger.kernel.org>
> > > > > On
> > > > > Behalf Of Xiaoli Feng
> > > > > Sent: Monday, December 16, 2019 10:30 AM
> > > > > To: linux-cifs@vger.kernel.org
> > > > > Subject: [EXTERNAL] How to use SMB Direct
> > > > >
> > > > > Hello guys,
> > > > >
> > > > > I'd like to test SMB Direct. But it's failed. I'm not sure if it =
works
> > > > > in
> > > > > upstream.
> > > > > I setup samba server on one rdma machine with 5.5.0-rc1+ kernel. =
The
> > > > > smb.conf is:
> > > > > [cifs]
> > > > > path=3D/mnt/cifs
> > > > > writeable=3Dyes
> > > > >
> > > > > Then I try to mount the share on another rdma machine with 5.5.0-=
rc1+
> > > > > kernel.
> > > > >    mount //$RDMA/cifs cifs -o user=3Droot,password=3D$password,rd=
ma
> > > > >
> > > > > It's failed because of "CIFS VFS: smbd_create_id:614
> > > > > rdma_resolve_addr()
> > > > > completed -113"
> > > >
> > > > Errno 113 is "no route to host". Sounds like a network or address i=
ssue.
> > > >
> > > > Tom.
> > > >
> > > > > Does SMB Direct work fine in upstream?
> > > > >
> > > > > Thanks.
> > > > >
> > > > > $ cat /boot/config-5.5.0-rc1+ |grep SMB_DIRECT
> > > > > CONFIG_CIFS_SMB_DIRECT=3Dy
> > > > > $ ibstat
> > > > > CA 'mlx4_0'
> > > > >     CA type: MT4099
> > > > >     Number of ports: 2
> > > > >     Firmware version: 2.42.5000
> > > > >     Hardware version: 1
> > > > >     Node GUID: 0xf4521403007be0e0
> > > > >     System image GUID: 0xf4521403007be0e3
> > > > >     Port 1:
> > > > >             State: Active
> > > > >             Physical state: LinkUp
> > > > >             Rate: 56
> > > > >             Base lid: 29
> > > > >             LMC: 0
> > > > >             SM lid: 1
> > > > >             Capability mask: 0x0259486a
> > > > >             Port GUID: 0xf4521403007be0e1
> > > > >             Link layer: InfiniBand
> > > > >     Port 2:
> > > > >             State: Active
> > > > >             Physical state: LinkUp
> > > > >             Rate: 40
> > > > >             Base lid: 44
> > > > >             LMC: 1
> > > > >             SM lid: 36
> > > > >             Capability mask: 0x02594868
> > > > >             Port GUID: 0xf4521403007be0e2
> > > > >             Link layer: InfiniBand
> > > > >
> > > > >
> > > > > --
> > > > > Best regards!
> > > > > XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
> > > > >
> > > > > Red Hat Software (Beijing) Co.,Ltd
> > > > > filesystem-qe Team
> > > > > IRC:xifeng=EF=BC=8C#channel: fs-qe
> > > > > Tel:+86-10-8388112
> > > > > 9/F, Raycom
> > > >
> > > >
> > >
> >
> >
>
