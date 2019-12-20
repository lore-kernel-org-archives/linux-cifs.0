Return-Path: <SRS0=XmFd=2K=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F6D8C43603
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Dec 2019 03:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BAD624680
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Dec 2019 03:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ncBPFNof"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfLTD0s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Dec 2019 22:26:48 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:33808 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfLTD0s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Dec 2019 22:26:48 -0500
Received: by mail-il1-f195.google.com with SMTP id s15so6760622iln.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 Dec 2019 19:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uOXFshj1xVChSolQz9pmkip32JivOplrMkun05ZNlN0=;
        b=ncBPFNofVEDip1v0UJQHzWdSsCDGJImyaK5uBjvJN3qgCvfns0HL67ZsxlOaT651QR
         DyGHjjtSrSzkfn2vuUPbUhWOUYY2ltEl4LzEpiItQ/fRZAY9tkdodJQ71W0bJE0+67cv
         YNWsHCi5t3Cj538rO0pRpdf6QwVvcmn/K7w5pH9M6tfeFs1F6Yd5cbvoQMVLo2twbFGh
         mdppAji8GFFcwCuDyPy4/psZwZ2XU96D88frWWke0ucNGBzWZRp9FfUGkVL2a22GH3Q0
         JEcbHoRT2QPR8lBAuSi6LtBUMZ/hff5BXc1uLY/OnoRff7oo5DRMrGnUiYcsnWPsOdIC
         kzFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uOXFshj1xVChSolQz9pmkip32JivOplrMkun05ZNlN0=;
        b=UlYeT0ALV7249MCeIAgk7am9TLpqH2WY+X/S2zxmEMuZhIT18yF2ZYo7jkv6ikkHbJ
         mjktpc56Wt1ykqeCyoZD0d0EZQHkj6EboJnIbLNxjNlcVGQKZ3HqvHIPhe2I/XgiiyXV
         eX1sCJCJqbAiOS0hfTg/OszawWwlrsEOgXYSsegZjLx8p+TUyT75um2OUcEjXw07nMlu
         qfV5rBjBmZBO6Ikxfd/VPHRGcxQGSrIZQdcbTC48/QP5VAnPb9HkjRB2K4u5v8eh6KVq
         Fb4Hm21TDfb+ccC4nZpLVInUrxYvffO66ZlyeUYeccXaWHeEuXKFEdppwq8dNSmn6qT6
         iSZw==
X-Gm-Message-State: APjAAAVCIuVE45fwbsIuSzDpuF5mSAxECDEFP8LGuiRKYMR/qVMNmlmc
        71oz+B6z+ZAaGek5g/tcgt3kXii5M78/A/G9NQk=
X-Google-Smtp-Source: APXvYqzwYXNmwjapuHon+ltHnIyKptou0M+Wp/za7ntTwlrU9SS12soRaNQDLnlTPC5mGXonmQV96UYmQav5k4mwwic=
X-Received: by 2002:a92:d642:: with SMTP id x2mr10388261ilp.169.1576812407524;
 Thu, 19 Dec 2019 19:26:47 -0800 (PST)
MIME-Version: 1.0
References: <1327532317.1529923.1576509501382.JavaMail.zimbra@redhat.com>
 <180194560.1531945.1576510209913.JavaMail.zimbra@redhat.com>
 <MN2PR21MB143962C9B65975E1DAD7A81BA0510@MN2PR21MB1439.namprd21.prod.outlook.com>
 <798763602.1820950.1576637331025.JavaMail.zimbra@redhat.com>
 <CAN05THShz43rw51JP-1X7JFjbuPCLAH2jcv+8x=d65UtMT+2hQ@mail.gmail.com>
 <2122939021.2041834.1576722876658.JavaMail.zimbra@redhat.com>
 <CANFS6bY6b23MznmrGuugcVUEW3UuRbzAxBd4p35K3qdkz4DCAA@mail.gmail.com> <1047490239.2348842.1576810790780.JavaMail.zimbra@redhat.com>
