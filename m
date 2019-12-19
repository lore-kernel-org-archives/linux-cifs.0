Return-Path: <SRS0=Aa8Y=2J=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46966C2D0C1
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 07:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FBEF21D7D
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 07:48:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hvXPx0VC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfLSHsg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Dec 2019 02:48:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41652 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfLSHsg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Dec 2019 02:48:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so4911679wrw.8
        for <linux-cifs@vger.kernel.org>; Wed, 18 Dec 2019 23:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O+4wbG6ZYeIguZZajvUdRK7KiFw3/Zw/UVPQ19yTvFU=;
        b=hvXPx0VCQhE5n0JucMvoAnJeGTyQ/McSw3sHNlbL7tQdm7rM7YFqd9GxeyCuF6OFP8
         dgsXbcIC2LqHti9I6vsFnX+ls3D96ZcMzAaGYeYKwDTOQLz334nBLJN4ipEcABuwOtpf
         DljIwxdIxVcLWO3unG3iyyebcRZPFslwy2+Sn0+Kb9/0YP/R3JlQeB9p+G7vK3zFEPJS
         hoF09Lt9TPg4r1LWUnO7H7NPvYlhEreR6BgE9vZTzBmFnd/JvdYriXTSplxnT8IqZXpZ
         qu0jWOc7dyczKHhWmbutFGq9I8aw7EUBTq42eby45hxvtw1JRaUGfdG2MHOjgMkEsqnr
         /gtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O+4wbG6ZYeIguZZajvUdRK7KiFw3/Zw/UVPQ19yTvFU=;
        b=C/SFb0uyoP680JFw9K5hThuiSW/b265mJfiCDo2BrgZCJU5ShZt7t08yBQTTK5Sp2v
         0IfkrfvKikPcypHR1+NLW8CghRRH3LGTfn+3/Z1wumMNsvkF3s4r8/Z+qfnzb8/oclzG
         7atjhFSVYzyWtC6+x+wa0gekqrpI435We58nCmxRJLrScHCsK/imP5uKqTBfLEiUqoKZ
         OHg3J0Gt4QgeflvKJpvIFfWXbJ2Zq3TdSThNrqsDy0Ybc1pUDU10rOn+CaPf/27QltW4
         00PjqaNAaWtFG+5m930C/AxkhVbIgOwrhhcpBs7jp9LYSUAp0wusbFLGPblFvXKoI7Pa
         RF7A==
X-Gm-Message-State: APjAAAXYN+K+aRicuLGO4Mx2BEMIN0I6wp7ovF6BpYdVTx37yAB3aCIG
        9zCsOH9wJ+0f06qYOaav7Abnno8bX5bgtanmWR0=
X-Google-Smtp-Source: APXvYqwC03GAccNXiGYIBjVgg7+qCu8fXIEgApD38ftooXwN0UcvDrssv+T1dZrr3hGS/jfnU5uOKNSNXlsKKTg8Sz0=
X-Received: by 2002:adf:eb48:: with SMTP id u8mr7498450wrn.283.1576741713609;
 Wed, 18 Dec 2019 23:48:33 -0800 (PST)
MIME-Version: 1.0
References: <1327532317.1529923.1576509501382.JavaMail.zimbra@redhat.com>
 <180194560.1531945.1576510209913.JavaMail.zimbra@redhat.com>
 <MN2PR21MB143962C9B65975E1DAD7A81BA0510@MN2PR21MB1439.namprd21.prod.outlook.com>
 <798763602.1820950.1576637331025.JavaMail.zimbra@redhat.com>
 <CAN05THShz43rw51JP-1X7JFjbuPCLAH2jcv+8x=d65UtMT+2hQ@mail.gmail.com>
 <2122939021.2041834.1576722876658.JavaMail.zimbra@redhat.com>
 <CANFS6bY6b23MznmrGuugcVUEW3UuRbzAxBd4p35K3qdkz4DCAA@mail.gmail.com> <CAN05THQQh26tPOS6Yw8=M9dhjaS3Qr0KOmEZ+puwaMN7+BwHaw@mail.gmail.com>
In-Reply-To: <CAN05THQQh26tPOS6Yw8=M9dhjaS3Qr0KOmEZ+puwaMN7+BwHaw@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 19 Dec 2019 16:48:22 +0900
Message-ID: <CANFS6bYJ0JZdH3jfy7u8y9=nb=CAGvHO_MzUPqni5PxJiu5Q8w@mail.gmail.com>
Subject: Re: How to use SMB Direct
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Xiaoli Feng <xifeng@redhat.com>,
        Tom Talpey <ttalpey@microsoft.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        linux-cifsd-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Ronnie,

