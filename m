Return-Path: <SRS0=Aa8Y=2J=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E98C43603
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 02:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE5CE227BF
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 02:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KdJ/EAYp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLSCe4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Dec 2019 21:34:56 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40103 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726744AbfLSCe4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 18 Dec 2019 21:34:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576722894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lyFSUKHWCyGEiIaec6YX+1vhhWMJTyI+pmpWyedSuqk=;
        b=KdJ/EAYpjamUHBSCoJPwFP2MQjifibc06PN9D7jmUYx8oeYyT4dhUV0fl92RA09E/O45uN
        C8T/e1V+OsxnGdNg1ujLb+VPNAJWSnWmbQblyN4PHdzP9OOg6rIm/EdmbMCMDza0Y6LSRO
        +xktvnmGDomRpSf/vQIrxX3ItGmKioY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-Db8k9IjdNmyohseaYk0Mjg-1; Wed, 18 Dec 2019 21:34:38 -0500
X-MC-Unique: Db8k9IjdNmyohseaYk0Mjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 109488C8E14;
        Thu, 19 Dec 2019 02:34:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 057F75D9E2;
        Thu, 19 Dec 2019 02:34:37 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id EA5261809563;
        Thu, 19 Dec 2019 02:34:36 +0000 (UTC)
Date:   Wed, 18 Dec 2019 21:34:36 -0500 (EST)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Tom Talpey <ttalpey@microsoft.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Message-ID: <2122939021.2041834.1576722876658.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAN05THShz43rw51JP-1X7JFjbuPCLAH2jcv+8x=d65UtMT+2hQ@mail.gmail.com>
References: <1327532317.1529923.1576509501382.JavaMail.zimbra@redhat.com> <180194560.1531945.1576510209913.JavaMail.zimbra@redhat.com> <MN2PR21MB143962C9B65975E1DAD7A81BA0510@MN2PR21MB1439.namprd21.prod.outlook.com> <798763602.1820950.1576637331025.JavaMail.zimbra@redhat.com> <CAN05THShz43rw51JP-1X7JFjbuPCLAH2jcv+8x=d65UtMT+2hQ@mail.gmail.com>
Subject: Re: How to use SMB Direct
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.72.12.179, 10.4.195.8]
Thread-Topic: How to use SMB Direct
Thread-Index: 0TY5NckKcY7JgRbI12e4pSrPixQKnw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Ronnie for the information. Last question: Is it supported that moun=
t the windows file=20
server(has rdma hardware) with SMB Direct in linux client(has rdma hardware=
)?=20