In-Reply-To: <1047490239.2348842.1576810790780.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 19 Dec 2019 21:26:36 -0600
Message-ID: <CAH2r5mtFUQ67=s4KaqNTZw81_YQMNqcUUZCratk3F54ouqiZiA@mail.gmail.com>
Subject: Re: How to use SMB Direct
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     Hyeoncheol Lee <hyc.lee@gmail.com>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Tom Talpey <ttalpey@microsoft.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        linux-cifsd-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The work of Metze's on RDMA/smbdirect extensions to Samba, rely in
part on kernel code.   I can help merge that into the kernel but I
would like some agreement between Metze and Long Li (and Tom etc.) on
what would be useful to be shared between cifs.ko and the proposed
RDMA helpe driver for Samba.   From discussions this fall, it is
probably too early to consider the merge request, but I am very open
to following up discussions on this.

The alternative RDMA/smbdirect implementation in cifsd (the proposed
smb3 kernel server written by Namjae and other) is very exciting and
an interesting topic, but likely unrelated to the Samba server
implementation that Metze is working on.   The issues involved in
merging cifsd (the SMB3 kernel server) into the mainline kernel are
quite different than those related to Samba's RDMA implementation, and
instead mostly have to deal with addressing review comments from
others (I have sent namjae various suggestions which he appears to be
addressing).   More review feedback of the cifsd kernel server will be
very helpful - but the main issues are not RDMA related.


On Thu, Dec 19, 2019 at 9:00 PM Xiaoli Feng <xifeng@redhat.com> wrote:
>
> Hello Hyeoncheol,
>
> When use the cifsd you provide, are there any required for Samba server?
> Now I have two machines that have Mellanox ConnectX-3. And install 5.5.0-=
rc1+.
> If one machine install the cifsd. Then I can use the SMB Direct without t=
he
> concern of Samba server. Is it right?
>
> As I know, seems there are two projects for SMB Direct(kernel part). One =
is
> the cifsd. The others is Metze's repo. Which one is planning to go into l=
inux
> tree or both are?
>
> https://github.com/cifsd-team/cifsd.git
> https://git.samba.org/?p=3Dmetze/linux/smbdirect.git;a=3Dshortlog;h=3Dref=
s/heads/smbdirect-work-in-progress
>
> Thanks.
>
> ----- Original Message -----
> > From: "Hyeoncheol Lee" <hyc.lee@gmail.com>
> > To: "Xiaoli Feng" <xifeng@redhat.com>
> > Cc: "ronnie sahlberg" <ronniesahlberg@gmail.com>, "Tom Talpey" <ttalpey=
@microsoft.com>, "linux-cifs"
> > <linux-cifs@vger.kernel.org>, linux-cifsd-devel@lists.sourceforge.net
> > Sent: Thursday, December 19, 2019 2:47:40 PM
> > Subject: Re: How to use SMB Direct
> >
> > Hello Xiaoli,
> >
> > cifsd is an in-kernel SMB server which supports SMB Direct.
> > If you want to test SMB Direct with cifs, you can use cifsd.
> >
> > Currently we have tested SMB Direct between two old fashioned
> > Mellanox ConnectX devices which are connected directly,
> > and between two soft RoCE devices in kernel.
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
t
> > > mount the windows file
> > > server(has rdma hardware) with SMB Direct in linux client(has rdma
> > > hardware)?
> > >
> > > ----- Original Message -----
> > > > From: "ronnie sahlberg" <ronniesahlberg@gmail.com>
> > > > To: "Xiaoli Feng" <xifeng@redhat.com>
> > > > Cc: "Tom Talpey" <ttalpey@microsoft.com>, "linux-cifs"
> > > > <linux-cifs@vger.kernel.org>
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
 it
> > > > > > > works
> > > > > > > in
> > > > > > > upstream.
> > > > > > > I setup samba server on one rdma machine with 5.5.0-rc1+ kern=
el.
> > > > > > > The
> > > > > > > smb.conf is:
> > > > > > > [cifs]
> > > > > > > path=3D/mnt/cifs
> > > > > > > writeable=3Dyes
> > > > > > >
> > > > > > > Then I try to mount the share on another rdma machine with
> > > > > > > 5.5.0-rc1+
> > > > > > > kernel.
> > > > > > >    mount //$RDMA/cifs cifs -o user=3Droot,password=3D$passwor=
d,rdma
> > > > > > >
> > > > > > > It's failed because of "CIFS VFS: smbd_create_id:614
> > > > > > > rdma_resolve_addr()
> > > > > > > completed -113"
> > > > > >
> > > > > > Errno 113 is "no route to host". Sounds like a network or addre=
ss
> > > > > > issue.
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
> >
> >
>


--=20
Thanks,

Steve
