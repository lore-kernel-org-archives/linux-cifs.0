Return-Path: <SRS0=CZtn=BN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE383C433E1
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 08:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE487206D7
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 08:46:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EpQh/0ZJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgHCIqU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Aug 2020 04:46:20 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51309 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726222AbgHCIqT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Aug 2020 04:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596444378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4bR7uOTWMj9kfPdiRqLG6vVN909/nPWN1VUTch9yl4U=;
        b=EpQh/0ZJ43LaXSbDyp2liUaJyclFmfFH3lTbdVGiCfZ8r5zQv7LKFkUqlSVutzOuvGKyj7
        QGvs4RMoidWLGSXdUcwwgj6HXpVsfE301efvP0ZdaT441UWHpuKwY/2V8fGAUZbKOAtXd0
        nVF1iDSiOekUnIW10KepA8c77mnrDYc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-wnMgLCO3Nfyu72u8CiV8mw-1; Mon, 03 Aug 2020 04:46:14 -0400
X-MC-Unique: wnMgLCO3Nfyu72u8CiV8mw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43A28100944A;
        Mon,  3 Aug 2020 08:46:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AD581A7C8;
        Mon,  3 Aug 2020 08:46:13 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0EE6E95A72;
        Mon,  3 Aug 2020 08:46:13 +0000 (UTC)
Date:   Mon, 3 Aug 2020 04:46:12 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Message-ID: <342612495.44824091.1596444372983.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAH2r5muWV2P75oHToSR4_LaVWETXC1Y0LbpEWfD-rF00jfFMFg@mail.gmail.com>
References: <1119714633.44793917.1596421202774.JavaMail.zimbra@redhat.com> <506179292.44794805.1596422888744.JavaMail.zimbra@redhat.com> <CAH2r5muWV2P75oHToSR4_LaVWETXC1Y0LbpEWfD-rF00jfFMFg@mail.gmail.com>
Subject: Re: fallocate can't change the cifs disk space usage
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.24]
Thread-Topic: fallocate can't change the cifs disk space usage
Thread-Index: o2ES4eYYrbK81j5z4Y02rM6QfIXPqQ==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hell Steve,


----- Original Message -----
> From: "Steve French" <smfrench@gmail.com>
> To: "Xiaoli Feng" <xifeng@redhat.com>
> Cc: "CIFS" <linux-cifs@vger.kernel.org>, "samba-technical" <samba-technic=
al@lists.samba.org>
> Sent: Monday, August 3, 2020 12:42:32 PM
> Subject: Re: fallocate can't change the cifs disk space usage
>=20
> Any luck trying the same thing to Windows and/or Azure to see if this
> is possible Samba bug - sounds like possible Samba server bug but need
> more information.

Thanks for quick response. When trying the same thing to windows. This issu=
e is gone.
fallocate can update the space usage.

>=20
> Are you using one of the Samba plug in VFS modules on the server (like
> vfs_btrfs)?

I'm not using any samba plug in vfs.
=20
>=20
> What does the filesystem show (before and after) on the server side
> (local file system not just the remote view that Samba is returning
> for statfs) when you try the df -h?

on the server side, the space usage reported by df also keep the same befor=
e and
after fallocate.

>=20
> On Sun, Aug 2, 2020 at 9:55 PM Xiaoli Feng <xifeng@redhat.com> wrote:
> >
> > Hello all,
> >
> > Recently when I'm investigating the xfstests generic/213 generic/228
> > failures for cifs.
> > Found that fallocate can't change the cifs disk space usage. Comparing =
xfs
> > fileystem,
> > fallocate can update space usage.
> >
> > My tests is in 5.8.0-rc7+. I also file a bug for this issue.
> >   https://bugzilla.kernel.org/show_bug.cgi?id=3D208775
> >
> > # cat /etc/samba/smb.conf
> > [cifs]
> > path=3D/mnt/cifs
> > writeable=3Dyes
> > # mount //localhost/cifs cifs -o
> > user=3Droot,password=3Dredhat,cache=3Dnone,actimeo=3D0
> > # df -h cifs
> > Filesystem        Size  Used Avail Use% Mounted on
> > //localhost/cifs   36G   23G   13G  66% /root/cifs
> > #  fallocate -o 0 -l 2g /root/cifs/file1
> > # df -h cifs
> > Filesystem        Size  Used Avail Use% Mounted on
> > //localhost/cifs   36G   23G   13G  66% /root/cifs
> > ]# ls -l cifs
> > total 1
> > -rwxr-xr-x. 1 root root 2147483648 Aug  2 21:57 file1
> >
> > Thanks.
> >
> > --
> > Best regards!
> > XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
> >
>=20
>=20
> --
> Thanks,
>=20
> Steve
>=20
>=20