----- Original Message -----
> From: "ronnie sahlberg" <ronniesahlberg@gmail.com>
> To: "Xiaoli Feng" <xifeng@redhat.com>
> Cc: "Tom Talpey" <ttalpey@microsoft.com>, "linux-cifs" <linux-cifs@vger.k=
ernel.org>
> Sent: Wednesday, December 18, 2019 4:12:32 PM
> Subject: Re: How to use SMB Direct
>=20
> I don't think samba supports SMB Direct.
> Metze used to have a private repo with some experimental patches but I
> don't think it
> has landed in official samba yet.
>=20
> For a linux server, there is an experimental kernel based server
> called cifsd which should support SMBDirect
> but is incomplete in other areas. It is not part of linus tree yet
> (but soon I hope).
>=20
> Windows servers support SMBDirect but I am not aware of any soft-rdma
> support so you might be
> limited to just using real hw for any tests.
>=20
> Linux serverside SMBD support is not ready afaik.
>=20
> On Wed, Dec 18, 2019 at 12:49 PM Xiaoli Feng <xifeng@redhat.com> wrote:
> >
> > Hello Tom,
> >
> > Then I try to use IP to mount, it show this error:
> > [79912.177783] CIFS VFS: _smbd_get_connection:1740 rdma_connect failed
> > port=3D5445
> > [79912.220723] CIFS VFS: _smbd_get_connection:1740 rdma_connect failed
> > port=3D445
> >
> > Client:
> > $ mount //172.31.0.250/cifs cifs -o user=3Droot,password=3Dredhat,rdma
> > mount error(2): No such file or directory
> > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> >
> > Server:
> > $ ib addr |grep 172.31.0.250/
> > mlx4_ib0:               Link UP, Interface UP   172.31.0.250/24
> >
> > Samba version is 4.11.2. And firewalld is stopped.
> >
> > ----- Original Message -----
> > > From: "Tom Talpey" <ttalpey@microsoft.com>
> > > To: "Xiaoli Feng" <xifeng@redhat.com>, linux-cifs@vger.kernel.org
> > > Sent: Tuesday, December 17, 2019 1:11:24 AM
> > > Subject: RE: How to use SMB Direct
> > >
> > > > -----Original Message-----
> > > > From: linux-cifs-owner@vger.kernel.org
> > > > <linux-cifs-owner@vger.kernel.org>
> > > > On
> > > > Behalf Of Xiaoli Feng
> > > > Sent: Monday, December 16, 2019 10:30 AM
> > > > To: linux-cifs@vger.kernel.org
> > > > Subject: [EXTERNAL] How to use SMB Direct
> > > >
> > > > Hello guys,
> > > >
> > > > I'd like to test SMB Direct. But it's failed. I'm not sure if it wo=
rks
> > > > in
> > > > upstream.
> > > > I setup samba server on one rdma machine with 5.5.0-rc1+ kernel. Th=
e
> > > > smb.conf is:
> > > > [cifs]
> > > > path=3D/mnt/cifs
> > > > writeable=3Dyes
> > > >
> > > > Then I try to mount the share on another rdma machine with 5.5.0-rc=
1+
> > > > kernel.
> > > >    mount //$RDMA/cifs cifs -o user=3Droot,password=3D$password,rdma
> > > >
> > > > It's failed because of "CIFS VFS: smbd_create_id:614
> > > > rdma_resolve_addr()
> > > > completed -113"
> > >
> > > Errno 113 is "no route to host". Sounds like a network or address iss=
ue.
> > >
> > > Tom.
> > >
> > > > Does SMB Direct work fine in upstream?
> > > >
> > > > Thanks.
> > > >
> > > > $ cat /boot/config-5.5.0-rc1+ |grep SMB_DIRECT
> > > > CONFIG_CIFS_SMB_DIRECT=3Dy
> > > > $ ibstat
> > > > CA 'mlx4_0'
> > > >     CA type: MT4099
> > > >     Number of ports: 2
> > > >     Firmware version: 2.42.5000
> > > >     Hardware version: 1
> > > >     Node GUID: 0xf4521403007be0e0
> > > >     System image GUID: 0xf4521403007be0e3
> > > >     Port 1:
> > > >             State: Active
> > > >             Physical state: LinkUp
> > > >             Rate: 56
> > > >             Base lid: 29
> > > >             LMC: 0
> > > >             SM lid: 1
> > > >             Capability mask: 0x0259486a
> > > >             Port GUID: 0xf4521403007be0e1
> > > >             Link layer: InfiniBand
> > > >     Port 2:
> > > >             State: Active
> > > >             Physical state: LinkUp
> > > >             Rate: 40
> > > >             Base lid: 44
> > > >             LMC: 1
> > > >             SM lid: 36
> > > >             Capability mask: 0x02594868
> > > >             Port GUID: 0xf4521403007be0e2
> > > >             Link layer: InfiniBand
> > > >
> > > >
> > > > --
> > > > Best regards!
> > > > XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
> > > >
> > > > Red Hat Software (Beijing) Co.,Ltd
> > > > filesystem-qe Team
> > > > IRC:xifeng=EF=BC=8C#channel: fs-qe
> > > > Tel:+86-10-8388112
> > > > 9/F, Raycom
> > >
> > >
> >
>=20
>=20