2019=EB=85=84 12=EC=9B=94 19=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 3:57, =
ronnie sahlberg <ronniesahlberg@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> On Thu, Dec 19, 2019 at 4:47 PM Hyeoncheol Lee <hyc.lee@gmail.com> wrote:
> >
> > Hello Xiaoli,
> >
> > cifsd is an in-kernel SMB server which supports SMB Direct.
> > If you want to test SMB Direct with cifs, you can use cifsd.
> >
> > Currently we have tested SMB Direct between two old fashioned
> > Mellanox ConnectX devices which are connected directly,
> > and between two soft RoCE devices in kernel.
>
> Thanks Hyeoncheol,
>
> This is very interesting!
>
> We have a buildbot upstream for the cifs client where we test every
> set of patches before they go to linus :
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/b=
uilds/302
>
> I havent had time to test with your cifsd yet but as you say you can
> use soft-RoCE
> you are saying it will work doing soft-RoCE between one VM running
> cifs.ko and a basic virtio NIC
> to another VM running your cifsd and also using a basic virtio NIC?

Yes, I had tested SMB Direct between the two VMs that are configured
as you said.

>
> I would really want to set up so we can do RDMA tests for cifs.ko, and
> by accident cifsd, in our buildbot.
>

We will help you. but before that, our cifsd's xfstests test-cases are
a different
with your cifs' test-cases. your some test-cases may be failed for cifsd.
our test-cases were suggested by Steve in the past.

So we want to know the list of your test-cases and check that the cases wil=
l
succeed for cifsd.
And while we check the test-cases, the common test-cases between cifs and c=
ifsd
can be tested in the buildbot.

Thank you.
>
> regards
> ronnie sahlberg
>
>
> >
> > You can get cifsd's code from the following url, and
> > If you have any questions, we will help you.
> >
> > https://github.com/cifsd-team/cifsd.git
> >
> > Thank you.
> >
> >
> > 2019=EB=85=84 12=EC=9B=94 19=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 11=
:35, Xiaoli Feng <xifeng@redhat.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> > >
> > > Thanks Ronnie for the information. Last question: Is it supported tha=
t mount the windows file
> > > server(has rdma hardware) with SMB Direct in linux client(has rdma ha=
rdware)?
> > >
> > > ----- Original Message -----
> > > > From: "ronnie sahlberg" <ronniesahlberg@gmail.com>
> > > > To: "Xiaoli Feng" <xifeng@redhat.com>
> > > > Cc: "Tom Talpey" <ttalpey@microsoft.com>, "linux-cifs" <linux-cifs@=
vger.kernel.org>
> > > > Sent: Wednesday, December 18, 2019 4:12:32 PM
> > > > Subject: Re: How to use SMB Direct
> > > >
> > > > I don't think samba supports SMB Direct.
> > > > Metze used to have a private repo with some experimental patches bu=
t I
> > > > don't think it
> > > > has landed in official samba yet.
> > > >
> > > > For a linux server, there is an experimental kernel based server
> > > > called cifsd which should support SMBDirect
> > > > but is incomplete in other areas. It is not part of linus tree yet
> > > > (but soon I hope).
> > > >
> > > > Windows servers support SMBDirect but I am not aware of any soft-rd=
ma
> > > > support so you might be
> > > > limited to just using real hw for any tests.
> > > >
> > > > Linux serverside SMBD support is not ready afaik.
> > > >
> > > > On Wed, Dec 18, 2019 at 12:49 PM Xiaoli Feng <xifeng@redhat.com> wr=
ote:
> > > > >
> > > > > Hello Tom,
> > > > >
> > > > > Then I try to use IP to mount, it show this error:
> > > > > [79912.177783] CIFS VFS: _smbd_get_connection:1740 rdma_connect f=
ailed
> > > > > port=3D5445
> > > > > [79912.220723] CIFS VFS: _smbd_get_connection:1740 rdma_connect f=
ailed
> > > > > port=3D445
> > > > >
> > > > > Client:
> > > > > $ mount //172.31.0.250/cifs cifs -o user=3Droot,password=3Dredhat=
,rdma
> > > > > mount error(2): No such file or directory
> > > > > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> > > > >
> > > > > Server:
> > > > > $ ib addr |grep 172.31.0.250/
> > > > > mlx4_ib0:               Link UP, Interface UP   172.31.0.250/24
> > > > >
> > > > > Samba version is 4.11.2. And firewalld is stopped.
> > > > >
> > > > > ----- Original Message -----
> > > > > > From: "Tom Talpey" <ttalpey@microsoft.com>
> > > > > > To: "Xiaoli Feng" <xifeng@redhat.com>, linux-cifs@vger.kernel.o=
rg
> > > > > > Sent: Tuesday, December 17, 2019 1:11:24 AM
> > > > > > Subject: RE: How to use SMB Direct
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: linux-cifs-owner@vger.kernel.org
> > > > > > > <linux-cifs-owner@vger.kernel.org>
> > > > > > > On
> > > > > > > Behalf Of Xiaoli Feng
> > > > > > > Sent: Monday, December 16, 2019 10:30 AM
> > > > > > > To: linux-cifs@vger.kernel.org
> > > > > > > Subject: [EXTERNAL] How to use SMB Direct
> > > > > > >
> > > > > > > Hello guys,
> > > > > > >
> > > > > > > I'd like to test SMB Direct. But it's failed. I'm not sure if=
 it works
