Return-Path: <SRS0=f6oI=BQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E87C433DF
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Aug 2020 02:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B45A120823
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Aug 2020 02:35:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XUfl9FDj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgHFCfb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Aug 2020 22:35:31 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32450 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725999AbgHFCfa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Aug 2020 22:35:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596681329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cbI4f5kQHkquNifdlfQWRY8uKEK7k/f20zE6A4j+W88=;
        b=XUfl9FDjCiepctMOqv+jjUqecO+P7yU3+sOd3SdRt9YmNHRXs+a+hikzdpIL2LMVuCG/6y
        OFFqD8tmRV8IfjjtV98MJfSCgzZCkZH4eUR9G+9Cc90slSOEQbVgaNMnpUbvX32Pjgv0cy
        UqSqzhtBbw9NaI6EGHeOF+F/ZBeAtj8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-97_awbMBPSmgfNV3IANozw-1; Wed, 05 Aug 2020 22:35:27 -0400
X-MC-Unique: 97_awbMBPSmgfNV3IANozw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A4F68015F4;
        Thu,  6 Aug 2020 02:35:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 12EEB5C1D2;
        Thu,  6 Aug 2020 02:35:26 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B8C696925;
        Thu,  6 Aug 2020 02:35:26 +0000 (UTC)
Date:   Wed, 5 Aug 2020 22:35:25 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Message-ID: <595851922.45241022.1596681325405.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAH2r5mta2ueBhd=raxXvCDAaKe27Qay+Wr42KfP-W2RrmBs8tA@mail.gmail.com>
References: <1119714633.44793917.1596421202774.JavaMail.zimbra@redhat.com> <506179292.44794805.1596422888744.JavaMail.zimbra@redhat.com> <CAH2r5mta2ueBhd=raxXvCDAaKe27Qay+Wr42KfP-W2RrmBs8tA@mail.gmail.com>
Subject: Re: fallocate can't change the cifs disk space usage
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.1]
Thread-Topic: fallocate can't change the cifs disk space usage
Thread-Index: 8vmwHyy6cUr6jh8jU9oqQcs8FxZeZw==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

----- Original Message -----
> From: "Steve French" <smfrench@gmail.com>
> To: "Xiaoli Feng" <xifeng@redhat.com>
> Cc: "CIFS" <linux-cifs@vger.kernel.org>
> Sent: Wednesday, August 5, 2020 1:39:43 AM
> Subject: Re: fallocate can't change the cifs disk space usage
>=20
> I was looking in a little more detail at tests 213 and 228 ... and I
> see 228 passing to all servers I tried.  Did you see a problem with
> that?

Sorry, I made a mistake. I tested 228 in RHEL8 before. It's failed.=20
Maybe it needs some patches. Now I re-test 228 in 5.8.0-rc7+. It's=20
passed for both servers. And 213 is also passed if "strict allocate
 =3D yes" is set. And now I met another issue for windows file server.
client is 5.8.0-rc7+.

# truncate -s 320k windows/file
# fallocate -o 2k -l 256k windows/file
fallocate: fallocate failed: Operation not supported
# fallocate -o 320k -l 256k windows/file
#=20

Seems the offset for fallocate need beyond the size of truncate. But
for xfs, it's passed. This test is base on test 255.

>=20
> With 213 I see it working to Windows, and to Samba test 213 also works
> but only if "strict allocate =3D yes" is set in smb.conf (I just
> verified it on the buildbot)
>=20
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

