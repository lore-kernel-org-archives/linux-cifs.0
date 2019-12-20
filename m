Return-Path: <SRS0=XmFd=2K=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0D0C43603
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Dec 2019 03:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA6A924682
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Dec 2019 03:00:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QfbZi8n/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLTDAL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Dec 2019 22:00:11 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27893 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726964AbfLTDAL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 19 Dec 2019 22:00:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576810809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iSoi+OZ9gsd099HPhYLRn4hE7LZi3IoERyjZ9L8fgTo=;
        b=QfbZi8n/n6w7SG1vqKfZzIWM/mFDb2uj5BfxXP2QYuzk8wn0p64FlVRa5kpA2ZpCGzXjHl
        mXU3YXJTL8DqHVO+e4i09x2p5jBhogNfdqHbA2SD5IrMOwJzo+4wEUU5fOaiXz/C4fMNQd
        y0rm0/EtERpd0bUlQzit3u1qBWPUZpg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-i0u50eEGPGK3fk89elYGHQ-1; Thu, 19 Dec 2019 21:59:52 -0500
X-MC-Unique: i0u50eEGPGK3fk89elYGHQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7939D107ACC7;
        Fri, 20 Dec 2019 02:59:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4471C1001DC0;
        Fri, 20 Dec 2019 02:59:51 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0D718252C2;
        Fri, 20 Dec 2019 02:59:51 +0000 (UTC)
Date:   Thu, 19 Dec 2019 21:59:50 -0500 (EST)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     Hyeoncheol Lee <hyc.lee@gmail.com>, metze@samba.org
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Tom Talpey <ttalpey@microsoft.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        linux-cifsd-devel@lists.sourceforge.net,
        Steve French <smfrench@gmail.com>
Message-ID: <1047490239.2348842.1576810790780.JavaMail.zimbra@redhat.com>
In-Reply-To: <CANFS6bY6b23MznmrGuugcVUEW3UuRbzAxBd4p35K3qdkz4DCAA@mail.gmail.com>
References: <1327532317.1529923.1576509501382.JavaMail.zimbra@redhat.com> <180194560.1531945.1576510209913.JavaMail.zimbra@redhat.com> <MN2PR21MB143962C9B65975E1DAD7A81BA0510@MN2PR21MB1439.namprd21.prod.outlook.com> <798763602.1820950.1576637331025.JavaMail.zimbra@redhat.com> <CAN05THShz43rw51JP-1X7JFjbuPCLAH2jcv+8x=d65UtMT+2hQ@mail.gmail.com> <2122939021.2041834.1576722876658.JavaMail.zimbra@redhat.com> <CANFS6bY6b23MznmrGuugcVUEW3UuRbzAxBd4p35K3qdkz4DCAA@mail.gmail.com>
Subject: Re: How to use SMB Direct
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.20]
Thread-Topic: How to use SMB Direct
Thread-Index: AiwW8zE/Y2PscmpBvQqfeHgtRr+pNA==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Hyeoncheol,

When use the cifsd you provide, are there any required for Samba server?
Now I have two machines that have Mellanox ConnectX-3. And install 5.5.0-rc=
1+.
If one machine install the cifsd. Then I can use the SMB Direct without the=
=20
concern of Samba server. Is it right?

As I know, seems there are two projects for SMB Direct(kernel part). One is
the cifsd. The others is Metze's repo. Which one is planning to go into lin=
ux
tree or both are?=20

https://github.com/cifsd-team/cifsd.git
https://git.samba.org/?p=3Dmetze/linux/smbdirect.git;a=3Dshortlog;h=3Drefs/=
heads/smbdirect-work-in-progress

Thanks.