> > > > > > > in
> > > > > > > upstream.
> > > > > > > I setup samba server on one rdma machine with 5.5.0-rc1+ kern=
el. The
> > > > > > > smb.conf is:
> > > > > > > [cifs]
> > > > > > > path=3D/mnt/cifs
> > > > > > > writeable=3Dyes
> > > > > > >
> > > > > > > Then I try to mount the share on another rdma machine with 5.=
5.0-rc1+
> > > > > > > kernel.
> > > > > > >    mount //$RDMA/cifs cifs -o user=3Droot,password=3D$passwor=
d,rdma
> > > > > > >
> > > > > > > It's failed because of "CIFS VFS: smbd_create_id:614
> > > > > > > rdma_resolve_addr()
> > > > > > > completed -113"
> > > > > >
> > > > > > Errno 113 is "no route to host". Sounds like a network or addre=
ss issue.
> > > > > >
> > > > > > Tom.
> > > > > >
> > > > > > > Does SMB Direct work fine in upstream?
> > > > > > >
> > > > > > > Thanks.
> > > > > > >
> > > > > > > $ cat /boot/config-5.5.0-rc1+ |grep SMB_DIRECT
> > > > > > > CONFIG_CIFS_SMB_DIRECT=3Dy
> > > > > > > $ ibstat
> > > > > > > CA 'mlx4_0'
> > > > > > >     CA type: MT4099
> > > > > > >     Number of ports: 2
> > > > > > >     Firmware version: 2.42.5000
> > > > > > >     Hardware version: 1
> > > > > > >     Node GUID: 0xf4521403007be0e0
> > > > > > >     System image GUID: 0xf4521403007be0e3
> > > > > > >     Port 1:
> > > > > > >             State: Active
> > > > > > >             Physical state: LinkUp
> > > > > > >             Rate: 56
> > > > > > >             Base lid: 29
> > > > > > >             LMC: 0
> > > > > > >             SM lid: 1
> > > > > > >             Capability mask: 0x0259486a
> > > > > > >             Port GUID: 0xf4521403007be0e1
> > > > > > >             Link layer: InfiniBand
> > > > > > >     Port 2:
> > > > > > >             State: Active
> > > > > > >             Physical state: LinkUp
> > > > > > >             Rate: 40
> > > > > > >             Base lid: 44
> > > > > > >             LMC: 1
> > > > > > >             SM lid: 36
> > > > > > >             Capability mask: 0x02594868
> > > > > > >             Port GUID: 0xf4521403007be0e2
> > > > > > >             Link layer: InfiniBand
> > > > > > >
> > > > > > >
> > > > > > > --
> > > > > > > Best regards!
> > > > > > > XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
> > > > > > >
> > > > > > > Red Hat Software (Beijing) Co.,Ltd
> > > > > > > filesystem-qe Team
> > > > > > > IRC:xifeng=EF=BC=8C#channel: fs-qe
> > > > > > > Tel:+86-10-8388112
> > > > > > > 9/F, Raycom
> > > > > >
> > > > > >
> > > > >
> > > >
> > > >
> > >
