Return-Path: <SRS0=Aa8Y=2J=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50536C43603
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 02:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1310E22314
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Dec 2019 02:58:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WLXWAcBT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfLSC6t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Dec 2019 21:58:49 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:42767 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfLSC6t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Dec 2019 21:58:49 -0500
Received: by mail-io1-f66.google.com with SMTP id n11so2685688iom.9
        for <linux-cifs@vger.kernel.org>; Wed, 18 Dec 2019 18:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2HeF4ST+j75iwptCyYLZUHQl4xb+DXiIOpnS0eUbMBc=;
        b=WLXWAcBTy0hi8scmYTcwWgX2M6VfyjQWe/btLnWgkvg6991z5r3Df09hyF8SPCBEHg
         znBG2HhCIOsXUYDiQbbYnfyGgdsftUwfEClI3xAfnrH0VdeZr6D5pxxC0EUSywg62qFj
         JJfR9sHxtRfZjoHjZq4JveijGvKdw4zgiUK91qzaregDEWar773ifKdndZVkHC9knYqw
         ytpB5z4f79DQ+4pIr0ZTK3oLz7ONJXG3K5nVNsBRgq6RpIWKDj976p3yzKi6zam+foNs
         JCn/kMuzdxfVfCE6k9WtNyvu3PJ3ly9yOs9p225RPu9EjeKZg8dKANotqSQWX8fBfyOk
         rlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2HeF4ST+j75iwptCyYLZUHQl4xb+DXiIOpnS0eUbMBc=;
        b=nIbME57KHoMa/IaluszEWxBTbsIzrninfeR8yu9aGKWRcx/bzfU65xtrzr4zHp7HQ6
         DyzceEEi5COSKQOl3CWu48NW0zJucNIgB4/6hKTBv4vTRl09FerHpExmVCSmlAf4s5Md
         UHZ7bDDsNkQ/JWprinSx9G2akMNAqEBp5EgKDehRZLw7AVjwNSL3mPSSQMA0X88atoe5
         p+Fh9E1mg2nLzexPlYeAldAKxHfE15tqs9Yej/c2+63wq6ettLeS3/1dxS8+YDGhVXXm
         aqT/ARTS68yhV0c9JtuuqREiI7m4qoeDBVh/hmMwkLzNjzFbeJ6SoqnInOpYx6o4Zkl9
         0jUg==
X-Gm-Message-State: APjAAAVfDusvg8oiwVkroL1l5q7iHYaVnM+QAXmaATnTK/giTm8eJJq+
        BsAERDlyIXOQYwePYNlDo7lFw/lgULXJ5IjytxA=
X-Google-Smtp-Source: APXvYqwiMiNxI0PLA9+gxVCtLHJEZkkXeWtTi32nOU0HGDcg4yAORGonGQG3KhB89I9ALIZnjAgzKlJYIpugWVfErlw=
X-Received: by 2002:a6b:14d4:: with SMTP id 203mr3874304iou.159.1576724328864;
 Wed, 18 Dec 2019 18:58:48 -0800 (PST)
MIME-Version: 1.0
References: <1327532317.1529923.1576509501382.JavaMail.zimbra@redhat.com>
 <180194560.1531945.1576510209913.JavaMail.zimbra@redhat.com>
 <MN2PR21MB143962C9B65975E1DAD7A81BA0510@MN2PR21MB1439.namprd21.prod.outlook.com>
 <798763602.1820950.1576637331025.JavaMail.zimbra@redhat.com>
 <CAN05THShz43rw51JP-1X7JFjbuPCLAH2jcv+8x=d65UtMT+2hQ@mail.gmail.com> <2122939021.2041834.1576722876658.JavaMail.zimbra@redhat.com>
In-Reply-To: <2122939021.2041834.1576722876658.JavaMail.zimbra@redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 19 Dec 2019 12:58:37 +1000
Message-ID: <CAN05THTb1d-GkQWVp5j=ZqHbcoNz1XttYhXf=ft=7irQACYKTA@mail.gmail.com>
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

On Thu, Dec 19, 2019 at 12:34 PM Xiaoli Feng <xifeng@redhat.com> wrote:
>
> Thanks Ronnie for the information. Last question: Is it supported that mo=
unt the windows file
> server(has rdma hardware) with SMB Direct in linux client(has rdma hardwa=
re)?

Yeah, that should definitely work. I think Steve, or a colleague, has
run through the same set of the tests in our buildbot
(manually?) in that configuration.

If you can please test the work-in-progress cifsd kernel server.
It should supposedly work with soft-rdma and if it does then that
could be a way where we could
integrate SMBDirect testing in the buildbot.

I haven't had any time to research cifsd or set it up and test unfortunatel=
y :-(

regards
ronnie sahlberg

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