----- Original Message -----
> From: "Hyeoncheol Lee" <hyc.lee@gmail.com>
> To: "Xiaoli Feng" <xifeng@redhat.com>
> Cc: "ronnie sahlberg" <ronniesahlberg@gmail.com>, "Tom Talpey" <ttalpey@m=
icrosoft.com>, "linux-cifs"
> <linux-cifs@vger.kernel.org>, linux-cifsd-devel@lists.sourceforge.net
> Sent: Thursday, December 19, 2019 2:47:40 PM
> Subject: Re: How to use SMB Direct
>=20
> Hello Xiaoli,
>=20
> cifsd is an in-kernel SMB server which supports SMB Direct.
> If you want to test SMB Direct with cifs, you can use cifsd.
>=20
> Currently we have tested SMB Direct between two old fashioned
> Mellanox ConnectX devices which are connected directly,
> and between two soft RoCE devices in kernel.
>=20
> You can get cifsd's code from the following url, and
> If you have any questions, we will help you.
>=20
> https://github.com/cifsd-team/cifsd.git
>=20
> Thank you.
>=20
>=20
> 2019=EB=85=84 12=EC=9B=94 19=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 11:3=
5, Xiaoli Feng <xifeng@redhat.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >
> > Thanks Ronnie for the information. Last question: Is it supported that
> > mount the windows file
> > server(has rdma hardware) with SMB Direct in linux client(has rdma
> > hardware)?
> >
> > ----- Original Message -----
> > > From: "ronnie sahlberg" <ronniesahlberg@gmail.com>
> > > To: "Xiaoli Feng" <xifeng@redhat.com>
> > > Cc: "Tom Talpey" <ttalpey@microsoft.com>, "linux-cifs"
> > > <linux-cifs@vger.kernel.org>
> > > Sent: Wednesday, December 18, 2019 4:12:32 PM
> > > Subject: Re: How to use SMB Direct
> > >
> > > I don't think samba supports SMB Direct.
> > > Metze used to have a private repo with some experimental patches but =
I
> > > don't think it
> > > has landed in official samba yet.
> > >
> > > For a linux server, there is an experimental kernel based server
> > > called cifsd which should support SMBDirect
> > > but is incomplete in other areas. It is not part of linus tree yet
> > > (but soon I hope).
> > >
> > > Windows servers support SMBDirect but I am not aware of any soft-rdma
> > > support so you might be
> > > limited to just using real hw for any tests.
> > >
> > > Linux serverside SMBD support is not ready afaik.
> > >
> > > On Wed, Dec 18, 2019 at 12:49 PM Xiaoli Feng <xifeng@redhat.com> wrot=
e:
> > > >
> > > > Hello Tom,
> > > >
> > > > Then I try to use IP to mount, it show this error:
> > > > [79912.177783] CIFS VFS: _smbd_get_connection:1740 rdma_connect fai=
led
> > > > port=3D5445
> > > > [79912.220723] CIFS VFS: _smbd_get_connection:1740 rdma_connect fai=
led
> > > > port=3D445
> > > >
> > > > Client:
> > > > $ mount //172.31.0.250/cifs cifs -o user=3Droot,password=3Dredhat,r=
dma
> > > > mount error(2): No such file or directory
> > > > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> > > >
> > > > Server:
> > > > $ ib addr |grep 172.31.0.250/
> > > > mlx4_ib0:               Link UP, Interface UP   172.31.0.250/24
> > > >
> > > > Samba version is 4.11.2. And firewalld is stopped.
> > > >
> > > > ----- Original Message -----
> > > > > From: "Tom Talpey" <ttalpey@microsoft.com>
> > > > > To: "Xiaoli Feng" <xifeng@redhat.com>, linux-cifs@vger.kernel.org
> > > > > Sent: Tuesday, December 17, 2019 1:11:24 AM
> > > > > Subject: RE: How to use SMB Direct
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: linux-cifs-owner@vger.kernel.org
> > > > > > <linux-cifs-owner@vger.kernel.org>
> > > > > > On
> > > > > > Behalf Of Xiaoli Feng
> > > > > > Sent: Monday, December 16, 2019 10:30 AM
> > > > > > To: linux-cifs@vger.kernel.org
> > > > > > Subject: [EXTERNAL] How to use SMB Direct
> > > > > >
> > > > > > Hello guys,
> > > > > >
> > > > > > I'd like to test SMB Direct. But it's failed. I'm not sure if i=
t
> > > > > > works
> > > > > > in
> > > > > > upstream.
> > > > > > I setup samba server on one rdma machine with 5.5.0-rc1+ kernel=
.
> > > > > > The
> > > > > > smb.conf is:
> > > > > > [cifs]
> > > > > > path=3D/mnt/cifs
> > > > > > writeable=3Dyes
> > > > > >
> > > > > > Then I try to mount the share on another rdma machine with
> > > > > > 5.5.0-rc1+
> > > > > > kernel.
> > > > > >    mount //$RDMA/cifs cifs -o user=3Droot,password=3D$password,=
rdma
> > > > > >
> > > > > > It's failed because of "CIFS VFS: smbd_create_id:614
> > > > > > rdma_resolve_addr()
> > > > > > completed -113"
> > > > >
> > > > > Errno 113 is "no route to host". Sounds like a network or address
> > > > > issue.
> > > > >
> > > > > Tom.
> > > > >
> > > > > > Does SMB Direct work fine in upstream?
> > > > > >
> > > > > > Thanks.
> > > > > >
> > > > > > $ cat /boot/config-5.5.0-rc1+ |grep SMB_DIRECT
> > > > > > CONFIG_CIFS_SMB_DIRECT=3Dy
> > > > > > $ ibstat
> > > > > > CA 'mlx4_0'
> > > > > >     CA type: MT4099
> > > > > >     Number of ports: 2
> > > > > >     Firmware version: 2.42.5000
> > > > > >     Hardware version: 1
> > > > > >     Node GUID: 0xf4521403007be0e0
> > > > > >     System image GUID: 0xf4521403007be0e3
> > > > > >     Port 1:
> > > > > >             State: Active
> > > > > >             Physical state: LinkUp
> > > > > >             Rate: 56
> > > > > >             Base lid: 29
> > > > > >             LMC: 0
> > > > > >             SM lid: 1
> > > > > >             Capability mask: 0x0259486a
> > > > > >             Port GUID: 0xf4521403007be0e1
> > > > > >             Link layer: InfiniBand
> > > > > >     Port 2:
> > > > > >             State: Active
> > > > > >             Physical state: LinkUp
> > > > > >             Rate: 40
> > > > > >             Base lid: 44
> > > > > >             LMC: 1
> > > > > >             SM lid: 36
> > > > > >             Capability mask: 0x02594868
> > > > > >             Port GUID: 0xf4521403007be0e2
> > > > > >             Link layer: InfiniBand
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Best regards!
> > > > > > XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
> > > > > >
> > > > > > Red Hat Software (Beijing) Co.,Ltd
> > > > > > filesystem-qe Team
> > > > > > IRC:xifeng=EF=BC=8C#channel: fs-qe
> > > > > > Tel:+86-10-8388112
> > > > > > 9/F, Raycom
> > > > >
> > > > >
> > > >
> > >
> > >
> >
>=20
>=20

