Return-Path: <SRS0=WFxL=2I=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C37C43603
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Dec 2019 02:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67D9C21775
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Dec 2019 02:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ec2JnHBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfLRCtK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Dec 2019 21:49:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37031 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726598AbfLRCtJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Dec 2019 21:49:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576637348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m/hTCyZP8v4iJRTaB3JKLpbX+DFr2n36W2XBb0+TgwI=;
        b=Ec2JnHBLgmPNihYQ4dBvqRutkEIPk+cuEtH3qgaFdsT39zhheUwKyFocTB9dVDxIjVSns4
        DGRRMWkt5JGhMV1sna1fJeMGpNPqywTyn7oyFBJXsBKramuR81B3CWaSi8pJD8JSZu2ctz
        HuJZAmv2CNh7lMG9w669KEIWEJtFvt8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-1I37rttoMMmBnHz6u4BwjQ-1; Tue, 17 Dec 2019 21:48:52 -0500
X-MC-Unique: 1I37rttoMMmBnHz6u4BwjQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C4DD1856A7F;
        Wed, 18 Dec 2019 02:48:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 637ED60933;
        Wed, 18 Dec 2019 02:48:51 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 57C4618089C8;
        Wed, 18 Dec 2019 02:48:51 +0000 (UTC)
Date:   Tue, 17 Dec 2019 21:48:51 -0500 (EST)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     Tom Talpey <ttalpey@microsoft.com>
Cc:     linux-cifs@vger.kernel.org
Message-ID: <798763602.1820950.1576637331025.JavaMail.zimbra@redhat.com>
In-Reply-To: <MN2PR21MB143962C9B65975E1DAD7A81BA0510@MN2PR21MB1439.namprd21.prod.outlook.com>
References: <1327532317.1529923.1576509501382.JavaMail.zimbra@redhat.com> <180194560.1531945.1576510209913.JavaMail.zimbra@redhat.com> <MN2PR21MB143962C9B65975E1DAD7A81BA0510@MN2PR21MB1439.namprd21.prod.outlook.com>
Subject: Re: How to use SMB Direct
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.72.12.179, 10.4.195.20]
Thread-Topic: How to use SMB Direct
Thread-Index: UIMmQ9EQHszzT+199YRg7frRdlFZzaUb4A1gayuP5xI=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Tom,

Then I try to use IP to mount, it show this error:
[79912.177783] CIFS VFS: _smbd_get_connection:1740 rdma_connect failed port=
=3D5445
[79912.220723] CIFS VFS: _smbd_get_connection:1740 rdma_connect failed port=
=3D445

Client:
$ mount //172.31.0.250/cifs cifs -o user=3Droot,password=3Dredhat,rdma
mount error(2): No such file or directory
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

Server:
$ ib addr |grep 172.31.0.250/
mlx4_ib0:=09=09Link UP, Interface UP=09172.31.0.250/24

Samba version is 4.11.2. And firewalld is stopped.

----- Original Message -----
> From: "Tom Talpey" <ttalpey@microsoft.com>
> To: "Xiaoli Feng" <xifeng@redhat.com>, linux-cifs@vger.kernel.org
> Sent: Tuesday, December 17, 2019 1:11:24 AM
> Subject: RE: How to use SMB Direct
>=20
> > -----Original Message-----
> > From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.or=
g>
> > On
> > Behalf Of Xiaoli Feng
> > Sent: Monday, December 16, 2019 10:30 AM
> > To: linux-cifs@vger.kernel.org
> > Subject: [EXTERNAL] How to use SMB Direct
> >=20
> > Hello guys,
> >=20
> > I'd like to test SMB Direct. But it's failed. I'm not sure if it works =
in
> > upstream.
> > I setup samba server on one rdma machine with 5.5.0-rc1+ kernel. The
> > smb.conf is:
> > [cifs]
> > path=3D/mnt/cifs
> > writeable=3Dyes
> >=20
> > Then I try to mount the share on another rdma machine with 5.5.0-rc1+
> > kernel.
> >    mount //$RDMA/cifs cifs -o user=3Droot,password=3D$password,rdma
> >=20
> > It's failed because of "CIFS VFS: smbd_create_id:614 rdma_resolve_addr(=
)
> > completed -113"
>=20
> Errno 113 is "no route to host". Sounds like a network or address issue.
>=20
> Tom.
>=20
> > Does SMB Direct work fine in upstream?
> >=20
> > Thanks.
> >=20
> > $ cat /boot/config-5.5.0-rc1+ |grep SMB_DIRECT
> > CONFIG_CIFS_SMB_DIRECT=3Dy
> > $ ibstat
> > CA 'mlx4_0'
> > =09CA type: MT4099
> > =09Number of ports: 2
> > =09Firmware version: 2.42.5000
> > =09Hardware version: 1
> > =09Node GUID: 0xf4521403007be0e0
> > =09System image GUID: 0xf4521403007be0e3
> > =09Port 1:
> > =09=09State: Active
> > =09=09Physical state: LinkUp
> > =09=09Rate: 56
> > =09=09Base lid: 29
> > =09=09LMC: 0
> > =09=09SM lid: 1
> > =09=09Capability mask: 0x0259486a
> > =09=09Port GUID: 0xf4521403007be0e1
> > =09=09Link layer: InfiniBand
> > =09Port 2:
> > =09=09State: Active
> > =09=09Physical state: LinkUp
> > =09=09Rate: 40
> > =09=09Base lid: 44
> > =09=09LMC: 1
> > =09=09SM lid: 36
> > =09=09Capability mask: 0x02594868
> > =09=09Port GUID: 0xf4521403007be0e2
> > =09=09Link layer: InfiniBand
> >=20
> >=20
> > --
> > Best regards!
> > XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
> >=20
> > Red Hat Software (Beijing) Co.,Ltd
> > filesystem-qe Team
> > IRC:xifeng=EF=BC=8C#channel: fs-qe
> > Tel:+86-10-8388112
> > 9/F, Raycom
>=20
>=20

